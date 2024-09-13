resource "helm_release" "nginx_ingress" {
  depends_on = [ helm_release.karpenter ]

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
  count = 0

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

resource "helm_release" "karpenter" {
  # depends_on = [ helm_release.karpenter-crd ]

  name      = "karpenter"
  namespace = "karpenter-beta"

  atomic           = true
  cleanup_on_fail  = true
  create_namespace = true
  force_update     = true
  recreate_pods    = true
  timeout          = 120
  # skip_crds = true

  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = "v0.34.0"

  # values = [file("${path.module}/files/values/karpenter.yaml")]

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter.iam_role_arn
  }

  set {
    name  = "settings.clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "settings.interruptionQueue"
    value = "Karpenter-${module.eks.cluster_name}"
  }

  set {
    name = "replicas"
    value = 1
  }
}

resource "helm_release" "karpenter-crd" {
  count = 0
  
  name      = "karpenter-crd"
  namespace = "karpenter-beta"

  atomic           = true
  cleanup_on_fail  = true
  create_namespace = true
  force_update     = true
  recreate_pods    = true
  timeout          = 60

  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter-crd"
  version    = "v0.34.0"

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = module.karpenter.iam_role_arn
  }

  set {
    name  = "settings.clusterName"
    value = module.eks.cluster_name
  }

  set {
    name  = "settings.interruptionQueue"
    value = "Karpenter-${module.eks.cluster_name}"
  }
}