variable "region" {
  default = "us-east-2"
}

variable "namespace" {
  default = "nonprod"
}

variable "enabled" {
  default = 1
}

variable "tag" {
  default = "latest"
}

variable "cluster" {
  default = "jem-test"
}

variable "domain" {
  default = "coxeksdemo.com"
}

variable "app_version" {
  type        = map(any)
  description = "version to deploy"
}

variable "chart_version" {
  type        = map(any)
  description = "version to deploy"
}

