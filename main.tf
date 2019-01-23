resource "aws_eks_cluster" "main" {
  name                      = "${var.env}-${var.name}"
  role_arn                  = "${aws_iam_role.eks-iam-role.arn}"
  version                   = "${var.version}"

  vpc_config {
    subnet_ids              = ["${var.subnet_ids}"]
    security_group_ids      = ["${var.security_group_ids}"]
  }
}


data "aws_iam_policy" "AmazonEKSClusterPolicy" {
  arn                       = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

data "aws_iam_policy" "AmazonEKSServicePolicy" {
  arn                       = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

resource "aws_iam_role_policy_attachment" "eks-cluster-policy-attach" {
  role                      = "${aws_iam_role.eks-iam-role.name}"
  policy_arn                = "${data.aws_iam_policy.AmazonEKSClusterPolicy.arn}"
}

resource "aws_iam_role_policy_attachment" "eks-service-policy-attach" {
  role                      = "${aws_iam_role.eks-iam-role.name}"
  policy_arn                = "${data.aws_iam_policy.AmazonEKSServicePolicy.arn}"
}


resource "aws_iam_role" "eks-iam-role" {
  name                      = "${var.env}-${var.name}-iam-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF


}