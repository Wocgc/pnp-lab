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

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.6.0"
  cluster_name    = "cgc-key"
  cluster_version = "1.32"
  vpc_id          = data.terraform_remote_state.base.outputs.vpc_id
  subnet_ids      = data.terraform_remote_state.base.outputs.private_subnet_ids
  enable_irsa      = true

  enable_cluster_creator_admin_permissions = true
  
  # EKS API 접근 권한
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  eks_managed_node_groups = {
    default = {
     desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]
      iam_role_arn   = data.terraform_remote_state.base.outputs.eks_node_role_arn
    }
  }

  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }

    kube-proxy = {
      resolve_conflicts = "OVERWRITE"
    }

    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }

    eks-pod-identity-agent = {
      resolve_conflicts = "OVERWRITE"
    }
  }

  node_security_group_additional_rules = {
    # 1. 노드 간 전체 통신 허용
    ingress_self_all = {
      description = "Allow all traffic between nodes"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    # 2. kubelet API (control plane → 노드)
    kubelet_api = {
      description                   = "Allow kubelet API"
      protocol                      = "TCP"
      from_port                     = 10250
      to_port                       = 10250
      type                          = "ingress"
      source_node_security_group    = true
    }

    dns_tcp = {
      description                   = "Allow DNS (TCP)"
      protocol                      = "TCP"
      from_port                     = 53
      to_port                       = 53
      type                          = "ingress"
      source_node_security_group    = true
    }
  }

}

