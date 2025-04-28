variable "name" {
  description = "Name of the Redis instance"
  type        = string
}

variable "region" {
  description = "Region where Memorystore will be deployed"
  type        = string
}
variable "project_id" {
  description = "Project ID where the Redis instance will be created"
  type        = string
  default     = "default"  
}

variable "tier" {
  description = "Service tier of the instance. Either BASIC or STANDARD_HA."
  type        = string
  default     = "STANDARD_HA"
}

variable "memory_size_gb" {
  description = "Redis memory size in GB"
  type        = number
}

variable "authorized_network" {
  description = "VPC network to which the instance is connected (full self link or ID)"
  type        = string
  default     = "projects/your-gcp-project-id/global/networks/your-vpc-network"
}

variable "redis_version" {
  description = "Version of Redis software"
  type        = string
  default     = "REDIS_6_X"
}

variable "transit_encryption_mode" {
  description = "The TLS mode, either DISABLED or SERVER_AUTHENTICATION"
  type        = string
  default     = "DISABLED"
}

variable "labels" {
  description = "Resource labels"
  type        = map(string)
  default     = {default = "dev"}
}

variable "maintenance_day" {
  description = "Day of the week for maintenance (e.g., MONDAY, TUESDAY)"
  type        = string
  default     = "MONDAY"
}

variable "maintenance_start_hour" {
  description = "Hour when maintenance begins (0-23)"
  type        = number
  default     = 1
}

variable "maintenance_start_min" {
  description = "Minute when maintenance begins (0-59)"
  type        = number
  default     = 0
}

