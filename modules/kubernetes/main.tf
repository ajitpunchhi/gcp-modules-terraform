resource "google_container_cluster" "primary" {
  name                     = var.cluster_name
  project                  = var.project_id
  location                 = var.location
  remove_default_node_pool = "true"
  initial_node_count       = var.nodescount
  network                  = var.vpc_id
  subnetwork               = var.subnet_id
  networking_mode          = "VPC_NATIVE"
  deletion_protection       = "false"


  # Enable Workload Identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Configure network policy
  network_policy {
    enabled  = var.network_policy_enabled
    provider = "CALICO"
  }

  # Configure private cluster
  private_cluster_config {
    enable_private_nodes    = var.private_cluster_enabled
    enable_private_endpoint = var.private_endpoint_enabled
    master_ipv4_cidr_block  = "172.16.0.0/28"
    master_global_access_config {
      enabled = "true"
    }
  }

  # Configure IP allocation for pods and services
  ip_allocation_policy {
   cluster_secondary_range_name  = "k8s-pods"
   services_secondary_range_name = "k8s-services"
  }

  # Configure cluster addon features
  addons_config {
    http_load_balancing {
      disabled = !var.http_load_balancing_enabled
    }
    horizontal_pod_autoscaling {
      disabled = !var.horizontal_pod_autoscaling_enabled
    }
    network_policy_config {
      disabled = !var.network_policy_enabled
    }
  }

  # Configure master authorized networks
  master_authorized_networks_config {
    dynamic "cidr_blocks" {
      for_each = var.master_authorized_networks
      content {
        cidr_block   = cidr_blocks.value.cidr_block
        display_name = cidr_blocks.value.display_name
      }
    }
  }

  # Configure logging and monitoring
  logging_service    = var.logging_service
  monitoring_service = var.monitoring_service

  release_channel {
    channel = var.release_channel
  }
}

# Create a node pool
resource "google_container_node_pool" "primary_nodes" {
  name       = "${var.cluster_name}-node-pool"
  project = var.project_id
  location   = var.location
  cluster    = google_container_cluster.primary.name
  node_count = var.initial_node_count


  # Enable autoscaling
  autoscaling {
    min_node_count = var.min_node_count
    max_node_count = var.max_node_count
  }

  # Configure upgrade strategy
  management {
    auto_repair  = "true"
    auto_upgrade = "true"
  }

  # Configure node properties
  node_config {
    preemptible  = var.preemptible
    machine_type = var.machine_type
    disk_size_gb = var.disk_size_gb
    disk_type    = var.disk_type

    # Define OAuth scopes
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
      "https://www.googleapis.com/auth/compute",
    ]

    # Define node labels
    labels = var.node_labels

    # Define node taints
    dynamic "taint" {
      for_each = var.node_taints
      content {
        key    = taint.value.key
        value  = taint.value.value
        effect = taint.value.effect
      }
    }

    # Configure workload identity on nodes
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    # Define node metadata
    metadata = {
      disable-legacy-endpoints = "true"
    }

    # Define node tags
    tags = var.node_tags
  }
}