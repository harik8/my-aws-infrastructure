# resource "kubernetes_namespace" "test" {
#   depends_on = [module.eks]

#   metadata {
#     name = "test"
#   }
# }

# resource "kubernetes_deployment" "nginx" {
#   metadata {
#     name      = "nginx-deployment"
#     namespace = kubernetes_namespace.test.metadata[0].name
#     labels = {
#       app = "nginx"
#     }
#   }

#   spec {
#     replicas = 1

#     selector {
#       match_labels = {
#         app = "nginx"
#       }
#     }

#     template {
#       metadata {
#         labels = {
#           app = "nginx"
#         }
#       }

#       spec {
#         toleration {
#           key      = "application"
#           operator = "Equal"
#           value    = "true"
#           effect   = "NoSchedule"
#         }

#         container {
#           name  = "nginx"
#           image = "nginx:latest"

#           port {
#             container_port = 80
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service" "nginx" {
#   metadata {
#     name      = "nginx-service"
#     namespace = kubernetes_namespace.test.metadata[0].name
#     labels = {
#       app = "nginx"
#     }
#   }

#   spec {
#     type = "ClusterIP"

#     port {
#       port        = 80
#       target_port = 80
#     }

#     selector = {
#       app = "nginx"
#     }
#   }
# }

# resource "kubernetes_ingress" "nginx" {
#   metadata {
#     name      = "nginx-ingress"
#     namespace = kubernetes_namespace.test.metadata[0].name
#     annotations = {
#       "nginx.ingress.kubernetes.io/rewrite-target" = "/"
#     }
#   }

#   spec {
#     ingress_class_name = "nginx"

#     rule {
#       host = "nginx-test.forexample.link"

#       http {
#         path {
#           path      = "/"
#           path_type = "Prefix"

#           backend {
#             service {
#               name = kubernetes_service.nginx.metadata[0].name
#               port {
#                 number = 80
#               }
#             }
#           }
#         }
#       }
#     }
#   }
# }
