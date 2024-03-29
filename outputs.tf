output "endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "eks-version" {
  value = aws_eks_cluster.main.version
}

output "kubeconfig-certificate-authority-data" {
  value = aws_eks_cluster.main.certificate_authority.0.data
}

output "nodes_sg_id" {
  value = aws_security_group.node.id
}