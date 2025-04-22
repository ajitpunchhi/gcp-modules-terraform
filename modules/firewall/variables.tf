variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  default = "main-vpc"
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
