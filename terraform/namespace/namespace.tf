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

data "aws_secretsmanager_secret" "newrelic" {
  name = "newrelic_license"
}


data "aws_secretsmanager_secret_version" "newrelic" {
  secret_id = data.aws_secretsmanager_secret.newrelic.id
}

resource "kubernetes_config_map" "newrelic" {
  count = var.enabled
  metadata {
    name = "newrelic-license"
    namespace = kubernetes_namespace.namespace.0.name
  }

  data = {
    license = data.aws_secretsmanager_secret_version.newrelic.secret_string
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
  count   = var.enabled
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
  count   = var.enabled
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "*.${var.namespace}.${data.aws_route53_zone.zone.name}"
  type    = "A"

  alias {
    name                   = aws_route53_record.namespace[0].name
    zone_id                = aws_route53_record.namespace[0].zone_id
    evaluate_target_health = true
  }
}


resource "aws_acm_certificate" "cert" {
  count             = var.enabled
  domain_name       = "*.${var.namespace}.${data.aws_route53_zone.zone.name}"
  validation_method = "DNS"

  #tags = "${local.tags}"
}

output "acm_certificate_arn" {
  value = length(aws_acm_certificate.cert) > 0 ? aws_acm_certificate.cert.0.arn : ""
}

resource "aws_route53_record" "cert_validation" {
  count   = var.enabled
  name    = tolist(aws_acm_certificate.cert[0].domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.cert[0].domain_validation_options)[0].resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  records = ["${tolist(aws_acm_certificate.cert[0].domain_validation_options)[0].resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  count                   = var.enabled
  certificate_arn         = aws_acm_certificate.cert[0].arn
  validation_record_fqdns = ["${aws_route53_record.cert_validation[0].fqdn}"]
}



