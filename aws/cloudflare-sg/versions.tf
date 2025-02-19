
terraform {
  required_version = ">= 1.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0.0, < 6.0.0"
    }
    http = {
      source  = "hashicorp/http"
      version = ">= 2.0.0, < 3.0.0"
    }
  }
}
