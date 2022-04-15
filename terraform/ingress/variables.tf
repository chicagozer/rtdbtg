variable "region" {
  default = "us-east-2"
}

variable "enabled" {
  default = 1
}

variable "groupName" {
  default = "demo-ingress"
}

variable "weight" {
  default = [100, 0]
}

variable "namespace" {
}

variable "service" {
}

variable "domain" {
}

variable "acm_certificate_arn" {
}
