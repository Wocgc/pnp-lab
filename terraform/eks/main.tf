terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.29"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

data "terraform_remote_state" "base" {
  backend = "s3"

  config = {
    bucket = "cgc-test-terraform-state"
    key    = "base/terraform.tfstate"
    region = "ap-northeast-2"
  }
}

module "eks_cluster" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.6.0"

  cluster_name    = "cgc-cluster"
  cluster_version = "1.32"
  vpc_id          = data.terraform_remote_state.base.outputs.vpc_id
  subnet_ids      = data.terraform_remote_state.base.outputs.private_subnet_ids

  enable_irsa      = true
  enable_cluster_creator_admin_permissions = true
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  create_node_security_group = true
}

