terraform {
  required_providers {
    aws = {
      version = ">= 3.28.0"
      source  = "hashicorp/aws"
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

provider "aws" {
  region = local.settings.tags_common.region
}

