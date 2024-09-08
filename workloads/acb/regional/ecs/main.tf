module "tag" {
  source = "github.com/harik8/tofu-modules//modules/tag?ref=main"

  description = var.tags.description
  utilization = var.tags.utilization
  workload    = var.tags.workload
  owner       = var.tags.owner
}

module "ecs" {
  source = "github.com/terraform-aws-modules/terraform-aws-ecs?ref=v5.11.3"

  cluster_name                           = module.tag.default_tags["Name"]
  cloudwatch_log_group_retention_in_days = var.cloudwatch_log_group_retention_in_days
  create_task_exec_iam_role              = true
  cluster_service_connect_defaults       = { namespace = aws_service_discovery_http_namespace.this.arn}

  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/${module.tag.default_tags["Name"]}"
      }
    }
  }

  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  tags = module.tag.default_tags

}

resource "aws_service_discovery_http_namespace" "this" {
  name = module.tag.default_tags["Name"]
  tags = module.tag.default_tags
}