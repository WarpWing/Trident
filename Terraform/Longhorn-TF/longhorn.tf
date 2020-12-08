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
      App = longhorn
    }
    port {
      port        = 80
      target_port = 5000
    }

    type = "LoadBalancer"
  }
}
