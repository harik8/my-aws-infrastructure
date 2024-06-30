module "tag" {
  #  source = "github.com/harik8/tofu-modules//modules/tag?ref=main"
  source = "/home/hari-karthigasu/Private/Git/tofu-modules/modules/tag"

  description = var.tags.description
  utilization = var.tags.utilization
  workload    = var.tags.workload
  owner       = var.tags.owner
  global      = var.tags.global
}