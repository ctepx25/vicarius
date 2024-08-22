variable "kube_config" {
  type    = string
  default = "~/.kube/config"
}

variable "namespace" {
  type    = string
  default = "default"
}

variable "app_image" {
  type    = string
  default = "595346771173.dkr.ecr.us-east-1.amazonaws.com/vicarius:latest"
  nullable = false
}

variable "app_chart_path" {
  type    = string
  default = "../k8s/simple-flask-app-chart-0.1.0.tgz"
}

provider "helm" {
  # Several Kubernetes authentication methods are possible: https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs#authentication
  kubernetes {
    config_path = pathexpand(var.kube_config)
  }
}

provider "kubernetes" {
  config_path = pathexpand(var.kube_config)
}

resource "helm_release" "flask-app" {
  name       = "flask-app"
  chart      = var.app_chart_path

  set {
    name = "image"
    value = var.app_image
  }
}


data "kubernetes_service" "service" {
  depends_on = [helm_release.flask-app]
  metadata {
    name = "flask-app-service"
  }
}

output "Service" {
  depends_on = [helm_release.flask-app]
  value = "${data.kubernetes_service.service.status.0.load_balancer.0.ingress.0.hostname}"
}

