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


resource "google_compute_router_nat" "nat" {
  name                               = "${var.name}-config"
  project                            = var.project_id
  router                             = google_compute_router.router.name
  region                             = var.region
  nat_ip_allocate_option             = var.nat_ip_allocate_option
  source_subnetwork_ip_ranges_to_nat = var.source_subnetwork_ip_ranges_to_nat
  nat_ips                            = var.nat_ips
  min_ports_per_vm                   = var.min_ports_per_vm
  
  udp_idle_timeout_sec             = var.udp_idle_timeout_sec
  icmp_idle_timeout_sec            = var.icmp_idle_timeout_sec
  tcp_established_idle_timeout_sec = var.tcp_established_idle_timeout_sec
  tcp_transitory_idle_timeout_sec  = var.tcp_transitory_idle_timeout_sec
  
  log_config {
    enable = var.log_config_enable
    filter = var.log_config_filter
  }
  
  dynamic "subnetwork" {
    for_each = var.source_subnetwork_ip_ranges_to_nat == "ALL_SUBNETWORKS_ALL_IP_RANGES"? var.subnetworks : []
    content {
      name                     = subnetwork.value.name
      source_ip_ranges_to_nat  = subnetwork.value.source_ip_ranges_to_nat
      secondary_ip_range_names = subnetwork.value.secondary_ip_range_names
    }
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
