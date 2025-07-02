clusters = [
  {
    cluster_name = "Manager-Cluster"
    cluster_config = {
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
      name = "Manager-VPC"
      cidr = "10.0.0.0/16"
      tags = {
        Name       = "Manager-VPC"
        CostCenter = "Grupo Cibest"
      }
    }
  },
  {
    cluster_name = "Inversiones-Cluster"
    cluster_config = {
      instance_type = ["m6i.large"]
      min_size      = 1
      max_size      = 2
      desired_size  = 1
      tags = {
        Environment = "dev"
        Terraform   = "true"
        Name        = "Inversiones-Cluster"
      }
    }
    vpc = {
      name = "Inversiones-VPC"
      cidr = "192.0.0.0/16"
      tags = {
        Name       = "Inversiones-VPC"
        CostCenter = "Grupo Cibest"
      }
    }
  }
]

flux-setup = {
  git_url         = "https://github.com/jdarguello/CloudManager"
  git_path        = "config/kubernetes/manager"
  git_ref         = "refs/heads/main"
  flux_version    = "2.x"
  flux_registry   = "ghcr.io/fluxcd"
  flux_repository = "oci://ghcr.io/controlplaneio-fluxcd/charts"
  namespace       = "flux-system"
}