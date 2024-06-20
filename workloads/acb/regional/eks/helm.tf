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
  version    = "4.10.1"

  values = [file("${path.module}/files/values/nginx.yaml")]
}
