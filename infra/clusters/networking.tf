locals {
  vpcs = {
    for cluster in var.clusters :
    cluster.cluster_name => cluster.vpc
  }

  azs = slice(data.aws_availability_zones.available.names, 0, 3)
}

data "aws_availability_zones" "available" {
  # Exclude local zones
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "VPCs" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.13"

  for_each = local.vpcs
  name     = each.value.name
  cidr     = each.value.cidr

  azs             = local.azs
  private_subnets = [for k, v in local.azs : cidrsubnet(each.value.cidr, 4, k)]
  public_subnets  = [for k, v in local.azs : cidrsubnet(each.value.cidr, 8, k + 48)]
  intra_subnets   = [for k, v in local.azs : cidrsubnet(each.value.cidr, 8, k + 52)]

  enable_nat_gateway = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = each.value.tags
}