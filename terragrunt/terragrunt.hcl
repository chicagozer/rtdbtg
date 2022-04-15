inputs = {
  domain      = "coxeksdemo.com"
  aws_account = "015614266771"
}

terraform {

  extra_arguments "plugin_dir" {
    commands = [
      "init",
      "plan",
      "apply",
      "refresh",
      "destroy",
      "output",
      "run-all"
    ]

    arguments = ["-compact-warnings"]

   env_vars = {
     TF_PLUGIN_CACHE_DIR = "/tmp/plugins",
   }
 }

  extra_arguments "vars" {
    #    commands = ["init","plan","refresh"]
    commands = get_terraform_commands_that_need_vars()

    optional_var_files = [
      "${find_in_parent_folders("appversion.tfvars.json", "ignore")}",
      "${find_in_parent_folders("namespace.tfvars", "ignore")}"
    ]
  }
}


remote_state {
  #  backend = "consul"
  #  config = {
  #    address = "consul-server.consul:8500"
  #    scheme = "http"
  #    path = "tfstate/${path_relative_to_include()}/terraform.tfstate"
  #  }
  backend = "s3"
  config = {
    bucket         = "coxeksdemo-tfstate"
    key            = "tfstate/${path_relative_to_include()}/terraform.tfstate"
    region         = "us-east-2"
    encrypt        = true
    dynamodb_table = "coxeksdemo-tfstate"
  }
}
