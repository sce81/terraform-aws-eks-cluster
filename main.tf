resource "aws_eks_cluster" "main" {
  name     = "${var.name}-${var.env_name}"
  role_arn = aws_iam_role.cluster.arn
  version  = var.k8s_version

  vpc_config {
    subnet_ids = data.aws_subnets.main.ids
  }
  depends_on = [
    aws_iam_role_policy_attachment.managed-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.managed-AmazonEKSVPCResourceController,
  ]
}



resource "aws_security_group" "cluster" {
  name        = "${var.name}-${var.env_name}-cluster-sg"
  description = "Cluster Internal Communications"
  vpc_id      = data.aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${aws_eks_cluster.main.name}-cluster"
    Environment = "${var.env_name}"
  }
}


resource "aws_security_group_rule" "controller_ingress" {
  from_port                = "443"
  to_port                  = "443"
  protocol                 = "tcp"
  type                     = "ingress"
  description              = "Allows ${aws_eks_cluster.main.name} Nodes to talk to Cluster"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.node.id
}


// Needs Work
resource "aws_security_group_rule" "Cluster-Ingress-Local-HTTPS" {
  cidr_blocks       = [data.aws_vpc.main.cidr_block]
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  type              = "ingress"
  description       = "Allows externals to talk to ${aws_eks_cluster.main.name} Cluster"
  security_group_id = aws_security_group.cluster.id
  #  source_security_group_id  = "${aws_security_group.node.id}"
}



resource "aws_iam_role_policy_attachment" "managed-AmazonEKSClusterPolicy" {
  role       = aws_iam_role.cluster.name
  policy_arn = data.aws_iam_policy.AmazonEKSClusterPolicy.arn
}
resource "aws_iam_role_policy_attachment" "managed-AmazonEKSVPCResourceController" {
  policy_arn = data.aws_iam_policy.AmazonEKSVPCResourceController.arn
  role       = aws_iam_role.cluster.name
}
resource "aws_iam_role_policy_attachment" "managed-AmazonEKSServicePolicy" {
  role       = aws_iam_role.cluster.name
  policy_arn = data.aws_iam_policy.AmazonEKSServicePolicy.arn
}

resource "aws_iam_role" "cluster" {
  name = "${var.name}-${var.env_name}-eks-cluster-iam-role"

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