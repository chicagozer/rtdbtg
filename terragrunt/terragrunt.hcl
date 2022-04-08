terraform {
 
  extra_arguments "vars" {
#    commands = ["init","plan","refresh"]
     commands = [ "get_terraform_commands_that_need_vars()"]

    optional_var_files = [
      "${find_in_parent_folders("appversion.tfvars.json", "ignore")}"
    ]
  }
}


remote_state {
  backend = "consul"
  config = {
    address = "consul-server.consul:8500"
    scheme = "http"
    path = "tfstate/${path_relative_to_include()}/terraform.tfstate"
  }
}
