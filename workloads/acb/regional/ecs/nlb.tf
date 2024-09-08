module "nlb_public" {
  source = "github.com/terraform-aws-modules/terraform-aws-alb?ref=v8.7.0"

  name = local.nlb_public_tags["Name"]

  load_balancer_type = "network"
  internal           = false
  vpc_id             = data.terraform_remote_state.vpc.outputs.vpc["vpc_id"]
  subnets            = data.terraform_remote_state.vpc.outputs.vpc["public_subnets"]

  enable_cross_zone_load_balancing = false
  enable_deletion_protection       = false

  target_groups = [
    {
      name                 = join("-", [module.tag.default_tags["Prefix"], "nlb-public"])
      backend_protocol     = "TCP"
      backend_port         = 80
      target_type          = "ip"
      deregistration_delay = 10
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = "traffic-port"
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 2
        matcher             = "200"
      }
    },
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "TLS"
      certificate_arn    = data.terraform_remote_state.acm.outputs.acm["acm_certificate_arn"]
      target_group_index = 0
    }
  ]

  security_groups = [aws_security_group.nlb.id]

  tags = local.nlb_public_tags
}