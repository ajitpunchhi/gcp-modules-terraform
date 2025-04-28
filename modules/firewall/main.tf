# Cloud Firewall rules
# This module sets up firewall rules for the VPC network.
# It is responsible for configuring the security settings for the network, allowing or denying traffic based on specified rules.
# The firewall rules are essential for controlling access to resources within the VPC network.

# Allow SSH access to VMs in the public subnet
resource "google_compute_firewall" "allow_ssh" {
  name    = "allow-ssh"
  network = var.vpc_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-enabled"]
}

# Allow internal communication
resource "google_compute_firewall" "allow_internal" {
  name    = "allow-internal"
  network = var.vpc_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "icmp"
  }

  source_ranges = [
    var.private_subnet_01_cidr,
    var.private_subnet_02_cidr,
    var.private_subnet_03_cidr,
    var.private_subnet_04_cidr,
    var.private_subnet_05_cidr,
    var.public_subnet_cidr
  ]
}

# Allow HTTP/HTTPS traffic
resource "google_compute_firewall" "allow_http_https" {
  name    = "allow-http-https"
  network = var.vpc_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["80", "443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server", "https-server"]
}

# Allow MQTT traffic
resource "google_compute_firewall" "allow_mqtt" {
  name    = "allow-mqtt"
  network = var.vpc_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["1883", "8883"]  # MQTT and MQTT over SSL
  }

  source_ranges = [var.private_subnet_04_cidr, var.private_subnet_05_cidr]
  target_tags   = ["mqtt-broker"]
}

# Firewall rules for Cassandra
resource "google_compute_firewall" "cassandra_internal" {
  name    = "cassendra-internal"
  project = var.project_id
  network = var.vpc_id

  allow {
    protocol = "tcp"
    ports    = ["7000", "7001", "7199", "9042", "9160"]
  }

  source_tags = ["cassendra"]
  target_tags = ["cassendra"]
}

resource "google_compute_firewall" "cassandra_ssh" {
  name    = "cassndra-ssh"
  project = var.project_id
  network = var.vpc_id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["cassendra-ssh"]
}

resource "google_compute_firewall" "cassandra_client" {
  name    = "cassandra-client"
  project = var.project_id
  network = var.vpc_id

  allow {
    protocol = "tcp"
    ports    = ["9042"]  # CQL native port
  }

  source_ranges = ["0.0.0.0/0"]  # You may want to restrict this in production
  target_tags   = ["cassandra-client"]
}

resource "google_compute_firewall" "allow_iap_ssh" {
  name    = "allow-iap-ssh"
  network = var.vpc_id
  project = var.project_id
  # Allow SSH access to VMs via IAP
  # This rule is for instances that are tagged with "allow-ssh"
  
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  
  # IAP's IP range
  source_ranges = ["35.235.240.0/20"]
  destination_ranges = ["10.0.2.0/24", "10.0.3.0/24","10.0.4.0/24","10.0.5.0/24"]
}

resource "google_compute_firewall" "redis_fw" {
  name          = "redis-firewall-rule"
  network       = var.vpc_id
  project       = var.project_id
  # Allow Redis traffic
  # This rule is for instances that are tagged with "redis"
  # and are in the private subnet
  # This rule allows traffic on port 6379 (Redis default port)
  direction     = "INGRESS"
  priority      = 1000
  target_tags   = ["redis"]

  allow {
    protocol = "tcp"
    ports    = ["6379"]
  }

  source_ranges = "10.0.0./16"

  description = "Allow Redis traffic on port 6379 from allowed sources"
}

/*
# Allow RabbitMQ traffic
resource "google_compute_firewall" "allow_rabbitmq" {
  name    = "allow-rabbitmq"
  network = var.vpc_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["5672", "15672"]  # AMQP and management interface
  }

  source_ranges = [var.private_subnet_cidr, var.private_subnet_ec2_cidr]
  target_tags   = ["rabbitmq"]
}

# Allow Kubernetes API traffic
resource "google_compute_firewall" "allow_k8s_api" {
  name    = "allow-k8s-api"
  network = var.vpc_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["6443", "8443", "10250", "10255", "10256"]
  }

  source_ranges = [
    var.private_subnet_cidr, 
    var.public_subnet_cidr,
    var.k8s_pods_cidr,
    var.k8s_services_cidr
  ]
  target_tags   = ["gke-nodes", "k8s-api"]
}

# Allow Memorystore (Redis) traffic
resource "google_compute_firewall" "allow_memorystore" {
  name    = "allow-memorystore"
  network = var.vpc_id
  project = var.project_id

  allow {
    protocol = "tcp"
    ports    = ["6379"]
  }

  source_ranges = [var.private_subnet_cidr, var.private_subnet_ec2_cidr]
  target_tags   = ["memorystore"]
}
*/