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