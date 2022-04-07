terraform {

  extra_arguments "vars" {
    commands = ["init","plan","refresh"]
# get_terraform_commands_that_need_vars()

    optional_var_files = [
      "${find_in_parent_folders("appversion.tfvars.json", "ignore")}"
    ]
  }
}

#generate "backend" {
#  path = "terraform.tf"
#  if_exists = "overwrite_terragrunt"
#  contents = <<EOF
#terraform {
#  required_version = ">= 1.1.0"
#  backend "remote" {
#    hostname = "app.terraform.io"
#    organization = "rheosoft"
#    workspaces {
#     prefix = "rtdb-${path_relative_to_include()}-"
#    }
#}
#}
#EOF
#}

