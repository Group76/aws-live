terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = ">= 0.13"
    }
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  cloud {
    organization = var.organization

    workspaces {
      name = var.workspaces
    }
  }
}

provider "aws" {
  region = var.region
}