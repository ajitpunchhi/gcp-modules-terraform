# IAM Service Account
resource "google_service_account" "service_account" {
  account_id   = var.service_account_name
  display_name = "Service Account for GCP Resources"
  project      = var.project_id
}

/*resource "google_project_iam_binding" "service_account_roles" {
  project = var.project_id
  role    = "roles/editor"
  
  members = [
    "serviceAccount:${google_service_account.service_account.email}",
  ]
}*/

# Cloud Armor Security Policy
resource "google_compute_security_policy" "cloud_armor" {
  name        = var.cloud_armor_policy_name
  description = "Cloud Armor security policy"
  project     = var.project_id

  rule {
    action   = "allow"
    priority = "1000"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["0.0.0.0/0"]
      }
    }
    description = "Allow all traffic"
  }

  rule {
    action   = "deny(403)"
    priority = "2147483647"
    match {
      versioned_expr = "SRC_IPS_V1"
      config {
        src_ip_ranges = ["*"]
      }
    }
    description = "Default deny rule"
  }
}
