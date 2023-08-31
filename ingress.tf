resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = "ingress-resource"
        annotations = {
      "kubernetes.io/ingress.class" = "nginx"
       "nginx.ingress.kubernetes.io/ssl-redirect" = "false"
    }
  }

  spec {
    default_backend {
      service {
        name = "wordpress"
        port {
          number = 80
        }
      }
    }

    rule {
      http {
        path {
          backend {
            service {
              name = "wordpress"
              port {
                number = 80
              }
            }
          }

          path = "/"
        }

        path {
          backend {
            service {
              name = "hello-app"
              port {
                number = 8080
              }
            }
          }

          path = "/hello"
        }
      }
    }
  }
}
