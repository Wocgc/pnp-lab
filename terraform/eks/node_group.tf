data "terraform_remote_state" "eks_cluster" {
  backend = "s3"
  config = {
    bucket = "cgc-test-terraform-state"
    key    = "eks/terraform.tfstate"       # 📌 정확한 클러스터 tfstate 경로
    region = "ap-northeast-2"
  }
}

module "eks_nodegroup" {
  source  = "terraform-aws-modules/eks/aws//modules/eks-managed-node-group"
  version = "20.6.0"

  cluster_name = module.eks_cluster.cluster_name
  subnet_ids   = data.terraform_remote_state.base.outputs.private_subnet_ids

  name            = "cgc-node-group"
  instance_types  = ["t3.medium"]
  desired_size    = 2
  min_size        = 1
  max_size        = 3

  ami_type     = "AL2_x86_64"
  iam_role_arn = data.terraform_remote_state.base.outputs.eks_node_group_role_arn
}

