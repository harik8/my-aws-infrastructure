provider "aws" {
  region = var.aws_region

  assume_role {
    role_arn     = "arn:aws:iam::${var.account_id}:role/InfraAsCode"
    session_name = "InfraAsCode"
  }
}

data "aws_availability_zones" "available" {}

data "aws_caller_identity" "current" {}

data "aws_ami" "main" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn-ami-vpc-nat-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 3)

  private_subnet_tags = merge(
    module.tag.default_tags,
    {
      Name                     = join("-", [module.tag.default_tags["Prefix"], "private"]),
      Description              = "The private subnet of vpc main",
      "karpenter.sh/discovery" = "acb-eun1-sandbox-eks"
    }
  )

  public_subnet_tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Prefix"], "public"])
      Description = "The public subnet of vpc main"
    }
  )

  nat_instance_tags = merge(
    module.tag.default_tags,
    {
      Name        = join("-", [module.tag.default_tags["Prefix"], "nat"])
      Description = "The NAT instance of vpc main"
    }
  )

  intra_subnet_tags = merge(
    module.tag.default_tags,
    {
      Name                     = join("-", [module.tag.default_tags["Prefix"], "intra"]),
      Description              = "The intra subnet of vpc main",
      "kubernetes.io/role/cni" = 1
    }
  )
}

module "tag" {
  source = "github.com/harik8/tofu-modules//modules/tag?ref=main"

  description = var.tags.description
  utilization = var.tags.utilization
  workload    = var.tags.workload
  owner       = var.tags.owner
}

module "vpc" {
  source = "github.com/terraform-aws-modules/terraform-aws-vpc?ref=v5.8.1"

  cidr = var.vpc_cidr

  azs                = local.azs
  enable_nat_gateway = false
  single_nat_gateway = false

  private_subnets = [for k in range(0, length(local.azs)) : cidrsubnet(var.vpc_cidr, 8, k + 8)]
  public_subnets  = [for k in range(0, length(local.azs)) : cidrsubnet(var.vpc_cidr, 12, k + 8)]
  intra_subnets   = [for k in range(0, length(local.azs)) : cidrsubnet(var.vpc_cidr, 8, k + 12)]

  private_subnet_tags      = local.private_subnet_tags
  public_subnet_tags       = local.public_subnet_tags
  intra_subnet_tags        = local.intra_subnet_tags
  private_route_table_tags = local.private_subnet_tags
  public_route_table_tags  = local.public_subnet_tags

  tags = module.tag.default_tags
}

#----------------#
#  NAT INSTANCE  #              
#----------------#     

resource "aws_instance" "nat" {
  ami                         = data.aws_ami.main.id
  instance_type               = "t3.nano"
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.nat.id]
  source_dest_check           = false
  ipv6_address_count          = 0

  iam_instance_profile = aws_iam_instance_profile.nat.name

  tags = local.nat_instance_tags
}

resource "aws_iam_role" "nat" {
  name = local.nat_instance_tags["Name"]

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : "sts:AssumeRole",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.nat_instance_tags
}

resource "aws_iam_role_policy_attachment" "nat" {
  role       = aws_iam_role.nat.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "nat" {
  name = local.nat_instance_tags["Name"]
  role = aws_iam_role.nat.name
}

resource "aws_security_group" "nat" {
  name   = local.nat_instance_tags["Name"]
  vpc_id = module.vpc.vpc_id

  tags = local.nat_instance_tags
}

resource "aws_security_group_rule" "nat_ingress" {
  type              = "ingress"
  security_group_id = aws_security_group.nat.id
  cidr_blocks       = [module.vpc.vpc_cidr_block]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

resource "aws_security_group_rule" "nat_egress" {
  type              = "egress"
  security_group_id = aws_security_group.nat.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

resource "aws_route" "nat" {
  count = length(module.vpc.private_route_table_ids)

  route_table_id         = module.vpc.private_route_table_ids[count.index]
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = aws_instance.nat.primary_network_interface_id
}