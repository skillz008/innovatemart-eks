# terraform/eks.tf - MINIMAL WORKING VERSION
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = local.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_managed_node_groups = {
    main = {
      instance_types = ["t3.small"]
      capacity_type  = "SPOT"
      
      min_size     = 1
      max_size     = 3
      desired_size = 2
      
      disk_size = 20
    }
  }

  tags = local.tags
}
