module "eks_nodegroup" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "20.6.0"

  cluster_name = data.terraform_remote_state.eks_cluster.outputs.cluster_name
  cluster_version = "1.32"
  vpc_id          = data.terraform_remote_state.base.outputs.vpc_id
  subnet_ids      = data.terraform_remote_state.base.outputs.private_subnet_ids

  create_node_security_group = true

  eks_managed_node_groups = {
    cgc_node_group = {
      desired_size   = 2
      max_size       = 3
      min_size       = 1
      instance_types = ["t3.medium"]
      iam_role_arn   = data.terraform_remote_state.base.outputs.eks_node_group_role_arn
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

  metrics-server = {
    resolve_conflicts = "OVERWRITE"
  }

  external-dns = {
    resolve_conflicts = "OVERWRITE"
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

