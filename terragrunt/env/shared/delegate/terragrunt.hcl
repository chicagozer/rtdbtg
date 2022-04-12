include {
  path = find_in_parent_folders()
}

terraform {
  source = "github.com/chicagozer/rtdbtg//terraform/delegate?ref=${local.tf_version}"
}

locals {
  # Automatically load environment-level variables
  tf_vars = read_terragrunt_config(find_in_parent_folders("tf.json"))

  tf_version = "${local.tf_vars.locals.tf_version[0]["${local.tf_module}"]}"
  tf_module  = "${basename(get_terragrunt_dir())}"

}

inputs = {
  accountId       = "4GuaSF49R9G7-5XRHSC8cA"
  accountIdShort  = "guasfr"
  delegateName    = "eksdemo"
  delegateProfile = "vlf3GjJ6QBC2RqgtCYT8EQ"
}
