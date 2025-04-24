locals {
  zones = length(var.zones) > 0 ? var.zones : [
    "${var.region}-a",
    "${var.region}-b",
    "${var.region}-c",
  ]
  
  # Ensure we have enough zones for our nodes
  node_zones = [for i in range(var.node_count) : local.zones[i % length(local.zones)]]
}

resource "google_service_account" "cassandra_sa" {
  count        = var.service_account_email == "" ? 1 : 0
  account_id   = "${var.cluster_name}-sa"
  display_name = "Cassandra Service Account"
  project      = var.project_id
}

# Cassandra data disks
resource "google_compute_disk" "cassandra_data_disk" {
  count   = var.node_count
  name    = "${var.cluster_name}-data-disk-${count.index}"
  project = var.project_id
  type    = var.data_disk_type
  zone    = local.node_zones[count.index]
  size    = var.data_disk_size
}

# Cassandra nodes
resource "google_compute_instance" "cassandra_nodes" {
  count        = var.node_count
  name         = "${var.cluster_name}-${count.index}"
  project      = var.project_id
  machine_type = var.machine_type
  zone         = local.node_zones[count.index]

  tags = var.tags

  boot_disk {
    initialize_params {
      image = var.image
      size  = var.boot_disk_size
      type  = "pd-standard"
    }
  }

  # Attach data disk
  attached_disk {
    source      = google_compute_disk.cassandra_data_disk[count.index].self_link
    device_name = "cassandra-data"
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet_id

    access_config {
      // Ephemeral IP
    }
  }
  /*# Node-specific metadata
  metadata = {
    ssh-keys       = var.ssh_keys
    node-id        = count.index
    startup-script = templatefile("startup.sh", {
      cassandra_version = var.cassandra_version,
      cluster_name      = var.cluster_name,
      seed_nodes        = join(",", [for i in range(min(3, var.node_count)) : 
                            google_compute_instance.cassandra_nodes[i].network_interface[0].network_ip])
    })
  }*/

  service_account {
    email = var.service_account_email == "" ? (
      length(google_service_account.cassandra_sa) > 0 ? google_service_account.cassandra_sa[0].email : null
    ) : var.service_account_email
    
    scopes = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }

  # Use dependency to ensure we have IP addresses for seed nodes
  depends_on = [
    google_compute_disk.cassandra_data_disk
  ]

  lifecycle {
    ignore_changes = [metadata["startup-script"]]
  }
}