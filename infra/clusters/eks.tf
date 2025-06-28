locals {
  clusters = {
    for cluster in var.clusters :
    cluster.cluster_name => cluster.cluster_config
  }
}

module "EKS" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.37.1"

  for_each        = local.clusters
  cluster_name    = each.key
  cluster_version = var.kubernetes-version

  # Optional
  cluster_endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = each.value.node_pools
  }

  vpc_id     = module.VPCs[each.key].vpc_id
  subnet_ids = module.VPCs[each.key].private_subnets

  eks_managed_node_groups = {
    managing-workers = {
      ami_type      = "AL2_x86_64"
      instance_type = each.value.instance_type

      min_size = each.value.min_size
      max_size = each.value.max_size
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = each.value.desired_size
    }
  }

  tags = each.value.tags
}