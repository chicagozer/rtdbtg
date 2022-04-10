provider "helm" {
  kubernetes {
#     config_path = "~/.kube/config"
    }
}

data "aws_secretsmanager_secret" "harness_secret" {
  name = "harness_secret"
}


data "aws_secretsmanager_secret_version" "harness_secret_version" {
  secret_id = "${data.aws_secretsmanager_secret.harness_secret.id}"
}

resource "helm_release" "delegate" {
  count = var.enabled
  name       = "delegate"
  repository = "https://app.harness.io/storage/harness-download/harness-helm-charts/"
  chart      = "harness-delegate"
  
  set {
    name  = "accountId"
    value = var.accountId
  }
  set {
    name  = "accountIdShort"
    value = var.accountIdShort
  }
  set {
    name  = "delegateName"
    value = var.delegateName
  }
  set {
    name  = "delegateProfile"
    value = var.delegateProfile
  }
  set {
    name  = "accountSecret"
    value = data.aws_secretsmanager_secret_version.harness_secret_version.secret_string
  }
  set {
    name  = "delegateType"
    value = "HELM_DELEGATE"
  }
  set {
    name  = "delegateDockerImage"
    value = "harness/delegate:latest"
  }
  set {
    name  = "managerHostAndPort"
    value = "https://app.harness.io/gratis"
  }
  set {
    name  = "watcherStorageUrl"
    value = "https://app.harness.io/public/free/freemium/watchers"
  }
  set {
    name  = "watcherCheckLocation"
    value = "current.version"
  }
  set {
    name  = "remoteWatcherUrlCdn"
    value = "https://app.harness.io/public/shared/watchers/builds"
  }
  set {
    name  = "delegateStorageUrl"
    value = "https://app.harness.io"
  }
  set {
    name  = "useCdn"
    value = true
  }
  set {
    name  = "cdnUrl"
    value = "https://app.harness.io"
  }
  set {
    name  = "jreVersion"
    value = var.jreVersion
  }
}
