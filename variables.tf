variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "zone" {
  description = "The GCP zone"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "routing_mode" {
  description = "The routing mode for the VPC"
  type        = string
}

variable "webapp_subnet_name" {
  description = "Subnet for webapp."
  type        = string
}

variable "db_subnet_name" {
  description = "Subnet for database."
  type        = string
}

variable "webapp_subnet_cidr" {
  description = "The CIDR range for the webapp subnet"
  type        = string
}

variable "db_subnet_cidr" {
  description = "The CIDR range for the db subnet"
  type        = string
}

variable "custom_image_name" {
  description = "The name of the custom image to use for the compute instance"
  type        = string
}


variable "db_name" {
  description = "Database name"
  type        = string
}

variable "db_user" {
  description = "Database user"
  type        = string
}

variable "db_password" {
  type        = string
  description = "The password for the database user"
}

variable "dns_name" {
  description = "The DNS name for the application"
  type        = string
}

variable "dns_managed_zone" {
  description = "The name of the DNS managed zone"
  type        = string
}

variable "account_id" {
  description = "The ID for the service account"
  type        = string
}

variable "display_name" {
  description = "The display name for the service account"
  type        = string
}