variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "network_lb_subnet_id" {
  description = "ID of the subnet for the network load balancer"
  type        = string
}

variable "application_lb_subnet_id" {
  description = "ID of the subnet for the application load balancer"
  type        = string
}

variable "network_lb_instance_groups" {
  description = "List of instance groups for the network load balancer"
  type        = list(string)
  default     = []
}

variable "application_lb_instance_groups" {
  description = "List of instance groups for the application load balancer"
  type        = list(string)
  default     = []
}

variable "security_policy_id" {
  description = "ID of the Cloud Armor security policy"
  type        = string
  default     = ""
}

variable "enable_ssl" {
  description = "Enable SSL for HTTPS"
  type        = bool
  default     = false
}

variable "ssl_certificate" {
  description = "SSL certificate"
  type        = string
  default     = ""
  sensitive   = true
}

variable "ssl_private_key" {
  description = "SSL private key"
  type        = string
  default     = ""
  sensitive   = true
}