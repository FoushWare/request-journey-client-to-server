terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }

  # Remote state in S3 + DynamoDB lock
  # See README.md for one-time setup instructions
  backend "s3" {
    bucket         = "notes-app-terraform-state"
    key            = "notes-app/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "notes-app-terraform-locks"
  }
}
