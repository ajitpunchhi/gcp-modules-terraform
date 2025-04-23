# This is the main Terraform configuration file for deploying a GCP infrastructure.
# It includes modules for networking, security, compute instances, and other services.
# The modules are sourced from local directories and are parameterized with variables.
# The configuration is designed to be modular and reusable, allowing for easy updates and changes.
# The main components include:
# - VPC Network: Creates a Virtual Private Cloud (VPC) network with subnets.
# - Cloud Firewall: Sets up firewall rules for the VPC network.
# - Security: Configures security settings, including service accounts and IAM roles.
# - Compute Instances: Deploys virtual machine instances for various layers of the application.
# - Load Balancers: Sets up network and application load balancers for traffic management.
# - MQTT Broker: Deploys an MQTT broker for messaging.
# - RabbitMQ: Deploys a RabbitMQ instance for message queuing.
# - BigTable: Sets up a BigTable cluster for NoSQL database needs.
# - Memorystore: Configures a Redis instance for in-memory data storage.
# - Kubernetes: Deploys a Kubernetes cluster for container orchestration.
# - Cloud Armor: Configures security policies for the application.

# VPC Network 
# This module creates a Virtual Private Cloud (VPC) network with subnets.

module "vpc" {
  source     = "./modules/networking"
  project_id = var.project_id
  region     = var.region
}

# Cloud Firewall rules
# This module sets up firewall rules for the VPC network.

module "firewall" {
  source     = "./modules/firewall"
  project_id = var.project_id
  vpc_id = module.vpc.vpc_id
  depends_on = [module.vpc]
}

# Kubernetes Services
# This module deploys a Kubernetes cluster for container orchestration.

module "kubernetes" {
  source       = "./modules/kubernetes"
  project_id   = var.project_id
  region       = var.region
    vpc_id       = module.vpc.vpc_id
  subnet_id    = module.vpc.private_subnet_04_id
  depends_on   = [module.vpc]
}


# Security
# This module configures security settings, including service accounts and IAM roles.

module "security" {
  source                  = "./modules/security"
  project_id              = var.project_id
  service_account_name    = "my-service-account"
  cloud_armor_policy_name = "my-cloud-armor-policy"
  network_id              = module.vpc.vpc_id
  depends_on              = [module.vpc]
}


# Compute instances for various layers
# This module deploys virtual machine instances for different layers of the application.

/*
module "vm_instance" {
  source = "./modules/compute"
  project = var.project_id
  zone         = "${var.region}-a"
  instance_name = "web-server"
  machine_type = "e2-medium"
  network = module.vpc.vpc_id
  subnet = module.vpc.private_subnet_03_id
  
  tags         = ["http-server", "https-server"]
  
  metadata     = {
    startup-script = <<-EOF
      #!/bin/bash
      apt-get update
      apt-get install -y nginx
      systemctl enable nginx
      systemctl start nginx
    EOF
  }
}
  */

# MQTT Broker
# This module deploys an MQTT broker for messaging.
/*
module "mqtt_broker" {
  source = "./modules/mqtt"
  project_id = var.project_id
  region     = var.region
  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.vpc.private_subnet_03_id
  
}
*/

# Load balancers (Network and Application)
# This module sets up network and application load balancers for traffic management.

module "load_balancers" {
  source                = "./modules/load_balancers"
  project_id            = var.project_id
  region                = var.region
  subnet_id             = module.vpc.private_subnet_03_id
  network_lb_subnet_id  = module.vpc.private_subnet_02_id
  application_lb_subnet_id = module.vpc.private_subnet_02_id
  
  
}


/*

# RabbitMQ 
# This module deploys a RabbitMQ instance for message queuing.
# It is responsible for managing message queues and facilitating communication between different components of the application.
# The RabbitMQ instance is essential for enabling reliable message delivery and processing.

module "rabbitmq" {
  source     = "./modules/rabbitmq"
  project_id = var.project_id
  region     = var.region
  subnet_id  = module.vpc.private_subnet_id
  depends_on = [module.vpc]
}

/*

# BigTable Cluster
# This module sets up a BigTable cluster for NoSQL database needs.
# It is responsible for managing large-scale data storage and retrieval.
# The BigTable cluster is essential for handling big data workloads and providing low-latency access to data.

module "bigtable" {
  source     = "./modules/bigtable"
  project_id = var.project_id
  region     = var.region
  depends_on = [module.vpc]
}

# Memorystore (Redis)
# This module configures a Redis instance for in-memory data storage.
# It is responsible for managing in-memory data caching and storage.
# The Redis instance is essential for improving application performance and reducing latency.

module "memorystore" {
  source       = "./modules/memorystore"
  project_id   = var.project_id
  region       = var.region
  vpc_id       = module.vpc.vpc_id
  private_subnet_id = module.vpc.private_subnet_id
  depends_on   = [module.vpc]
}

# Kubernetes Services

module "kubernetes" {
  source       = "./modules/kubernetes"
  project_id   = var.project_id
  region       = var.region
  vpc_id       = module.vpc.vpc_id
  subnet_id    = module.vpc.private_subnet_id
  depends_on   = [module.vpc]
}
*/