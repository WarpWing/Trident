terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {}

resource "kubernetes_namespace" "longhorn" {
  metadata {
    name = "terraform-longhorn"
  }
}

resource "kubernetes_deployment" "longhorn" {
  metadata {
    name = "longhorn"
    namespace = "terraform-longhorn"
    labels = {
      App = "longhorn"
    }
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        App = "longhorn"
      }
    }
    template {
      metadata {
        labels = {
          App = "longhorn"
        }
      }
      spec {
        container {
          image = "warpwing/longhornprod:latest"
          name  = "longhorn"

          port {
            container_port = 5000
          }

          resources {
            limits {
              cpu    = "0.7"
              memory = "900Mi"
            }
            requests {
              cpu    = "250m"
              memory = "500Mi"
            }
          }
        }
      }
    }
  }
} 

resource "kubernetes_service" "longhorn" {
  metadata {
    name = "longhorn"
    namespace = "terraform-longhorn"
  }
  spec {
    selector = {
      App = kubernetes_deployment.longhorn.spec.0.template.0.metadata[0].labels.App
    }
    port {

      port        = 5000
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}
