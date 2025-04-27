variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region to deploy resources"
  type        = string
}
variable "zone" {
  description = "GCP zone within the region"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "authorized_network" {
  description = "The full name of the Google Compute Engine network to which the instance is connected"
  type        = string
}

variable "sa_account" {
  description = "Service account email"
  type        = string
  default = "default"
}
variable "armor_policy_name" {
  description = "Cloud Armor policy name"
  type        = string
  
}
variable "instance_name" {
  description = "Name of the VM instance"
  type        = string
}
variable "machine_type" {
  description = "Machine type for the VM instance"
  type        = string
}