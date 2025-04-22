resource "google_compute_network" "vpc" {
  name                    = "main-vpc"
  auto_create_subnetworks = false
  project                 = var.project_id
  mtu                     = var.mtu
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
  name          = "private-subnet-01"
  ip_cidr_range = var.private_subnet_01_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

resource "google_compute_subnetwork" "private_subnet_02" {
  name          = "private-subnet-02"
  ip_cidr_range = var.private_subnet_02_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

resource "google_compute_subnetwork" "private_subnet_03" {
  name          = "private-subnet-03"
  ip_cidr_range = var.private_subnet_03_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

resource "google_compute_subnetwork" "private_subnet_04" {
  name          = "private-subnet-04"
  ip_cidr_range = var.private_subnet_04_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

resource "google_compute_subnetwork" "private_subnet_05" {
  name          = "private-subnet-05"
  ip_cidr_range = var.private_subnet_05_cidr
  region        = var.region
  network       = google_compute_network.vpc.id
  project       = var.project_id
}

# NAT Router
resource "google_compute_router" "router" {
  name    = "nat-router"
  region  = var.region
  network = google_compute_network.vpc.id
  project = var.project_id
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
