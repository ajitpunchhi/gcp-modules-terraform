variable "project_id" {
  description = "The GCP project ID"
  type        = string
}

variable "vpc_id" {
  description = "Network id"
  type = string
  
}

variable "subnet_id" {
  description = "subnet id"
  type = string
  
}

variable "region" {
  description = "The GCP region for regional resources"
  type        = string
  default     = "terraform.tfvars"
}

variable "location" {
  description = "The GCP location (region or zone) for the GKE cluster"
  type        = string
  default     = "asia-southeast1-a"
}

variable "pod_cidr" {
  description = "CIDR range for pods"
  type        = string
  default     = "10.0.6.0/24"
}

variable "svc_cidr" {
  description = "CIDR range for services"
  type        = string
  default     = "10.0.7.0/24"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "gke-cluster"
}

variable "private_cluster_enabled" {
  description = "Whether the cluster has private nodes"
  type        = bool
  default     = true
}

variable "private_endpoint_enabled" {
  description = "Whether the cluster master endpoint is private-only"
  type        = bool
  default     = false
}

variable "master_authorized_networks" {
  description = "List of master authorized networks"
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  default = [
    {
      cidr_block   = "0.0.0.0/0"
      display_name = "All"
    }
  ]
}

variable "network_policy_enabled" {
  description = "Whether to enable network policy"
  type        = bool
  default     = true
}

variable "http_load_balancing_enabled" {
  description = "Whether to enable HTTP load balancing"
  type        = bool
  default     = true
}

variable "horizontal_pod_autoscaling_enabled" {
  description = "Whether to enable horizontal pod autoscaling"
  type        = bool
  default     = true
}

variable "logging_service" {
  description = "The logging service to use"
  type        = string
  default     = "logging.googleapis.com/kubernetes"
}

variable "monitoring_service" {
  description = "The monitoring service to use"
  type        = string
  default     = "monitoring.googleapis.com/kubernetes"
}

variable "maintenance_start_time" {
  description = "Start time for maintenance window"
  type        = string
  default     = "2025-01-02T01:04:05"
}

variable "maintenance_end_time" {
  description = "End time for maintenance window"
  type        = string
  default     = "2025-11-02T04:04:05"
}

variable "maintenance_recurrence" {
  description = "Recurrence for maintenance window"
  type        = string
  default     = "FREQ=WEEKLY;BYDAY=SA,SU"
}

variable "release_channel" {
  description = "Release channel for GKE cluster"
  type        = string
  default     = "REGULAR"
}

# Node pool variables
variable "initial_node_count" {
  description = "Initial number of nodes per zone"
  type        = number
  default     = 1
}

variable "min_node_count" {
  description = "Minimum number of nodes per zone"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Maximum number of nodes per zone"
  type        = number
  default     = 2
}

variable "preemptible" {
  description = "Whether to use preemptible nodes"
  type        = bool
  default     = false
}

variable "machine_type" {
  description = "Machine type for nodes"
  type        = string
  default     = "e2-standard-2"
}

variable "disk_size_gb" {
  description = "Disk size in GB for nodes"
  type        = number
  default     = 100
}

variable "disk_type" {
  description = "Disk type for nodes"
  type        = string
  default     = "pd-standard"
}

variable "node_labels" {
  description = "Labels to apply to nodes"
  type        = map(string)
  default     = {}
}

variable "node_taints" {
  description = "Taints to apply to nodes"
  type = list(object({
    key    = string
    value  = string
    effect = string
  }))
  default = []
}

variable "node_tags" {
  description = "Network tags to apply to nodes"
  type        = list(string)
  default     = []
}