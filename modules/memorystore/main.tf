resource "google_redis_instance" "this" {
  name              = var.name
  project           = var.project_id
  tier              = var.tier
  memory_size_gb    = var.memory_size_gb
  region            = var.region
  authorized_network = var.authorized_network

  redis_version     = var.redis_version

  transit_encryption_mode = var.transit_encryption_mode

  labels = var.labels

  maintenance_policy {
    weekly_maintenance_window {
      day = var.maintenance_day
      start_time {
        hours   = var.maintenance_start_hour
        minutes = var.maintenance_start_min
      }
    }
  }

}