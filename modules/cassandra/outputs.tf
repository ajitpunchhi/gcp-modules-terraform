# Outputs
output "cassandra_ips" {
  description = "Private IPs of Cassandra nodes"
  value       = google_compute_instance.cassandra_nodes[*].network_interface[0].network_ip
}

output "cassandra_public_ips" {
  description = "Public IPs of Cassandra nodes"
  value       = google_compute_instance.cassandra_nodes[*].network_interface[0].access_config[0].nat_ip
}

output "cluster_name" {
  description = "Name of the Cassandra cluster"
  value       = var.cluster_name
}

output "seed_nodes" {
  description = "Seed nodes for Cassandra cluster"
  value       = join(",", [for i in range(min(3, var.node_count)) : 
              google_compute_instance.cassandra_nodes[i].network_interface[0].network_ip])
}