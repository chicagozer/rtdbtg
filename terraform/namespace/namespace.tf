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


data "aws_lb" "ingress" {
   tags = {
     "elbv2.k8s.aws/cluster" = var.cluster
   }
 }


data "aws_route53_zone" "zone" {
  name         = "${var.domain}."
  private_zone = false
}


resource "aws_route53_record" "namespace" {
  count = var.enabled
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "${var.namespace}.${data.aws_route53_zone.zone.name}"
  type    = "A"

   alias {
    name                   = data.aws_lb.ingress.dns_name
    zone_id                = data.aws_lb.ingress.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "wildcard" {
  count = var.enabled
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "*.${var.namespace}.${data.aws_route53_zone.zone.name}"
  type    = "A"

   alias {
    name                   = aws_route53_record.namespace[0].name
    zone_id                = aws_route53_record.namespace[0].zone_id
    evaluate_target_health = true
  }
}
