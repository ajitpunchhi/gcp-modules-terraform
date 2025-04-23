# File: outputs.tf
# This file defines the outputs of the Terraform configuration.
# Outputs are useful for retrieving information about the resources created by the configuration.
# They can be used to display important information after the deployment is complete.
# Outputs can also be referenced in other Terraform configurations or modules.

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "subnet_id" {
  description = "ID of the created subnet"
  value       = module.vpc.private_subnet_01_id
}
output "vpc_name" {
  description = "Name of the created VPC"
  value       = module.vpc.private_subnet_01_name
}

/*
output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = module.vpc.public_subnet_id
}

output "private_subnet_id" {
  description = "ID of the private subnet"
  value       = module.vpc.private_subnet_id
}

output "network_lb_ip" {
  description = "IP address of the Network Load Balancer"
  value       = module.load_balancers.network_lb_ip
}

output "application_lb_ip" {
  description = "IP address of the Application Load Balancer"
  value       = module.load_balancers.application_lb_ip
}

output "kubernetes_endpoint" {
  description = "Kubernetes cluster endpoint"
  value       = module.kubernetes.cluster_endpoint
  sensitive   = true
}
/*
output "rabbitmq_connection_string" {
  description = "Connection string for RabbitMQ"
  value       = module.rabbitmq.connection_string
  sensitive   = true
}

output "mqtt_broker_endpoint" {
  description = "MQTT Broker endpoint"
  value       = module.mqtt_broker.endpoint
}

output "bigtable_instance" {
  description = "BigTable instance ID"
  value       = module.bigtable.instance_id
}

output "memorystore_endpoint" {
  description = "Memorystore Redis endpoint"
  value       = module.memorystore.redis_endpoint
}
*/