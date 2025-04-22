
variable "zone" {
  description = "GCP zone for the VM"
  type        = string

}
variable "project" {
    type = string
   
  
}

variable "network" {
    description = "GCP Network"
    type = string
    default = "default"
  
}

variable "subnet" {
  description = "Subnet for the VM"
  type        = string
  default     = "default"
}

variable "instance_name" {
  description = "Name for the VM instance"
  type        = string
}

variable "machine_type" {
  description = "Machine type for the VM instance"
  type        = string
  default     = "e2-micro"
}

variable "image" {
  description = "OS image for the VM"
  type        = string
  default     = "debian-cloud/debian-11"
}
variable "tags" {
  description = "Network tags for the VM"
  type        = list(string)
  default     = []
}

variable "metadata" {
  description = "Metadata key/value pairs"
  type        = map(string)
  default     = {}
}

variable "service_account" {
  description = "Service account email and scopes"
  type = object({
    email  = string
    scopes = list(string)
  })
  default = {
    email  = ""
    scopes = ["https://www.googleapis.com/auth/cloud-platform"]
  }
}

variable "boot_disk_size" {
  description = "Boot disk size in GB"
  type        = number
  default     = 20
}

variable "boot_disk_type" {
  description = "Boot disk type"
  type        = string
  default     = "pd-standard"
}

variable "allow_stopping_for_update" {
  description = "Allow stopping the instance to update its properties"
  type        = bool
  default     = true
}