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
 
  # ✅ KMS 중복 생성 방지
  create_kms_key            = false

  # ✅ CloudWatch 로그 중복 생성 방지
  create_cloudwatch_log_group = false
  
  cluster_encryption_config    = {}
  
  # ✅ 로그 타입 설정은 이렇게!
  cluster_enabled_log_types = ["api", "audit", "authenticator"]
  
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

    metrics-server = {
      resolve_conflicts = "OVERWRITE"
    }

    external-dns = {
      resolve_conflicts = "OVERWRITE"
    }
  }
}

