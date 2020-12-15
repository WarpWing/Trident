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
    name = "terraform-longhorn"
    namespace = "terraform-longhorn"
  }

  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "longhorn"
      }
    }

    template {
      metadata {
        labels = {
          app = "longhorn"
        }
      }

      spec {
        container {
          name  = "terraform-longhorn"
          image = "warpwing/longhornprod:latest"

          port {
            container_port = 5000
          }

          image_pull_policy = "Always"
        }

        termination_grace_period_seconds = 10
      }
    }

    strategy {
      type = "RollingUpdate"

      rolling_update {
        max_surge = "1"
      }
    }

    revision_history_limit = 2
  }
}


resource "kubernetes_service" "longhorn" {
  metadata {
    name = "terraform-longhorn"
    namespace = "terraform-longhorn"

    labels = {
      app = "longhorn"
    }
  }

  spec {
    port {
      protocol    = "TCP"
      port        = 5000
      target_port = "5000"
    }

    selector = {
      app = "longhorn"
    }

    type = "LoadBalancer"
  }
}
