resource "helm_release" "nginx_ingress" {
  name       = "ingress-nginx"

  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
}


# wordpress app deployment

resource "helm_release" "wordpress-app" {
  name       = "wordpress-app"
  repository = "./helm-charts"
  chart      = "wordpress-app"

}

# hello app deployment


resource "helm_release" "hello-app" {
  name       = "hello-app"
  repository = "./helm-charts"
  chart      = "hello-app"

}