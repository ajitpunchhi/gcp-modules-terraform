# VPC Network
module "vpc" {
  source     = "./modules/networking"
  project_id = var.project_id
  region     = var.region
}

# Cloud Firewall rules
module "firewall" {
  source     = "./modules/firewall"
  project_id = var.project_id
  vpc_id = module.vpc.vpc_id
  depends_on = [module.vpc]
}

/*# Kubernetes Services
module "kubernetes" {
  source       = "./modules/kubernetes"
  project_id   = var.project_id
  region       = var.region
    vpc_id       = module.vpc.vpc_id
  subnet_id    = module.vpc.private_subnet_01_id
  depends_on   = [module.vpc]
}
*/

module "security" {
  source                  = "./modules/security"
  project_id              = var.project_id
  service_account_name    = "my-service-account"
  cloud_armor_policy_name = "my-cloud-armor-policy"
  network_id              = module.vpc.vpc_id
  depends_on              = [module.vpc]
}


# Compute instances for various layers

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
  

# Load balancers (Network and Application)
module "load_balancers" {
  source                = "./modules/load_balancers"
  project_id            = var.project_id
  region                = var.region
  network_lb_subnet_id  = module.vpc.private_subnet_03_id
  application_lb_subnet_id = module.vpc.private_subnet_03_id
  depends_on            = [module.vm_instance]
}

/*# MQTT Broker
module "mqtt_broker" {
  source = "./modules/mqtt"
  project_id = var.project_id
  region = var.region
  subnet_id = module.vpc.private_subnet_03_id

  
}

/*

# RabbitMQ 
module "rabbitmq" {
  source     = "./modules/rabbitmq"
  project_id = var.project_id
  region     = var.region
  subnet_id  = module.vpc.private_subnet_id
  depends_on = [module.vpc]
}

/*

# BigTable Cluster
module "bigtable" {
  source     = "./modules/bigtable"
  project_id = var.project_id
  region     = var.region
  depends_on = [module.vpc]
}

# Memorystore (Redis)
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