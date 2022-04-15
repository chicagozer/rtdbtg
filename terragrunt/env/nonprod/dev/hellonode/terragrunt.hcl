include {
  path = find_in_parent_folders()
}

dependencies {
  paths = get_env("TG_IGNORE_DEPENDENCIES","false") == "true" ? [] : ["../hellonode-ingress"]
}

dependency "namespace" {
  config_path = "../namespace"
  mock_outputs = {
    acm_certificate_arn = ""
  }
}

terraform {
  source = "git::ssh://git@ghe.coxautoinc.com/DMS/harness-hellonode.git//terraform?ref=${local.tf_version}"
}

inputs = {
  acm_certificate_arn = dependency.namespace.outputs.acm_certificate_arn
}


locals {
  # Automatically load environment-level variables
  tf_vars = read_terragrunt_config(find_in_parent_folders("tf.json"))

  tf_version = "${local.tf_vars.locals.tf_version[0]["${local.tf_module}"]}"
  tf_module  = "${basename(get_terragrunt_dir())}"

}
