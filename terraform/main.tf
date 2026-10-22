provider "aws" {
  region = "ap-south-1"
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"
  name = "eks-vpc"
  cidr = "10.0.0.0/16"
  azs = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets = ["10.0.101.0/24", "10.0.102.0/24"]
  enable_nat_gateway = false
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.0.0"
  cluster_name = "eks-llm-cluster"
  cluster_version = "1.29"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
  eks_managed_node_groups = {
    gpu = {
      instance_types = ["t3.micro"]
      min_size = 0
      max_size = 2
      desired_size = 1
    }
  }
}

resource "aws_ecr_repository" "llm" {
  name = "eks-llm"
}