provider "helm" {
  kubernetes {
#     config_path = "~/.kube/config"
    }
}

resource "helm_release" "alb" {
  count = var.enabled
  namespace = "kube-system"
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  
  set {
    name  = "clusterName"
    value = var.clusterName
  }
}
