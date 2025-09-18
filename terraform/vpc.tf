module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${var.project_name}-vpc"
  cidr = var.vpc_cidr

  # Use only 2 AZs instead of 3 to reduce NAT Gateway costs
  azs             = slice(data.aws_availability_zones.available.names, 0, 2)
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  # COST OPTIMIZATION: Single NAT Gateway instead of one per AZ
  enable_nat_gateway = true
  single_nat_gateway = true  # Share one NAT Gateway across all private subnets
  enable_vpn_gateway = false
  enable_dns_hostnames = true
  enable_dns_support = true

  # EKS requires subnets to be tagged
  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }

  tags = local.tags
}
