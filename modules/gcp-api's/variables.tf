variable "apis" {
  description = "List of APIs to enable"
  type        = list(string)
  default     = []
}

variable "disable_services_on_destroy" {
  description = "Whether project services will be disabled when the resources are destroyed"
  type        = bool
  default     = true
}

variable "disable_dependent_services" {
  description = "Whether services that are enabled and which depend on this service should also be disabled when this service is destroyed"
  type        = bool
  default     = true
}

variable "project_id" {
  description = "The GCP project ID where APIs will be enabled"
  type        = string
}