# Variables
variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP Region"
  type        = string
  default = "asia-southeast1"
}
variable "vpc_id" {
    type = string
    default = "default"  
}

variable "subnet_id" {
    type = string
    default = "default"   
}
variable "zones" {
  description = "List of zones for Cassandra nodes (should be in the same region)"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "Name of the Cassandra cluster"
  type        = string
  default     = "cassandra-cluster"
}

variable "node_count" {
  description = "Number of Cassandra nodes"
  type        = number
  default     = 2
}

variable "machine_type" {
  description = "Machine type for Cassandra nodes"
  type        = string
  default     = "n2-standard-4"
}

variable "image" {
  description = "OS image for Cassandra nodes"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 100
}

variable "data_disk_size" {
  description = "Data disk size in GB for Cassandra data"
  type        = number
  default     = 500
}

variable "data_disk_type" {
  description = "Data disk type for Cassandra data"
  type        = string
  default     = "pd-ssd"
}

variable "network" {
  description = "Network to deploy to"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "Subnetwork to deploy to"
  type        = string
  default     = "default"
}

variable "cassandra_version" {
  description = "Cassandra version to install"
  type        = string
  default     = "4.1.1"
}

variable "tags" {
  description = "Network tags for Cassandra instances"
  type        = list(string)
  default     = ["cassandra"]
}

variable "service_account_email" {
  description = "Service account email for GCE instances"
  type        = string
  default     = ""
}

variable "ssh_keys" {
  description = "SSH keys for accessing the instances"
  type        = string
  default     = ""
}
