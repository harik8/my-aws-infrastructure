#-----------------#
#  FRPS INSTANCE  #              
#-----------------#

resource "aws_instance" "frps" {
  ami                         = data.aws_ami.al2023_arm64.id
  instance_type               = "t4g.nano"
  subnet_id                   = module.vpc.public_subnets[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.frps.id]
  source_dest_check           = true

  user_data = base64encode(templatefile("templates/frps_user_data.sh", {
    FRPS_PLAYBOOK_S3_ENDPOINT = var.frps_playbook_s3_endpoint
    FRPS_PLAYBOOK_VARS        = var.frps_playbook_vars
    AWS_REGION                = var.aws_region
    }
  ))

  root_block_device {
    volume_type = "gp3"
    encrypted   = true

    tags = {
      Name = "${terraform.workspace}-frps"
    }
  }

  iam_instance_profile = aws_iam_instance_profile.frps.name

  tags = {
    Name = "${terraform.workspace}-frps"
  }
}

resource "aws_iam_role" "frps" {
  name = "${terraform.workspace}-frps"

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

  managed_policy_arns = [aws_iam_policy.frps_policies.arn, "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore", "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"]

  tags = {
    Name = "${terraform.workspace}-frps"
  }
}

resource "aws_iam_policy" "frps_policies" {
  name = "${terraform.workspace}-frps"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = "sts:AssumeRole"
        Effect   = "Allow"
        Resource = "arn:aws:iam::${var.manage_account_id}:role/service-role/r53-role-g7qf0ica"
      },
      {
        Action = "ssm:SendCommand"
        Effect = "Allow"
        Resource = [
          "arn:aws:ec2:${var.aws_region}:${var.account_id}:instance/*",
          "arn:aws:ssm:${var.aws_region}::document/AWS-ApplyAnsiblePlaybooks"
        ]
      }
    ]
  })
}

resource "aws_iam_instance_profile" "frps" {
  name = "${terraform.workspace}-frps"
  role = aws_iam_role.frps.name
}

resource "aws_security_group" "frps" {
  name   = "${terraform.workspace}-frps"
  vpc_id = module.vpc.vpc_id

  tags = {
    Name = "${terraform.workspace}-frps"
  }
}

resource "aws_security_group_rule" "http" {
  type              = "ingress"
  security_group_id = aws_security_group.frps.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  protocol          = "TCP"
}

resource "aws_security_group_rule" "https" {
  type              = "ingress"
  security_group_id = aws_security_group.frps.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 443
  to_port           = 443
  protocol          = "TCP"
}

resource "aws_security_group_rule" "frps" {
  type              = "ingress"
  security_group_id = aws_security_group.frps.id
  cidr_blocks       = var.frps_allowed_cidr
  from_port         = 7000
  to_port           = 7000
  protocol          = "TCP"
}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  security_group_id = aws_security_group.frps.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

#-----------------#
#  TEST INSTANCE  #              
#-----------------#

resource "aws_instance" "test" {
  count = var.enable_test_instance ? 1 : 0

  ami                         = data.aws_ami.al2023_arm64.id
  instance_type               = "t4g.nano"
  subnet_id                   = module.vpc.private_subnets[0]
  associate_public_ip_address = false
  vpc_security_group_ids      = [aws_security_group.frps.id]
  source_dest_check           = true

  user_data = <<-EOF
                    #!/bin/bash

                    set -e
                    echo "Hello, World!!!"
                 EOF

  root_block_device {
    volume_type = "gp3"
    encrypted   = true

    tags = {
      Name = "${terraform.workspace}-test"
    }
  }

  iam_instance_profile = aws_iam_instance_profile.test[count.index].name

  tags = {
    Name = "${terraform.workspace}-test"
  }
}

resource "aws_iam_role" "test" {
  count = var.enable_test_instance ? 1 : 0

  name = "${terraform.workspace}-test"

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

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]

  tags = {
    Name = "${terraform.workspace}-test"
  }
}

resource "aws_iam_instance_profile" "test" {
  count = var.enable_test_instance ? 1 : 0

  name = "${terraform.workspace}-test"
  role = aws_iam_role.test[count.index].name
}