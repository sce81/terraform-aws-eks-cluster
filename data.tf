data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "aws_iam_policy" "AmazonEKSClusterPolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_iam_policy" "AmazonEKSServicePolicy" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

data "aws_iam_policy" "AmazonEKSVPCResourceController" {
  arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}


data "aws_vpc" "main" {
  filter {
    name   = "tag:Name"
    values = ["${var.vpc_name}-${var.env_name}-vpc"]
  }
}

data "aws_subnets" "main" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.main.id]
  }

  filter {
    name   = "tag:Name"
    values = ["*-${var.subnet_name}-*"]
  }
}

data "aws_ami" "eks-worker-ami" {
  filter {
    name   = "name"
    values = ["amazon-eks-node-${var.k8s_version}-*"]
  }

  most_recent = true
  owners      = ["602401143452"] # Amazon
}


//data "aws_ssm_parameter" "eks_ami_release_version" {
//  name = "/aws/service/eks/optimized-ami/${aws_eks_cluster.main.version}/amazon-linux-2/recommended/release_version"
//}