include {
    path = find_in_parent_folders()
}

terraform {
    source = "github.com/chicagozer/hellonode//terraform?ref=${locals.tf_version}"
}

locals {
  # Automatically load environment-level variables
  tf_vars = read_terragrunt_config(find_in_parent_folders("tf.json"))

 tf_version = local.tf_vars.locals.tf_version.hellonode

}
