output "vpc_id" {
  value = aws_vpc.cgc_pnp_vpc.id
}

output "private_subnet_ids" {
  value = [
    aws_subnet.private_subnet_2a.id,
    aws_subnet.private_subnet_2c.id
  ]
}

output "eks_cluster_role_arn" {
  value = aws_iam_role.eks_cluster_role.arn
}

output "eks_node_role_arn" {
  value = aws_iam_role.eks_node_role.arn
}

