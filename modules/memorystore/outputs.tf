# Outputs
output "instance_id" {
  description = "The ID of the instance"
  value       = google_redis_instance.cache.id
}

output "host" {
  description = "The IP address of the instance"
  value       = google_redis_instance.cache.host
}

output "port" {
  description = "The port of the instance"
  value       = google_redis_instance.cache.port
}

output "current_location_id" {
  description = "The current zone where the Redis endpoint is placed"
  value       = google_redis_instance.cache.current_location_id
}

output "persistence_iam_identity" {
  description = "IAM identity used by import/export operations"
  value       = google_redis_instance.cache.persistence_iam_identity
}

output "auth_string" {
  description = "AUTH string set on the instance"
  value       = google_redis_instance.cache.auth_string
  sensitive   = true
}

output "server_ca_certs" {
  description = "TLS server CA certificates"
  value       = google_redis_instance.cache.server_ca_certs
  sensitive   = true
}