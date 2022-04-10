provider "helm" {
  kubernetes {
#     config_path = "~/.kube/config"
    }
}

resource "kubernetes_namespace" "namespace" {
  count = var.enabled
  metadata {
    name = var.namespace
  }
}
