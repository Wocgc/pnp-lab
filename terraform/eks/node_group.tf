module "eks_nodegroup" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.6.0"

  cluster_name    = "cgc-cluster"
  cluster_version = "1.32"
  vpc_id          = data.terraform_remote_state.base.outputs.vpc_id
  subnet_ids      = data.terraform_remote_state.base.outputs.private_subnet_ids

  manage_aws_auth_configmap = false # 이미 클러스터에서 했으므로 비활성화

  create_eks = false  # ❌ 클러스터 생성 안 함
  create_node_security_group = true
  create_eks_managed_node_group = true  # ✅ 여기서 NodeGroup만 생성

  eks_managed_node_groups = {
    cgc_node_group = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]
      iam_role_arn   = data.terraform_remote_state.base.outputs.eks_node_group_role_arn
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Allow all traffic between nodes"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    kubelet_api = {
      description = "Allow kubelet API"
      protocol    = "TCP"
      from_port   = 10250
      to_port     = 10250
      type        = "ingress"
      source_node_security_group = true
    }

    dns_tcp = {
      description = "Allow DNS TCP"
      protocol    = "TCP"
      from_port   = 53
      to_port     = 53
      type        = "ingress"
      source_node_security_group = true
    }
  }
}

