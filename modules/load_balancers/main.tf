# Load balancers (Network and Application)
# This module sets up network and application load balancers for traffic management.
# It is responsible for distributing incoming traffic across multiple instances, ensuring high availability and reliability.
# The load balancers are essential for managing traffic to the application and providing fault tolerance.
# The network load balancer handles TCP/UDP traffic, while the application load balancer manages HTTP/HTTPS traffic.
# The load balancers are configured with health checks to ensure that traffic is only sent to healthy instances.
# The network load balancer is designed for low-latency, high-throughput applications, while the application load balancer provides advanced routing capabilities.


# Network Load Balancer
resource "google_compute_forwarding_rule" "network_lb" {
  name                  = "network-lb"
  region                = var.region
  project               = var.project_id
  load_balancing_scheme = "EXTERNAL"
  port_range            = "1-65535"
  ip_protocol           = "TCP"
  
  backend_service       = google_compute_region_backend_service.network_lb_backend.id
  network_tier          = "PREMIUM"
}

resource "google_compute_region_backend_service" "network_lb_backend" {
  name                  = "network-lb-backend"
  region                = var.region
  project               = var.project_id
  protocol              = "TCP"
  load_balancing_scheme = "EXTERNAL"
  health_checks         = [google_compute_region_health_check.network_lb_health_check.id]
  session_affinity      = "NONE"
  
  
  dynamic "backend" {
    for_each = var.network_lb_instance_groups
    content {
      group           = backend.value
      balancing_mode  = "CONNECTION"
      max_connections = 1000
    }
  }
}

resource "google_compute_region_health_check" "network_lb_health_check" {
  
  name               = "network-lb-health-check"
  region              = var.region
  project            = var.project_id
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold   = 4
  unhealthy_threshold = 5  
  tcp_health_check {
    port = "80"
  }
}

# Application Load Balancer
resource "google_compute_global_address" "app_lb_ip" {
  name         = "app-lb-ip"
  project      = var.project_id
  address_type = "EXTERNAL"
}

resource "google_compute_global_forwarding_rule" "app_lb" {
  name                  = "app-lb"
  project               = var.project_id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "80"
  target                = google_compute_target_http_proxy.app_lb_proxy.id
  ip_address            = google_compute_global_address.app_lb_ip.id
}

resource "google_compute_target_http_proxy" "app_lb_proxy" {
  name     = "app-lb-proxy"
  project  = var.project_id
  url_map  = google_compute_url_map.app_lb_url_map.id
}

resource "google_compute_url_map" "app_lb_url_map" {
  name            = "app-lb-url-map"
  project         = var.project_id
  default_service = google_compute_backend_service.app_lb_backend.id
}

resource "google_compute_backend_service" "app_lb_backend" {
  name                  = "app-lb-backend"
  project               = var.project_id
  port_name             = "http"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL"
  timeout_sec           = 30
  health_checks         = [google_compute_health_check.app_lb_health_check.id]

  
  dynamic "backend" {
    for_each = var.application_lb_instance_groups
    content {
      group           = backend.value
      balancing_mode  = "UTILIZATION"
      max_utilization = 0.8
      capacity_scaler = 1.0
    }
  }
  
  security_policy = var.security_policy_id
}

resource "google_compute_health_check" "app_lb_health_check" {
  name               = "app-lb-health-check"
  project            = var.project_id
  check_interval_sec = 5
  timeout_sec        = 5
  
  http_health_check {
    port         = "80"
    request_path = "/health"
  }
}

# SSL Configuration for HTTPS if needed
resource "google_compute_global_forwarding_rule" "app_lb_https" {
  count                 = var.enable_ssl ? 1 : 0
  name                  = "app-lb-https"
  project               = var.project_id
  ip_protocol           = "TCP"
  load_balancing_scheme = "EXTERNAL"
  port_range            = "443"
  target                = google_compute_target_https_proxy.app_lb_https_proxy[0].id
  ip_address            = google_compute_global_address.app_lb_ip.id
}

resource "google_compute_target_https_proxy" "app_lb_https_proxy" {
  count   = var.enable_ssl ? 1 : 0
  name    = "app-lb-https-proxy"
  project = var.project_id
  url_map = google_compute_url_map.app_lb_url_map.id
  
  ssl_certificates = [google_compute_ssl_certificate.app_lb_cert[0].id]
}

resource "google_compute_ssl_certificate" "app_lb_cert" {
  count       = var.enable_ssl ? 1 : 0
  name        = "app-lb-cert"
  project     = var.project_id
  private_key = var.ssl_private_key
  certificate = var.ssl_certificate
}