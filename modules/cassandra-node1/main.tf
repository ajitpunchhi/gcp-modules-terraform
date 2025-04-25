locals {
  network_tags = distinct(concat(var.tags, ["cassandra"]))
  
}

# Cassandra node instance
resource "google_compute_instance" "cassandra" {
  name         = var.instance_name
  machine_type = var.machine_type
  zone         = var.zone
  project      = var.project_id
  tags         = local.network_tags

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = var.disk_size_gb
      type  = var.disk_type
    }
  }

  network_interface {
    network    = var.network
    subnetwork = var.subnetwork
    
    # If you want a public IP
    access_config {
      // Ephemeral public IP
    }
  }


  service_account {
    scopes = ["cloud-platform"]
  }

  allow_stopping_for_update = true
}