#project values for terraform.tfvars

region = "asia-southeast1"
zone = "asia-southeast1-a"
environment = "dev"
project_id = "ehes-gcp-poc"


authorized_network = "10.0.4.0/24"

#security_policy values for terraform.tfvars
sa_account = "my-service-account"
armor_policy_name = "cloudpolicy"

#vm creation values for terraform.tfvars
instance_name = "web-server"
machine_type = "e2-medium"