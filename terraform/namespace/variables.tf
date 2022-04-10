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

variable "app_version" {
  type = map
  description = "version to deploy"
}

