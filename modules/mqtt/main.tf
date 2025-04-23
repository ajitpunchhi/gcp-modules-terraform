# Create a Compute Engine instance for the MQTT broker
resource "google_compute_instance" "mqtt_broker" {
  name         = "mqtt-broker"
  machine_type = var.machine_type
  zone         = "${var.region}-a"
  project      = var.project_id

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = 20
    }
  }

  network_interface {
    network    = var.vpc_id
    subnetwork = var.subnet_id
    access_config {
      // Ephemeral public IP
    }
 
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    apt-get update
    apt-get install -y mosquitto mosquitto-clients
    
    # Configure Mosquitto
    cat > /etc/mosquitto/conf.d/default.conf << 'EOL'
    listener 1883
    allow_anonymous true
    
    # For MQTT over WebSockets (optional)
    listener 9001
    protocol websockets
    allow_anonymous true
    EOL
    
    systemctl restart mosquitto
    systemctl enable mosquitto
  EOF

  service_account {
    email  = google_service_account.mqtt_sa.email
    scopes = ["cloud-platform"]
  }

  tags = ["mqtt-broker"]

  /*metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_public_key_path)}"
  }*/
}

# Create a service account for the MQTT broker
resource "google_service_account" "mqtt_sa" {
  account_id   = "mqtt-broker-sa"
  display_name = "MQTT Broker Service Account"
  project      = var.project_id
}


# Create a persistent disk for MQTT data (if needed)
resource "google_compute_disk" "mqtt_data_disk" {
  name  = "mqtt-data-disk"
  size  = var.data_disk_size
  type  = "pd-ssd"
  zone  = "${var.region}-a"
  project = var.project_id
}

# Attach the persistent disk to the instance
resource "google_compute_attached_disk" "mqtt_data_disk_attachment" {
  project = var.project_id
  zone    = "${var.region}-a"
  
  disk     = google_compute_disk.mqtt_data_disk.id
  instance = google_compute_instance.mqtt_broker.name
}

# Create a health check for the MQTT broker
resource "google_compute_health_check" "mqtt_health_check" {
  name               = "mqtt-health-check"
  project            = var.project_id
  check_interval_sec = 5
  timeout_sec        = 5
  
  tcp_health_check {
    port = "1883"
  }
}

# Create a firewall rule for the health check probes
resource "google_compute_firewall" "mqtt_healthcheck" {
  name          = "mqtt-allow-health-check"
  network       = var.vpc_id
  project       = var.project_id
  source_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
  
  allow {
    protocol = "tcp"
    ports    = ["1883", "9001"]
  }
  
  target_tags = ["mqtt-broker"]
}