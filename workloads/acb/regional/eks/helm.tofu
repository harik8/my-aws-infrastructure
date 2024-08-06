resource "helm_release" "nginx_ingress" {
  name      = "nginx-ingress"
  namespace = "nginx-ingress"

  atomic           = true
  cleanup_on_fail  = true
  create_namespace = true
  force_update     = true
  recreate_pods    = true

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = local.nginx_ingress

  values = [file("${path.module}/files/values/nginx.yaml")]
}

resource "helm_release" "loki_stack" {
  name      = "loki-stack"
  namespace = "loki"

  atomic           = true
  cleanup_on_fail  = true
  create_namespace = true
  force_update     = true
  recreate_pods    = true

  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-stack"
  version    = local.loki_stack

  values = [file("${path.module}/files/values/loki.yaml")]
}
