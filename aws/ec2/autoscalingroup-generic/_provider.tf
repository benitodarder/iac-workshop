terraform {

  required_version = ">= 0.15"

  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }

  backend "s3" {
    encrypt = true
  }

}

provider "aws" {
  region = local.settings.tags_common.region
}