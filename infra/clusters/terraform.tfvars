clusters = [
  {
    cluster_name = "Manager-Cluster"
    cluster_config = {
      node_pools    = ["general-purpose"]
      instance_type = ["m6i.large"]
      min_size      = 1
      max_size      = 2
      desired_size  = 1
      tags = {
        Environment = "dev"
        Terraform   = "true"
        Name        = "Manager-Cluster"
      }
    }
    vpc = {
      name            = "Manager-VPC"
      cidr            = "10.0.0.0/16"
      azs             = ["us-east-1a", "us-east-1b"]
      private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]
      tags = {
        Name       = "Manager-VPC"
        CostCenter = "Grupo Cibest"
      }
    }
  }
]