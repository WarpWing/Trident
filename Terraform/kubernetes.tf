terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {}


data "kubernetes_namespace" "nginx" {
  metadata {
    name = "terraform-learn"
  }
} 

resource "kubernetes_deployment" "nginx" {
  metadata {
    name = "sentinelnginxtest"
    labels = {
      App = "sentinelnginxtest"
    }
  }

  spec {
    replicas = 1
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