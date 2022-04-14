resource "kubernetes_ingress_v1" "canary" {

  lifecycle {
    ignore_changes = [
      # Ignore changes to tags, e.g. because a management agent
      # updates these based on some ruleset managed elsewhere.
      metadata["annotations"]["alb.ingress.kubernetes.io/actions.forward-multiple-tg"],
    ]
  }

  metadata {
    namespace = var.namespace
    name      = var.service
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
      host = "${var.service}.${var.namespace}.${var.domain}"
      http {
        path {
          backend {
            service {
              name = "forward-multiple-tg"
              port {
                name = "use-annotation"
              }
            }
          }

          path      = "/"
          path_type = "Prefix"
        }

      }
    }
    rule {
      host = "${var.service}-canary.${var.namespace}.${var.domain}"
      http {
        path {
          backend {
            service {
              name = "${var.service}-canary"
              port {
                name = "http"
              }
            }
          }

          path      = "/"
          path_type = "Prefix"
        }

      }
    }
    rule {
      host = "${var.service}-release.${var.namespace}.${var.domain}"
      http {
        path {
          backend {
            service {
              name = var.service
              port {
                name = "http"
              }
            }
          }

          path      = "/"
          path_type = "Prefix"
        }

      }
    }
  }
}
