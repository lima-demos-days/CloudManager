module "Manager-Cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.37.1"

  cluster_name    = "Manager-Cluster"
  cluster_version = "1.32"

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.Manager-VPC.vpc_id
  subnet_ids = module.Manager-VPC.private_subnets

  eks_managed_node_groups = {
    managing-workers = {
      ami_type      = "AL2_x86_64"
      instance_type = ["m6i.large"]

      min_size = 1
      max_size = 2
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 2
    }
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
    Name = "Manager-Cluster"
  }
}