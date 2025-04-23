variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
}

variable "zone" {
  description = "zone"
  type = string
  default = "asia-southeast1-a"
}

variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
  default = ""
}

variable "subnet_id" {
  description = "ID of the subnet"
  type        = string
  default = ""
}

variable "machine_type" {
  description = "Machine type for VM instances"
  type        = string
  default     = "e2-medium"
}

variable "source_image" {
  description = "Source image for VM instances"
  type        = string
  default     = "debian-cloud/debian-11"
}

variable "target_size" {
  description = "Number of instances in the instance group"
  type        = number
  default     = 2
}

variable "startup_script" {
  description = "Startup script for VM instances"
  type        = string
  default     = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y mosquitto mosquitto-clients
    
    # Configure Mosquitto
    cat > /etc/mosquitto/conf.d/default.conf << 'EOL'
    listener 1883
    allow_anonymous true
    
    # For MQTT over WebSockets (optional)
    listener 9001
    protocol websockets
    allow_anonymous true
    EOL
    
    systemctl restart mosquitto
    systemctl enable mosquitto
  EOF

}

variable "network_lb_subnet_id" {
  description = "ID of the subnet for the network load balancer"
  type        = string
}

variable "application_lb_subnet_id" {
  description = "ID of the subnet for the application load balancer"
  type        = string
}

variable "network_lb_instance_groups" {
  description = "List of instance groups for the network load balancer"
  type        = list(string)
  default     = []
}

variable "application_lb_instance_groups" {
  description = "List of instance groups for the application load balancer"
  type        = list(string)
  default     = []
}

variable "security_policy_id" {
  description = "ID of the Cloud Armor security policy"
  type        = string
  default     = ""
}

variable "enable_ssl" {
  description = "Enable SSL for HTTPS"
  type        = bool
  default     = false
}

variable "ssl_certificate" {
  description = "SSL certificate"
  type        = string
  default     = ""
  sensitive   = true
}

variable "ssl_private_key" {
  description = "SSL private key"
  type        = string
  default     = ""
  sensitive   = true
}