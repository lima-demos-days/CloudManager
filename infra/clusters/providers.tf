terraform {
  required_version = ">=1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.95"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.manager.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.manager.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.manager-auth.token
}

provider "helm" {
  kubernetes = {
    config_path = "~/.kube/config"
  }
}