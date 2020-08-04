output "endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "eks-platform-version" {
  value = aws_eks_cluster.main.platform_version
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.main.certificate_authority.0.data
}

