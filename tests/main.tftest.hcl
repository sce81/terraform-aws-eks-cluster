
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.

run "data_validation" {
  assert {
    condition     = data.aws_caller_identity.current != null
    error_message = "aws_caller_identity not found"
  }

  assert {
    condition     = data.aws_region.current != null
    error_message = "aws_region not found"
  }

  assert {
    condition     = data.aws_iam_policy.AmazonEKSClusterPolicy != null
    error_message = "aws_iam_policy.AmazonEKSClusterPolicy not found"
  }

  assert {
    condition     = data.aws_iam_policy.AmazonEKSServicePolicy != null
    error_message = "aws_iam_policy.AmazonEKSServicePolicy not found"
  }

  assert {
    condition     = data.aws_iam_policy.AmazonEKSVPCResourceController != null
    error_message = "aws_iam_policy.AmazonEKSVPCResourceController not found"
  }

  assert {
    condition     = data.aws_vpc.main != null
    error_message = "aws_vpc.main not found"
  }

  assert {
    condition     = data.aws_subnets.main != null
    error_message = "aws_subnets.main not found"
  }

  assert {
    condition     = data.aws_ami.eks-worker-ami != null
    error_message = "aws_ami.eks-worker-ami not found"
  }

  assert {
    condition     = data.aws_iam_policy_document.main != null
    error_message = "aws_iam_policy_document.main not found"
  }
}

run "main_validation" {
  assert {
    condition     = aws_eks_cluster.main != null
    error_message = "aws_eks_cluster.main not found"
  }

  assert {
    condition     = aws_security_group.cluster != null
    error_message = "aws_security_group.cluster not found"
  }

  assert {
    condition     = aws_security_group_rule.controller_ingress != null
    error_message = "aws_security_group_rule.controller_ingress not found"
  }

  assert {
    condition     = aws_security_group_rule.Cluster-Ingress-Local-HTTPS != null
    error_message = "aws_security_group_rule.Cluster-Ingress-Local-HTTPS not found"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.managed-AmazonEKSClusterPolicy != null
    error_message = "aws_iam_role_policy_attachment.managed-AmazonEKSClusterPolicy not found"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.managed-AmazonEKSVPCResourceController != null
    error_message = "aws_iam_role_policy_attachment.managed-AmazonEKSVPCResourceController not found"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.managed-AmazonEKSServicePolicy != null
    error_message = "aws_iam_role_policy_attachment.managed-AmazonEKSServicePolicy not found"
  }

  assert {
    condition     = aws_iam_role.cluster != null
    error_message = "aws_iam_role.cluster not found"
  }
}

run "nodes_validation" {
  assert {
    condition     = aws_eks_node_group.main != null
    error_message = "aws_eks_node_group.main not found"
  }

  assert {
    condition     = aws_launch_template.main != null
    error_message = "aws_launch_template.main not found"
  }

  assert {
    condition     = aws_security_group.node != null
    error_message = "aws_security_group.node not found"
  }

  assert {
    condition     = aws_security_group_rule.nodes_self != null
    error_message = "aws_security_group_rule.nodes_self not found"
  }

  assert {
    condition     = aws_security_group_rule.nodes_dynamic != null
    error_message = "aws_security_group_rule.nodes_dynamic not found"
  }

  assert {
    condition     = aws_iam_role.node != null
    error_message = "aws_iam_role.node not found"
  }

  assert {
    condition     = aws_iam_policy.main != null
    error_message = "aws_iam_policy.main not found"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.managed-AmazonEKSWorkerNodePolicy != null
    error_message = "aws_iam_role_policy_attachment.managed-AmazonEKSWorkerNodePolicy not found"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.managed-AmazonEKS_CNI_Policy != null
    error_message = "aws_iam_role_policy_attachment.managed-AmazonEKS_CNI_Policy not found"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.managed-AmazonEC2ContainerRegistryReadOnly != null
    error_message = "aws_iam_role_policy_attachment.managed-AmazonEC2ContainerRegistryReadOnly not found"
  }

  assert {
    condition     = aws_iam_role_policy_attachment.managed-AmazonEC2RoleforSSM != null
    error_message = "aws_iam_role_policy_attachment.managed-AmazonEC2RoleforSSM not found"
  }

  assert {
    condition     = aws_iam_instance_profile.node != null
    error_message = "aws_iam_instance_profile.node not found"
  }
}

run "outputs_validation" {
  assert {
    condition     = output.endpoint != null
    error_message = "output.endpoint not found"
  }

  assert {
    condition     = output.eks-version != null
    error_message = "output.eks-version not found"
  }

  assert {
    condition     = output.kubeconfig-certificate-authority-data != null
    error_message = "output.kubeconfig-certificate-authority-data not found"
  }

  assert {
    condition     = output.nodes_sg_id != null
    error_message = "output.nodes_sg_id not found"
  }
}