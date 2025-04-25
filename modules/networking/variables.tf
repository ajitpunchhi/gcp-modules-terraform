variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.0.0/24"
}

variable "private_subnet_01_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_02_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.2.0/24"
}
variable "private_subnet_03_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.3.0/24"
}
variable "private_subnet_04_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.4.0/24"
}
variable "private_subnet_05_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.0.5.0/24"
}
variable "k8s_pods_cidr" {
  description = "CIDR block for Kubernetes pods"
  type        = string
  default     = "20.1.0.0/16"
}

variable "k8s_services_cidr" {
  description = "CIDR block for Kubernetes services"
  type        = string
  default     = "20.2.0.0/16"
}
variable "mtu" {
  description = "MTU size for the VPC"
  type        = number
  default     = 1460
  
}


# NAT Gateway
variable "name" {
  description = "Name prefix for the NAT resources"
  type        = string
  default     = "nat-gateway"
}

variable "nat_ip_allocate_option" {
  description = "How external IPs should be allocated for the NAT. Options are AUTO_ONLY or MANUAL_ONLY."
  type        = string
  default     = "AUTO_ONLY"
}

variable "source_subnetwork_ip_ranges_to_nat" {
  description = "How NAT should be configured per Subnetwork. Options are ALL_SUBNETWORKS_ALL_IP_RANGES, ALL_SUBNETWORKS_ALL_PRIMARY_IP_RANGES, or LIST_OF_SUBNETWORKS"
  type        = string
  default     = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

variable "nat_ips" {
  description = "List of self_links of external IPs. Required if NAT_IP_ALLOCATE_OPTION is MANUAL_ONLY"
  type        = list(string)
  default     = []
}

variable "min_ports_per_vm" {
  description = "Minimum number of ports allocated to a VM from this NAT"
  type        = number
  default     = 64
}

variable "udp_idle_timeout_sec" {
  description = "Timeout (in seconds) for UDP connections"
  type        = number
  default     = 30
}

variable "icmp_idle_timeout_sec" {
  description = "Timeout (in seconds) for ICMP connections"
  type        = number
  default     = 30
}

variable "tcp_established_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP established connections"
  type        = number
  default     = 1200
}

variable "tcp_transitory_idle_timeout_sec" {
  description = "Timeout (in seconds) for TCP transitory connections"
  type        = number
  default     = 30
}

variable "log_config_enable" {
  description = "Indicates whether to enable logging"
  type        = bool
  default     = false
}

variable "log_config_filter" {
  description = "Specifies the desired filtering of logs. Options are ERRORS_ONLY, TRANSLATIONS_ONLY, or ALL"
  type        = string
  default     = "ALL"
}

variable "subnetworks" {
  description = "List of subnetworks to NAT (used when source_subnetwork_ip_ranges_to_nat = LIST_OF_SUBNETWORKS)"
  type = list(object({
    name                     = string
    source_ip_ranges_to_nat  = list(string)
    secondary_ip_range_names = list(string)
  }))
  default = []
}