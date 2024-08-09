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