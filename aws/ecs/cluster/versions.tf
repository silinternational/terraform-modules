
terraform {
  required_version = ">= 0.12"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 2.0.0, < 5.0.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.1.0, < 4.0.0"
    }
  }
}
