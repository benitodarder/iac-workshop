terraform {

  required_version = ">= 1.0.5"

  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "2.4.3"
    }
    random = {
      source  = "hashicorp/random"
      version = ">=2.3.0"
    }
  }

  backend "s3" {
    encrypt = true
  }

}

provider "vsphere" {

  vsphere_server = local.settings.cluster.endpoint

  allow_unverified_ssl = local.settings.cluster.self_certificate
}
