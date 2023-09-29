resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.name}-${var.env_name}-eks-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = data.aws_subnets.main.ids
  instance_types  = [var.node_instance_type]
  launch_template {
    name    = aws_launch_template.main.name
    version = var.lt_version == null ? "$Latest" : var.lt_version
  }

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = var.max_size
    min_size     = var.min_size
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.managed-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.managed-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.managed-AmazonEC2ContainerRegistryReadOnly,
  ]
  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  tags = {
    Name                                                 = "${aws_eks_cluster.main.name}-node-group"
    Environment                                          = "${var.env_name}"
    Cluster                                              = aws_eks_cluster.main.name
    "kubernetes.io/cluster/${aws_eks_cluster.main.name}" = "owned"
  }
}


resource "aws_launch_template" "main" {
  name_prefix   = "${var.name}-${var.env_name}-eks-lt-"
  ebs_optimized = var.ebs_optimized

  monitoring {
    enabled = true
  }
  tag_specifications {
    resource_type = "instance"

    tags = {
      Name        = "${var.name}-${var.env_name}-eks-node"
      Environment = var.env_name
    }
  }
}



resource "aws_security_group" "node" {
  name        = "${var.name}-${var.env_name}-eks-node-sg"
  description = "Node Internal Communications"
  vpc_id      = data.aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-${var.env_name}-eks-nodes"
    Environment = "${var.env_name}"
  }

  depends_on = [
    aws_eks_cluster.main
  ]
}


resource "aws_security_group_rule" "nodes_self" {
  from_port                = "0"
  to_port                  = "65535"
  protocol                 = "-1"
  type                     = "ingress"
  description              = "Allows ${aws_eks_cluster.main.name} eks nodes to talk to each other"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.node.id
}
resource "aws_security_group_rule" "nodes_dynamic" {
  for_each = var.node_ingress_rules

  from_port                = each.value.from_port
  to_port                  = each.value.to_port
  protocol                 = each.value.protocol
  type                     = each.value.type
  description              = each.key
  source_security_group_id = each.value.source_sg_id
  cidr_blocks              = [each.value.cidr_blocks]
  security_group_id        = aws_security_group.node.id
}

resource "aws_iam_role" "node" {
  name = "${var.name}-${var.env_name}-eks-node-iam-role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

resource "aws_iam_policy" "main" {
  count  = var.dynamic_iam_policies == {} ? 0 : 1
  name   = "${var.name}-${var.env_name}-eks-node-policy"
  path   = "/"
  policy = element(data.aws_iam_policy_document.main.json, count.index)
}

resource "aws_iam_role_policy_attachment" "managed-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "managed-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "managed-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "managed-AmazonEC2RoleforSSM" {
  count      = var.enable_ssm == true ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.node.name
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.name}-${var.env_name}-eks-node-instance-profile"
  role = aws_iam_role.node.name
}