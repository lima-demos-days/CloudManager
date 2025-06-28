locals {
  vpcs = {
    for cluster in var.clusters :
    cluster.cluster_name => cluster.vpc
  }
}

module "VPCs" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.13"

  for_each = local.vpcs
  name     = each.value.name
  cidr     = each.value.cidr

  azs             = each.value.azs
  private_subnets = each.value.private_subnets

  tags = each.value.tags
}