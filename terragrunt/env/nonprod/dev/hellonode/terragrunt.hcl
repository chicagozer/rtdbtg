include {
    path = find_in_parent_folders()
}

dependency "namespace" {
  config_path = "../namespace"
   mock_outputs = {
   certificate_arn = []
  }
}

terraform {
    source = "github.com/chicagozer/${local.tf_module}//terraform?ref=${local.tf_version}"
}

inputs = {
  certificate_arn = dependency.namespace.outputs.certificate_arn
}


locals {
  # Automatically load environment-level variables
  tf_vars = read_terragrunt_config(find_in_parent_folders("tf.json"))

 tf_version = "${local.tf_vars.locals.tf_version[0]["${local.tf_module}"]}"
 tf_module = "${basename(get_terragrunt_dir())}"

}
