terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {}


resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "sentinelnginxtest"
    namespace = "terraform-learn"
    labels = {
      App = "sentinelnginxtest"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        App = "sentinelnginxtest"
      }
    }
    template {
      metadata {
        labels = {
          App = "sentinelnginxtest"
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = "sentinelnginxtest"

          port {
            container_port = 80
          }

          resources {
            limits {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
} 

resource "kubernetes_service" "nginx" {
  metadata {
    name = "sentinelnginxtest"
    namespace = "terraform-learn"
  }
  spec {
    selector = {
      App = kubernetes_deployment.nginx.spec.0.template.0.metadata[0].labels.App
    }
    port {
      node_port   = 30201
      port        = 80
      target_port = 80
    }

    type = "NodePort"
  }
}
