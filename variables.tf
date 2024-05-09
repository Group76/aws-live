variable "region" {
  type = string
  default = "us-east-2"
}

variable "organization" {
  type = string
  default = "group76"
}

variable "workspace" {
  type = string
  default = "aws-infrastructure-live"
}

# Atlas Organization ID 
variable "atlas_org_id" {
  type        = string
  description = "Atlas Organization ID"
  default = "663b5bd2f5133b63245e8ff5"
}
# Atlas Project Name
variable "atlas_project_name" {
  type        = string
  description = "Atlas Project Name"
  default = "group76"
}

# Atlas Project Environment
variable "environment" {
  type        = string
  description = "The environment to be built"
  default = "dev"
}

# Cluster Instance Size Name 
variable "cluster_instance_size_name" {
  type        = string
  description = "Cluster instance size name"
  default = "M0"
}

# Cloud Provider to Host Atlas Cluster
variable "cloud_provider" {
  type        = string
  description = "AWS or GCP or Azure"
  default = "AWS"
}

# Atlas Region
variable "atlas_region" {
  type        = string
  description = "Atlas region where resources will be created"
  default = "US_EAST_2"
}

# MongoDB Version 
variable "mongodb_version" {
  type        = string
  description = "MongoDB Version"
  default = "6.0"
}

# IP Address Access
variable "ip_address" {
  type = string
  description = "IP address used to access Atlas cluster"
  default = "179.222.164.199"
}

# AWS Region
variable "aws_region" {
  type = string
  description = "AWS Region"
  default = "us-east-2"
}