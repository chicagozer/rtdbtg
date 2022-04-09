include {
    path = find_in_parent_folders()
}

terraform {
    source = "github.com/chicagozer/hellonode//terraform?ref=main"
}

inputs = {
    repository = "chicagozer/hellonode"
}
