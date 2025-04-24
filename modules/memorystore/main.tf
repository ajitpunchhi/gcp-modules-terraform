# Private Service Access for Memorystore
resource "google_compute_global_address" "service_range" {
  name          = "service-networking-address"
  project       = var.project_id
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = var.authorized_network
}
resource "google_service_networking_connection" "private_service_connection" {
  network                 = var.authorized_network

  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [var.authorized_network]
}

# Memorystore Redis instance resource
resource "google_redis_instance" "cache" {
  project                 = var.project_id
  name                    = var.name
  memory_size_gb          = var.memory_size_gb
  region                  = var.region
  location_id             = var.location_id
  alternative_location_id = var.alternative_location_id
  redis_version           = var.redis_version
  display_name            = "${var.name}-redis"
  tier                    = var.tier
  connect_mode            = var.connect_mode
  authorized_network      = var.authorized_network
  reserved_ip_range       = var.reserved_ip_range
  labels                  = var.redis_labels
  
  # Redis configuration

  
  # Auth settings
  auth_enabled = var.auth_enabled
  
  # Encryption settings
  transit_encryption_mode = var.transit_encryption_mode
  

  
  # Maintenance policy
  dynamic "maintenance_policy" {
    for_each = var.maintenance_policy != null ? [var.maintenance_policy] : []
    content {
      weekly_maintenance_window {
        day = maintenance_policy.value.day
        start_time {
          hours   = maintenance_policy.value.start_time.hours
          minutes = maintenance_policy.value.start_time.minutes
          seconds = maintenance_policy.value.start_time.seconds
          nanos   = maintenance_policy.value.start_time.nanos
        }
      }
    }
  }
}
