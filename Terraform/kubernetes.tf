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
    name = "SentinelNginxTest"
    labels = {
      App = "SentinelNginxTest"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "SentinelNginxTest"
      }
    }
    template {
      metadata {
        labels = {
          App = "SentinelNginxTest"
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = "SentinelNginxTest"

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