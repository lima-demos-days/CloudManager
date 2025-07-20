terraform {
  required_version = ">=1.5"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>5.95"
    }
  }

  backend "s3" {
    bucket         = "tf-bancolombia-tech"       
    key            = "prod/gitops.tfstate" 
    region         = "us-east-1"             
    dynamodb_table = "terraform-locks" 
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
    host                   = data.aws_eks_cluster.manager.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.manager.certificate_authority[0].data)
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.manager.name]
      command     = "aws"
    }
  }
}