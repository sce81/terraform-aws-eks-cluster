resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.name}-${var.env_name}-eks-node-group"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = data.aws_subnets.main.ids
  instance_types  = var.node_instance_type

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
    aws_iam_role_policy_attachment.example-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.example-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.example-AmazonEC2ContainerRegistryReadOnly,
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


//resource "aws_launch_template" "main" {
//  name                                      = "${var.name}-${var.env_name}-eks-node"
//  ebs_optimized                             = var.ebs_optimized
//  instance_type                             = var.node_instance_type
//
//  iam_instance_profile {
//    name = aws_iam_instance_profile.node.name
//  }
//
//  monitoring {
//    enabled = true
//  }
//}

resource "aws_launch_configuration" "eks" {
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.node.name
  image_id                    = data.aws_ami.eks-worker-ami.id
  instance_type               = var.node_instance_type
  name_prefix                 = "${aws_eks_cluster.main.name}-lc-"
  security_groups             = ["${aws_security_group.node.id}"]
  key_name                    = var.key_name
  user_data                   = file("${path.module}/userdata/node-userdata.sh")

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_eks_cluster.main
  ]
}

resource "aws_autoscaling_group" "nodes" {
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.eks.id
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "${var.name}-${var.env_name}-eks-node-asg"
  vpc_zone_identifier  = data.aws_subnets.main.ids

  tag {
    key                 = "Name"
    value               = "${var.name}-${var.env_name}-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${aws_eks_cluster.main.name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = var.env_name
    propagate_at_launch = true
  }


  depends_on = [
    aws_eks_cluster.main
  ]
}


resource "aws_security_group" "node" {
  name        = "${var.name}-${var.env_name}-node-sg"
  description = "Node Internal Communications"
  vpc_id      = data.aws_vpc.main.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.name}-${var.env_name}-nodes"
    Environment = "${var.env_name}"
  }

  depends_on = [
    aws_eks_cluster.main
  ]
}


resource "aws_security_group_rule" "Nodes-Ingress-Self" {
  from_port                = "0"
  to_port                  = "65535"
  protocol                 = "-1"
  type                     = "ingress"
  description              = "Allows ${aws_eks_cluster.main.name} workers to talk to each other"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.node.id
}

resource "aws_security_group_rule" "Nodes-Ingress-Local-HTTPS" {
  cidr_blocks       = [data.aws_vpc.main.cidr_block]
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
  type              = "ingress"
  description       = "Allow external services to talk to ${aws_eks_cluster.main.name} workers"
  security_group_id = aws_security_group.node.id
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



resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2RoleforSSM" {
  count      = var.enable_ssm == true ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
  role       = aws_iam_role.node.name
}

resource "aws_iam_instance_profile" "node" {
  name = "${var.name}-${var.env_name}-eks-node-instance-profile"
  role = aws_iam_role.node.name
}