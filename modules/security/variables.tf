variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "network_id" {
  description = "ID of the VPC network"
  type        = string
}

variable "service_account_name" {
  description = "Name for service account"
  type        = string
}

variable "cloud_armor_policy_name" {
  description = "Name for Cloud Armor security policy"
  type        = string
}