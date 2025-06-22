module "Control-VPC" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.13"

  name = "Control-VPC"
  cidr = "10.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["10.0.0.0/24", "10.0.1.0/24"]

  tags = {
    Name       = "Control-VPC"
    CostCenter = "Grupo Cibest"
  }
}

module "Inversiones-VPC" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~>5.13"

  name = "Inversiones-VPC"
  cidr = "192.0.0.0/16"

  azs             = ["us-east-1a", "us-east-1b"]
  private_subnets = ["192.0.0.0/24", "192.0.1.0/24"]

  tags = {
    Name       = "Inversiones-VPC"
    CostCenter = "Grupo Cibest"
  }
}