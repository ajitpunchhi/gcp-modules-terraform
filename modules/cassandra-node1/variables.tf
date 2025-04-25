# modules/cassandra-node/main.tf

variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "region" {
  description = "The GCP region where resources will be created"
  type        = string
}

variable "instance_name" {
  description = "Name for the Cassandra instance"
  type        = string
  default     = "cassandra-node"
}

variable "machine_type" {
  description = "Machine type for the Cassandra instance"
  type        = string
  default     = "n2-standard-2"
}

variable "network" {
  description = "The VPC network to attach the instance to"
  type        = string
  default     = "default"
}

variable "subnetwork" {
  description = "The subnetwork to attach the instance to"
  type        = string
  default     = "default"
}

variable "cassandra_version" {
  description = "Version of Cassandra to install"
  type        = string
  default     = "4.1.3"
}

variable "disk_size_gb" {
  description = "Boot disk size in GB"
  type        = number
  default     = 10
}
variable "zone" {
  description = "zone name"
  type        = string
  default     = "asia-southeast1-a"
  
}
variable "disk_type" {
  description = "Boot disk type"
  type        = string
  default     = "pd-ssd"
}

variable "cassandra_seeds" {
  description = "List of Cassandra seed node IPs"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "Name of the Cassandra cluster"
  type        = string
  default     = "cassandra-cluster"
}

variable "datacenter_name" {
  description = "Name of the Cassandra datacenter"
  type        = string
  default     = "dc1"
}

variable "tags" {
  description = "Network tags for the instance"
  type        = list(string)
  default     = ["cassandra"]
}