
resource "aws_launch_configuration" "eks" {
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.node.name
  image_id                    = data.aws_ami.eks-worker-ami.id
  instance_type               = var.node_instance_type
  name_prefix                 = "${var.name}-eks-"
  security_groups             = ["${aws_security_group.node.id}"]
  key_name                    = var.key_name
  user_data                   = file("${path.module}/userdata/node-userdata.sh")

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "nodes" {
  desired_capacity     = var.desired_capacity
  launch_configuration = aws_launch_configuration.eks.id
  max_size             = var.max_size
  min_size             = var.min_size
  name                 = "${var.name}-eks-asg"
  vpc_zone_identifier  = data.aws_subnets.main.ids

  tag {
    key                 = "Name"
    value               = "${var.name}-${var.env_name}-eks-node"
    propagate_at_launch = true
  }

  tag {
    key                 = "kubernetes.io/cluster/${var.name}"
    value               = "owned"
    propagate_at_launch = true
  }

  tag {
    key                 = "Environment"
    value               = "${var.name}-eks-node"
    propagate_at_launch = true
  }


  depends_on = [
    aws_eks_cluster.main
  ]
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
    Name        = "${var.name}-nodes"
    Environment = "${var.env_name}"
  }
}


resource "aws_security_group_rule" "Nodes-Ingress-Self" {
  from_port                = "0"
  to_port                  = "65535"
  protocol                 = "-1"
  type                     = "ingress"
  description              = "Allows Nodes to talk to each other"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.node.id
}

//resource "aws_security_group_rule" "Nodes-Ingress-Local-HTTPS" {
//  cidr_blocks       = ["${var.local_ip}"]
//  from_port         = "443"
//  to_port           = "443"
//  protocol          = "tcp"
//  type              = "ingress"
//  description       = "Allows Pods to talk to Cluster"
//  security_group_id = aws_security_group.node.id
//  #  source_security_group_id          = "${aws_security_group.node.id}"
//}


resource "aws_iam_role" "node" {
  name = "${var.name}-eks-node-role"

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

resource "aws_iam_instance_profile" "node" {
  name = "${var.name}-${var.env_name}-eks-node-instance-profile"
  role = aws_iam_role.node.name
}