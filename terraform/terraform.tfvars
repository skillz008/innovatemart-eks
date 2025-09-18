aws_region = "us-east-1"
project_name = "innovatemart"
environment = "prod"

vpc_cidr = "10.0.0.0/16"
private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]

kubernetes_version = "1.28"

# Use strong passwords here
mysql_password = "Password123"
postgres_password = "Password123"

domain_name = "Skillz008.onmicrosoft.com"
