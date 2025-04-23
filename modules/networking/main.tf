# VPC Network 
# This module creates a Virtual Private Cloud (VPC) network with subnets.
# It is responsible for setting up the network infrastructure for the project.
# The VPC network is a fundamental component of the GCP infrastructure, providing isolation and security for resources.
# The VPC network is created with multiple subnets, each serving different purposes (e.g., private, public).

resource "google_compute_network" "vpc" {
  name                    = "main-vpc"
  auto_create_subnetworks = false
  project                 = var.project_id
}

# Public subnet
resource "google_compute_subnetwork" "public_subnet" {
  name          = "public-subnet"
  ip_cidr_range = var.public_subnet_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
 
}

# Private subnet
resource "google_compute_subnetwork" "private_subnet_01" {
  name          = "private-subnet"
  ip_cidr_range = var.private_subnet_01_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
  
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
  private_ip_google_access = true
  depends_on = [google_compute_network.vpc]
}

resource "google_compute_subnetwork" "private_subnet_02" {
  name          = "private-subnet-02"
  ip_cidr_range = var.private_subnet_02_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
  private_ip_google_access = true
  depends_on = [google_compute_network.vpc]
}

resource "google_compute_subnetwork" "private_subnet_03" {
  name          = "private-subnet-03"
  ip_cidr_range = var.private_subnet_03_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
  private_ip_google_access = true
  depends_on = [google_compute_network.vpc]
}

resource "google_compute_subnetwork" "private_subnet_04" {
  name          = "private-subnet-04"
  ip_cidr_range = var.private_subnet_04_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id

   secondary_ip_range {
    range_name    = "k8s-pods"
    ip_cidr_range = var.k8s_pods_cidr
  }
  
  secondary_ip_range {
    range_name    = "k8s-services"
    ip_cidr_range = var.k8s_services_cidr
  }
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
  private_ip_google_access = true
  depends_on = [google_compute_network.vpc]
}

resource "google_compute_subnetwork" "private_subnet_05" {
  name          = "private-subnet-05"
  ip_cidr_range = var.private_subnet_05_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
  log_config {
    aggregation_interval = "INTERVAL_10_MIN"
    flow_sampling        = 0.5
    metadata             = "INCLUDE_ALL_METADATA"
  }
  private_ip_google_access = true
  depends_on = [google_compute_network.vpc]
}

# NAT Router
resource "google_compute_router" "router" {
  name    = "nat-router"
  region  = var.region
  network = google_compute_network.vpc.id
  project = var.project_id
  bgp {
    asn = 65001
  }
  depends_on = [google_compute_network.vpc]
  lifecycle {
    ignore_changes = [bgp]
  }
}

# NAT Gateway
resource "google_compute_router_nat" "nat_gateway" {
  name                               = "nat-gateway"
   router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
  project                            = var.project_id
  
  log_config {
    enable = true
    filter = "ERRORS_ONLY"
  }
}

/*# VPN
resource "google_compute_vpn_gateway" "vpn_gateway" {
  name    = "vpn-gateway"
  network = google_compute_network.vpc.id
  region  = var.region
  project = var.project_id
}
 */
