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

variable "master_ipv4_cidr_block" {
  description = "CIDR block for Kubernetes master nodes"
  type        = string
  default     = "172.16.0.0/28"
}

# Command Layer
variable "command_layer_node_count" {
  description = "Number of nodes in the command layer node pool"
  type        = number
  default     = 2
}

variable "command_layer_machine_type" {
  description = "Machine type for command layer nodes"
  type        = string
  default     = "e2-standard-4"
}

variable "command_layer_min_node_count" {
  description = "Minimum number of nodes in the command layer node pool"
  type        = number
  default     = 1
}

variable "command_layer_max_node_count" {
  description = "Maximum number of nodes in the command layer node pool"
  type        = number
  default     = 5
}

# MDM Layer
variable "mdm_layer_node_count" {
  description = "Number of nodes in the MDM layer node pool"
  type        = number
  default     = 2
}

variable "mdm_layer_machine_type" {
  description = "Machine type for MDM layer nodes"
  type        = string
  default     = "e2-standard-4"
}

variable "mdm_layer_min_node_count" {
  description = "Minimum number of nodes in the MDM layer node pool"
  type        = number
  default     = 1
}

variable "mdm_layer_max_node_count" {
  description = "Maximum number of nodes in the MDM layer node pool"
  type        = number
  default     = 5
}

# Raw Layer
variable "raw_layer_node_count" {
  description = "Number of nodes in the raw layer node pool"
  type        = number
  default     = 2
}

variable "raw_layer_machine_type" {
  description = "Machine type for raw layer nodes"
  type        = string
  default     = "e2-standard-8"
}

variable "raw_layer_min_node_count" {
  description = "Minimum number of nodes in the raw layer node pool"
  type        = number
  default     = 1
}

variable "raw_layer_max_node_count" {
  description = "Maximum number of nodes in the raw layer node pool"
  type        = number
  default     = 5
}

# Meter Layer
variable "meter_layer_node_count" {
  description = "Number of nodes in the meter layer node pool"
  type        = number
  default     = 2
}

variable "meter_layer_machine_type" {
  description = "Machine type for meter layer nodes"
  type        = string
  default     = "e2-standard-4"
}

variable "meter_layer_min_node_count" {
  description = "Minimum number of nodes in the meter layer node pool"
  type        = number
  default     = 1
}

variable "meter_layer_max_node_count" {
  description = "Maximum number of nodes in the meter layer node pool"
  type        = number
  default     = 5
}

# Network Layer
variable "network_layer_node_count" {
  description = "Number of nodes in the network layer node pool"
  type        = number
  default     = 2
}

variable "network_layer_machine_type" {
  description = "Machine type for network layer nodes"
  type        = string
  default     = "e2-standard-4"
}

variable "network_layer_min_node_count" {
  description = "Minimum number of nodes in the network layer node pool"
  type        = number
  default     = 1
}

variable "network_layer_max_node_count" {
  description = "Maximum number of nodes in the network layer node pool"
  type        = number
  default     = 5
}