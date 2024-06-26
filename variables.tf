variable "project" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region"
  type        = string
}

variable "vpc_name" {
  description = "The name of the VPC"
  type        = string
}

variable "routing_mode" {
  description = "The routing mode for the VPC"
  type        = string
  default     = "REGIONAL"
}

variable "webapp_subnet_name" {
  description = "Subnet for webapp."
  type        = string
  default     = "webapp"
}

variable "db_subnet_name" {
  description = "Subnet for database."
  type        = string
  default     = "db"
}

variable "webapp_subnet_cidr" {
  description = "The CIDR range for the webapp subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "db_subnet_cidr" {
  description = "The CIDR range for the db subnet"
  type        = string
  default     = "10.0.2.0/24"
}
