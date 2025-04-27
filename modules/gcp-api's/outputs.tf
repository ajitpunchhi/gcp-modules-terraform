output "enabled_apis" {
  description = "List of APIs that were enabled"
  value       = [for api in google_project_service.project_services : api.service]
}

output "project_id" {
  description = "GCP project ID"
  value       = var.project_id
}