output "vpc_id" {
  description = "ID of the VPC"
  value       = google_compute_network.vpc.id
}

output "vpc_name" {
  description = "Name of the VPC"
  value       = google_compute_network.vpc.name
}

output "public_subnet_id" {
  description = "ID of the public subnet"
  value       = google_compute_subnetwork.public_subnet.id
}

output "public_subnet_name" {
  description = "Name of the public subnet"
  value       = google_compute_subnetwork.public_subnet.name
}

output "private_subnet_01_id" {
  description = "ID of the private subnet"
  value       = google_compute_subnetwork.private_subnet_01.id
}

output "private_subnet_01_name" {
  description = "Name of the private subnet"
  value       = google_compute_subnetwork.private_subnet_01.name
}

output "private_subnet_02_id" {
  description = "ID of the private subnet"
  value       = google_compute_subnetwork.private_subnet_02.id
}

output "private_subnet_02_name" {
  description = "Name of the private subnet"
  value       = google_compute_subnetwork.private_subnet_02.name
}

output "private_subnet_03_id" {
  description = "ID of the private subnet"
  value       = google_compute_subnetwork.private_subnet_03.id
}

output "private_subnet_03_name" {
  description = "Name of the private subnet"
  value       = google_compute_subnetwork.private_subnet_03.name
}

output "private_subnet_04_id" {
  description = "ID of the private subnet"
  value       = google_compute_subnetwork.private_subnet_04.id
}

output "private_subnet_04_name" {
  description = "Name of the private subnet"
  value       = google_compute_subnetwork.private_subnet_04.name
}

output "private_subnet_05_id" {
  description = "ID of the private subnet"
  value       = google_compute_subnetwork.private_subnet_05.id
}

output "private_subnet_05_name" {
  description = "Name of the private subnet"
  value       = google_compute_subnetwork.private_subnet_05.name
}

/*output "private_subnet_ec2_id" {
  description = "ID of the private subnet EC2"
  value       = google_compute_subnetwork.private_subnet_ec2.id
}
*/
