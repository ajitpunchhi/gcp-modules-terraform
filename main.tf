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
/*
module "kubernetes" {
  source       = "./modules/kubernetes"
  project_id   = var.project_id
  region       = var.region
    vpc_id       = module.vpc.vpc_id
  subnet_id    = module.vpc.private_subnet_04_id
  depends_on   = [module.vpc]
}*/


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

# Load balancers (Network and Application)
# This module sets up network and application load balancers for traffic management.

/*
module "load_balancers" {
  source                = "./modules/load_balancers"
  project_id            = var.project_id
  region                = var.region
  subnet_id             = module.vpc.private_subnet_03_id
  network_lb_subnet_id  = module.vpc.private_subnet_02_id
  application_lb_subnet_id = module.vpc.private_subnet_02_id
  depends_on           = [module.vpc]
}*/



# Compute instances for various layers
# This module deploys virtual machine instances for different layers of the application.


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

# Create the first Cassandra node (will be the seed node)
module "cassandra_seed" {
  source = "./modules/cassandra"
  
  project_id     = var.project_id
  region         = var.region
  instance_name  = "cassandra-seed"
  machine_type   = "n2-standard-4"
  network        = module.vpc.vpc_id
  subnetwork     = module.vpc.private_subnet_05_id
  disk_size_gb   = 20
  cluster_name   = "my-cassandra-cluster"
  datacenter_name = "dc1"
  
  # First node is the seed, so we don't specify any seeds for it
  cassandra_seeds = []
}

# Create additional Cassandra nodes using the seed node as the seed
module "cassandra_node_1" {
  source = "./modules/cassandra-node1"
  
  project_id     = var.project_id
  region         = var.region
  instance_name  = "cassandra-node-1"
  machine_type   = "n2-standard-4"
  network        = module.vpc.vpc_id
  subnetwork     = module.vpc.private_subnet_05_id
  disk_size_gb   = 20
  cluster_name   = "my-cassandra-cluster"
  datacenter_name = "dc1"
  
  # Use the seed node's internal IP
#cassandra_seeds = [google_compute_instance.cassandra_seed.network_interface[0].network_ip]
  
  # Make sure seed node is created first
  depends_on = [module.vpc.private_subnet_05_id]
}

module "cassandra_node_2" {
  source = "./modules/cassandra-node2"
  
  project_id     = var.project_id
  region         = var.region
  instance_name  = "cassandra-node-2"
  machine_type   = "n2-standard-4"
  network        = module.vpc.vpc_id
  subnetwork     = module.vpc.private_subnet_05_id
  disk_size_gb   = 20
  cluster_name   = "my-cassandra-cluster"
  datacenter_name = "dc1"
  
  # Use the seed node's internal IP
  #cassandra_seeds = [google_compute_instance.cassandra_seed.network_interface[0].network_ip]
  
  # Make sure seed node is created first
  depends_on = [module.cassandra_seed]
}

/*
# Memorystore (Redis)
# This module configures a Redis instance for in-memory data storage.
# It is responsible for managing in-memory data caching and storage.
# The Redis instance is essential for improving application performance and reducing latency.

# Redis Standard Tier Instance
module "redis_ha" {
  source = "./modules/memorystore"

  project_id             = var.project_id
  name                   = "redis-ha-instance"
  region                 = var.region
  location_id            = "${var.region}-a"
  alternative_location_id = "${var.region}-c"
  memory_size_gb         = 5
  redis_version          = "REDIS_6_X"
  tier                   = "STANDARD_HA"
  connect_mode           = "PRIVATE_SERVICE_ACCESS"
  authorized_network     = var.authorized_network
  
  redis_configs = {
    "maxmemory-policy" = "allkeys-lru"
    "notify-keyspace-events" = "KEA"
  }
  
  auth_enabled = true
  transit_encryption_mode = "SERVER_AUTHENTICATION"
  
  maintenance_policy = {
    day = "SATURDAY"
    start_time = {
      hours = 23
      minutes = 0
      seconds = 0
      nanos = 0
    }
  }
  
  redis_labels = {
    environment = "production"
    application = "backend-cache"
  }
  
}

# Redis Basic Tier Instance
module "redis_basic" {
  source = "./modules/memorystore"

  project_id         = var.project_id
  name               = "redis-basic-instance"
  region             = var.region
  location_id        = "${var.region}-b"
  memory_size_gb     = 2
  redis_version      = "REDIS_6_X"
  tier               = "BASIC"
  authorized_network = var.authorized_network
  
  redis_configs = {
    "maxmemory-policy" = "volatile-lru"
  }
  
  redis_labels = {
    environment = "development"
    application = "testing-cache"
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