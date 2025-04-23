# This module configures security settings, including service accounts and IAM roles.
# It is responsible for managing access control and permissions for resources within the GCP project.
# The security module is essential for ensuring that only authorized users and services can access resources.
# The security module is created with a service account for the application and a Cloud Armor policy for protecting the application from DDoS attacks.
# The service account is granted the necessary IAM roles to access resources within the project.
# The Cloud Armor policy is configured with rules to allow or deny traffic based on specified criteria.

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
