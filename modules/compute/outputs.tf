output "instance_id" {
  description = "ID of the VM instance"
  value       = google_compute_instance.vm_instance.id
}

output "instance_name" {
  description = "Name of the VM instance"
  value       = google_compute_instance.vm_instance.name
}
