resource "google_compute_instance" "vm_instance" {
  name         = var.instance_name
  project = var.project
  machine_type = var.machine_type
  zone         = var.zone
  
  tags = var.tags

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.boot_disk_size
      type  = var.boot_disk_type
    }
  }

    network_interface {
    network    = var.network
    subnetwork = var.subnet != "" ? var.subnet : null
    # No access_config block means no external IP
  }

  metadata = var.metadata

  dynamic "service_account" {
    for_each = var.service_account.email != "" ? [1] : []
    content {
      email  = var.service_account.email
      scopes = var.service_account.scopes
    }
  }

  allow_stopping_for_update = var.allow_stopping_for_update
}