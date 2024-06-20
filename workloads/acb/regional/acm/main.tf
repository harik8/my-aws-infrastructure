module "tag" {
  source = "github.com/harik8/tofu-modules//modules/tag?ref=main"

  description = var.tags.description
  utilization = var.tags.utilization
  workload    = var.tags.workload
  owner       = var.tags.owner
}

module "acm" {
  source = "github.com/terraform-aws-modules/terraform-aws-acm?ref=v5.0.1"

  domain_name = var.domain_name
  zone_id     = var.zone_id

  validation_method = "DNS"
  subject_alternative_names = var.subject_alternative_names
  create_route53_records = false

  tags = module.tag.default_tags
}
