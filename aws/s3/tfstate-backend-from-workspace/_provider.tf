terraform {

  required_version = ">= 0.15"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

}

provider "aws" {
  region = local.settings.region
}