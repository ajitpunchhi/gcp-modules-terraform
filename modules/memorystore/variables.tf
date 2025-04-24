# modules/gcp-memorystore/main.tf

# Variables for the module
variable "project_id" {
  description = "The ID of the project in which the resource belongs"
  type        = string
}

variable "name" {
  description = "The ID of the instance or a fully qualified identifier for the instance"
  type        = string
}

variable "location_id" {
  description = "The zone where the instance will be provisioned"
  type        = string
}

variable "alternative_location_id" {
  description = "Only applicable to STANDARD_HA tier. The zone where the standby instance will be provisioned"
  type        = string
  default     = null
}

variable "memory_size_gb" {
  description = "Redis memory size in GiB"
  type        = number
  default     = 1
}

variable "redis_version" {
  description = "The version of Redis software"
  type        = string
  default     = "REDIS_6_X"
}

variable "tier" {
  description = "The service tier of the instance"
  type        = string
  default     = "BASIC"
  validation {
    condition     = contains(["BASIC", "STANDARD_HA"], var.tier)
    error_message = "Allowed values for tier are \"BASIC\" or \"STANDARD_HA\"."
  }
}

variable "region" {
  description = "The GCP region in which the redis instance will be created"
  type        = string
}

variable "authorized_network" {
  description = "The full name of the Google Compute Engine network to which the instance is connected"
  type        = string
  default = "10.0.4.0/24"
}

variable "connect_mode" {
  description = "The connect mode of the Redis instance"
  type        = string
  default     = "DIRECT_PEERING"
  validation {
    condition     = contains(["DIRECT_PEERING", "PRIVATE_SERVICE_ACCESS"], var.connect_mode)
    error_message = "Allowed values for connect_mode are \"DIRECT_PEERING\" or \"PRIVATE_SERVICE_ACCESS\"."
  }
}

variable "reserved_ip_range" {
  description = "The CIDR range of internal addresses that are reserved for this instance"
  type        = string
  default     = null
}

variable "redis_configs" {
  description = "Redis configuration parameters, according to http://redis.io/topics/config"
  type        = map(string)
  default     = {}
}

variable "auth_enabled" {
  description = "Indicates whether OSS Redis AUTH is enabled for the instance"
  type        = bool
  default     = false
}

variable "transit_encryption_mode" {
  description = "The TLS mode of the Redis instance"
  type        = string
  default     = "DISABLED"
  validation {
    condition     = contains(["DISABLED", "SERVER_AUTHENTICATION"], var.transit_encryption_mode)
    error_message = "Allowed values for transit_encryption_mode are \"DISABLED\" or \"SERVER_AUTHENTICATION\"."
  }
}

variable "maintenance_policy" {
  description = "The maintenance policy for the instance"
  type = object({
    day        = string
    start_time = object({
      hours   = number
      minutes = number
      seconds = number
      nanos   = number
    })
  })
  default = null
}

variable "redis_labels" {
  description = "The resource labels to represent user-provided metadata"
  type        = map(string)
  default     = {}
}

variable "customer_managed_key" {
  description = "The customer-managed encryption key to be used for the instance"
  type        = string
  default     = null
}