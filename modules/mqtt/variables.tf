variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the MQTT broker"
  type        = string
  default     = "e2-medium"
}

variable "data_disk_size" {
  description = "Size of the data disk in GB"
  type        = number
  default     = 50
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "mqtt_username" {
  description = "Username for MQTT authentication"
  type        = string
  default     = "mqttuser"
}

variable "mqtt_password" {
  description = "Password for MQTT authentication"
  type        = string
  default     = ""
  sensitive   = true
}