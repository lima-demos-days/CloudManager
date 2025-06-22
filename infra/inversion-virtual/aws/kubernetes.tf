module "Control-Cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.37.1"

  cluster_name    = "Control-Cluster"
  cluster_version = "1.31"

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.Control-VPC.vpc_id
  subnet_ids = module.Control-VPC.private_subnets

  tags = {
    Environment = "dev"
    Terraform   = "true"
    Name = "Control-Cluster"
  }
}