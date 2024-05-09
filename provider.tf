terraform {
  required_providers {
    mongodbatlas = {
      source = "mongodb/mongodbatlas"
      version = ">= 0.13"
    }
    aws = {
      source = "hashicorp/aws"
      region = var.region
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