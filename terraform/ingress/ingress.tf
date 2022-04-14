resource "kubernetes_ingress" "canary" {
  metadata {
    name = var.service
    annotations = {
      "alb.ingress.kubernetes.io/certificate-arn" = var.acm_certificate_arn
      "alb.ingress.kubernetes.io/group.name"      = var.groupName
      "alb.ingress.kubernetes.io/listen-ports"    = "[{\"HTTP\": 80}, {\"HTTPS\":443}]"
      "alb.ingress.kubernetes.io/scheme"          = "internet-facing"
      "kubernetes.io/ingress.class"               = "alb"
      "alb.ingress.kubernetes.io/actions.forward-multiple-tg" = jsonencode({
        "type" : "forward",
        "forwardConfig" : {
          "targetGroups" : [
            {
              "serviceName" : "${var.service}",
              "servicePort" : 80,
              "weight" : "${var.weight.0}"
            },
            {
              "serviceName" : "${var.service}-canary",
              "servicePort" : 80,
              "weight" : "${var.weight.1}"
            }
          ]
        }
      })
    }
  }

  spec {
    rule {
      http {
        path {
          backend {
            service_name = "forward-multiple-tg"
            service_port = "use-annotation"
          }

          path = "/*"
        }

      }
    }
  }
}
