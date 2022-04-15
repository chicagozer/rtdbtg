include {
  path = find_in_parent_folders()
}

terraform {
  source = "git::ssh://git@ghe.coxautoinc.com/XTime/harness-tg.git//terraform/alb?ref=${local.tf_version}"
}

locals {
  # Automatically load environment-level variables
  tf_vars = read_terragrunt_config(find_in_parent_folders("tf.json"))

  tf_version = "${local.tf_vars.locals.tf_version[0]["${local.tf_module}"]}"
  tf_module  = "${basename(get_terragrunt_dir())}"

}

inputs = {
  clusterName = "jem-test"
}
