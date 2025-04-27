resource "google_project_service" "project_services" {
  for_each = toset(var.apis)

  project                    = var.project_id
  service                    = each.value
  disable_on_destroy         = var.disable_services_on_destroy
  disable_dependent_services = var.disable_dependent_services
}