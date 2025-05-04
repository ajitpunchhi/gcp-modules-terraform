# GCP Terraform Infrastructure Modules 🚀

![GCP Terraform](https://img.shields.io/badge/GCP-Terraform-blue?style=for-the-badge&logo=terraform)
![Infrastructure as Code](https://img.shields.io/badge/Infrastructure-as_Code-green?style=for-the-badge&logo=google-cloud)
![License](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)

<p align="center">
  <img src="https://raw.githubusercontent.com/hashicorp/terraform-website/master/public/img/logo-hashicorp.svg" width="300" alt="Terraform">
</p>

<p align="center">
  <b>A modular, production-ready GCP infrastructure built with Terraform.</b>
</p>

---

## 🏗️ Architecture Diagram

<p align="center">
  <img src="https://mermaid.ink/img/pako:eNqNVE1v2zAM_SuETi2QBTl00KHIPiCbsW7YoeihyEGxmVhYbHmUnGwI8t9H2U6aumm7i2U-vkc-UrL2SjvFJJOJ4-JBeX7rDHwePAyeXnvZhLffbKdR2RVHvLvgIbXjQVvVJdM5alTgPbHuwXrcO04ptcGXAWTneBh7wAZjm_tLPDpBu5A8fIRrTz32dQvP9Yee-hwbVMgbP5k8t1g8a8lA9hh-m7ZxAW3QtOtQG9chfIHFCnVSzA3FhS50j4BDRdpgcZg48BUXWrnnqJwj3Tq1VWdLZUqphC3QKRyj815jNzXxVQzdNx8Wau_hkevkFkrNR1hsoR3R4LTBLe2uwYgaK9_tqVGp3Nk5KnS2rJXHFSpTQP4vszVoK2c8YFfKRQYn6bS7mMO4aQxfn34VF_Pl9yjlXGbZfBrNprN5cT2ZZKN5PplNpvNJ8T9AV9l0LqfRbJqVxXUxjYrr0ZEbj8tpFE9SV8aRJovFLXyGSncOYqlE46hP5QwfsdNbp2RHb3cWvNPb8VzqjXpU1kMrlDmDZmJp1M7YE8kKW9GDUrp-9JO-xIFpDLWfYQ6n28YbWL-iBMGYCKMtlkC7w1T6P5aYeC1Bxf2eBi18U04Gh88Qx9UbfXf2fG1Qb-CxUO7tCleCnOEKG9cK9xdRqXiZK29YMDYXIbDPRchXDGGJ35uxq-CXTVlyvgWdVrxjZwKn2K82UVA9ZtKCQcvO82yMWImtVJ1kJrIsmYw3QTKZhuA3Q-iO4UnUUn-XG-Ld-Qc27QgJ" alt="GCP Infrastructure Architecture" width="800">
</p>

## 📋 Overview

This repository contains Terraform modules for deploying a comprehensive, production-ready infrastructure on Google Cloud Platform (GCP). The infrastructure is designed with security, scalability, and maintainability in mind, following best practices for cloud architecture.

## 🌟 Features

- **Modular Design**: Easily reusable and customizable components
- **Network Isolation**: VPC with public and private subnets
- **Security First**: Cloud Armor, IAM, and network security controls
- **High Availability**: Load balancing and multi-zone deployments
- **Container Orchestration**: GKE for managing containerized workloads
- **Messaging and Caching**: MQTT broker and Redis for reliable communication
- **Database**: Cassandra cluster for reliable data storage
- **Infrastructure as Code**: Everything defined as code for consistency

## 🔧 Infrastructure Components

| Component | Description |
|-----------|-------------|
| **VPC Network** | Virtual Private Cloud with public/private subnets and Cloud NAT for outbound connectivity |
| **Kubernetes** | GKE cluster with private nodes and Workload Identity |
| **Cassandra Cluster** | Multi-node Cassandra database with one seed node and two worker nodes |
| **Load Balancers** | Network and Application load balancers for traffic management |
| **Security** | Service accounts, Cloud Armor, and firewall rules for comprehensive security |
| **MQTT Broker** | Messaging broker for IoT and service communication |
| **Memorystore (Redis)** | In-memory data store for caching and real-time data processing |
| **Compute Instances** | VM instances for various application layers |

## 🚀 Getting Started

### Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) (v1.3 or later)
- [Google Cloud SDK](https://cloud.google.com/sdk/docs/install)
- GCP Project with billing enabled
- Service account with appropriate permissions

### Setup

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/gcp-modules-terraform.git
   cd gcp-modules-terraform
   ```

2. Update the `terraform.tfvars` file with your project-specific values:
   ```hcl
   project_id        = "your-gcp-project-id"
   region            = "your-preferred-region"
   zone              = "your-preferred-zone"
   environment       = "dev"
   authorized_network = "10.0.4.0/24"
   sa_account        = "your-service-account-name"
   armor_policy_name = "your-policy-name"
   instance_name     = "your-instance-name"
   machine_type      = "e2-medium"
   ```

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Plan the deployment:
   ```bash
   terraform plan
   ```

5. Apply the changes:
   ```bash
   terraform apply
   ```

## 📦 Modules

### 🔌 Networking
- Creates a VPC with public and private subnets
- Sets up Cloud NAT for outbound connectivity
- Configures network segmentation for different application tiers

### 🔐 Security
- Manages service accounts and IAM roles
- Implements Cloud Armor for DDoS protection
- Defines firewall rules for network security

### 🔄 Load Balancers
- Provides both Network and Application load balancers
- Configures health checks and instance groups
- Supports SSL termination for secure connections

### 🚢 Kubernetes
- Deploys a GKE cluster with private nodes
- Enables network policies and workload identity
- Configures auto-scaling and node management

### 📡 MQTT Broker
- Sets up a messaging broker for IoT and service communication
- Configures Mosquitto on Compute Engine
- Sets up storage and networking for the broker

### 💾 Cassandra Cluster
- Deploys a multi-node Cassandra database
- Configures seed node and worker nodes
- Sets up networking and storage for the database

### 🧠 Memorystore (Redis)
- Provisions a Redis instance for caching
- Configures memory size and networking
- Sets up maintenance windows and version control

### 🖥️ Compute
- Creates VM instances for various application layers
- Configures networking, storage, and security
- Sets up startup scripts for service initialization

## 📝 Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `project_id` | Your GCP Project ID | - |
| `region` | GCP Region | `asia-southeast1` |
| `zone` | GCP Zone | `asia-southeast1-a` |
| `environment` | Deployment environment | `dev` |
| `authorized_network` | Network CIDR for authorization | `10.0.4.0/24` |
| `sa_account` | Service account name | `my-service-account` |
| `armor_policy_name` | Cloud Armor policy name | `cloudpolicy` |
| `instance_name` | VM instance name | `web-server` |
| `machine_type` | VM machine type | `e2-medium` |

## 📊 Monitoring and Logging

This infrastructure comes with built-in monitoring and logging capabilities through Google Cloud Monitoring and Logging. Key metrics and logs are collected for:

- Network traffic and firewall rules
- Kubernetes cluster and workloads
- Compute instances and services
- Database performance and health
- Load balancer traffic and health checks

## 🛡️ Security Considerations

- All private subnets have no direct internet access
- Cloud Armor protects public-facing resources
- IAM roles follow the principle of least privilege
- All services use service accounts with specific permissions
- Network security enforced through firewall rules
- Private GKE cluster with authorized networks

## 📚 Documentation

For more detailed information about each module, refer to the READMEs within each module directory.

## 🔄 CI/CD Pipeline Integration

This infrastructure can be integrated with CI/CD pipelines using tools like:
- GitHub Actions
- Cloud Build
- Jenkins
- CircleCI

Example GitHub Actions workflow:

```yaml
name: Terraform

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v2
    - name: Setup Terraform
      uses: hashicorp/setup-terraform@v1
    - name: Terraform Init
      run: terraform init
    - name: Terraform Format
      run: terraform fmt -check
    - name: Terraform Validate
      run: terraform validate
    - name: Terraform Plan
      run: terraform plan
    - name: Terraform Apply
      if: github.ref == 'refs/heads/main' && github.event_name == 'push'
      run: terraform apply -auto-approve
```

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Contact

If you have any questions or feedback, please open an issue or contact the maintainer.

---

<p align="center">Made with ❤️ for the cloud community</p>
