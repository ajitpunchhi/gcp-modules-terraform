resource "google_container_cluster" "primary" {
  name     = "kubernetes-cluster"
  location = var.region
  project  = var.project_id

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = var.vpc_id
  subnetwork = var.subnet_id

  # Enable IP aliasing
  ip_allocation_policy {
    cluster_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # Enable private cluster
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false
    master_ipv4_cidr_block  = var.master_ipv4_cidr_block
  }

  # Enable workload identity
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Add cluster autoscaling
  vertical_pod_autoscaling {
    enabled = true
  }
}

# Create the node pools
resource "google_container_node_pool" "command_layer_nodes" {
  name       = "command-layer"
  project    = var.project_id
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.command_layer_node_count

  node_config {
    preemptible  = false
    machine_type = var.command_layer_machine_type

    # Google recommends custom service accounts with minimum privileges
    service_account = google_service_account.k8s_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    # Enable workload identity on node pool
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      layer = "command"
    }

    tags = ["gke-nodes", "command-layer"]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.command_layer_min_node_count
    max_node_count = var.command_layer_max_node_count
  }
}

resource "google_container_node_pool" "mdm_layer_nodes" {
  name       = "mdm-layer"
  project    = var.project_id
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.mdm_layer_node_count

  node_config {
    preemptible  = false
    machine_type = var.mdm_layer_machine_type
    service_account = google_service_account.k8s_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      layer = "mdm"
    }

    tags = ["gke-nodes", "mdm-layer"]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.mdm_layer_min_node_count
    max_node_count = var.mdm_layer_max_node_count
  }
}

resource "google_container_node_pool" "raw_layer_nodes" {
  name       = "raw-layer"
  project    = var.project_id
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.raw_layer_node_count

  node_config {
    preemptible  = false
    machine_type = var.raw_layer_machine_type
    service_account = google_service_account.k8s_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      layer = "raw"
    }

    tags = ["gke-nodes", "raw-layer"]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.raw_layer_min_node_count
    max_node_count = var.raw_layer_max_node_count
  }
}

resource "google_container_node_pool" "meter_layer_nodes" {
  name       = "meter-layer"
  project    = var.project_id
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.meter_layer_node_count

  node_config {
    preemptible  = false
    machine_type = var.meter_layer_machine_type
    service_account = google_service_account.k8s_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      layer = "meter"
    }

    tags = ["gke-nodes", "meter-layer"]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.meter_layer_min_node_count
    max_node_count = var.meter_layer_max_node_count
  }
}

resource "google_container_node_pool" "network_layer_nodes" {
  name       = "network-layer"
  project    = var.project_id
  location   = var.region
  cluster    = google_container_cluster.primary.name
  node_count = var.network_layer_node_count

  node_config {
    preemptible  = false
    machine_type = var.network_layer_machine_type
    service_account = google_service_account.k8s_sa.email

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]

    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      layer = "network"
    }

    tags = ["gke-nodes", "network-layer"]
  }

  management {
    auto_repair  = true
    auto_upgrade = true
  }

  autoscaling {
    min_node_count = var.network_layer_min_node_count
    max_node_count = var.network_layer_max_node_count
  }
}

# Create a service account for GKE nodes
resource "google_service_account" "k8s_sa" {
  account_id   = "gke-node-sa"
  display_name = "GKE Node Service Account"
  project      = var.project_id
}

# Grant roles to the service account
resource "google_project_iam_member" "k8s_sa_roles" {
  for_each = toset([
    "roles/logging.logWriter",
    "roles/monitoring.metricWriter",
    "roles/monitoring.viewer",
    "roles/storage.objectViewer",
  ])
  
  project = var.project_id
  role    = each.key
  member  = "serviceAccount:${google_service_account.k8s_sa.email}"
}