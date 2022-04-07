include {
    path = find_in_parent_folders()
}

terraform {
    source = "github.com/chicagozer/helloworld//terraform?ref=main"
}


inputs = {
    namespace="prod"
}
