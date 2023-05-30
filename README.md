# terraform-aws-eks-cluster
Terraform module for creating an AWS EKS Cluster 

## Getting Started

This module is intended to create an AWS EC2 Cluster with common dependancies

### Resources
- aws_eks_cluster.main
- aws_security_group.cluster
- aws_security_group_rule.controller_ingress
- aws_iam_role_policy_attachment.managed-AmazonEKSClusterPolicy
- aws_iam_role_policy_attachment.managed-AmazonEKSVPCResourceController
- aws_iam_role_policy_attachment.managed-AmazonEKSServicePolicy
- aws_iam_role.cluster
- aws_eks_node_group.main
- aws_launch_template.main
- aws_security_group.node
- aws_security_group_rule.controller_ingress
- aws_security_group_rule.nodes_self
- aws_security_group_rule.nodes_dynamic
- aws_iam_role.node
- aws_iam_role_policy_attachment.managed-AmazonEKSWorkerNodePolicy
- aws_iam_role_policy_attachment.managed-AmazonEKS_CNI_Policy
- aws_iam_role_policy_attachment.managed-AmazonEC2ContainerRegistryReadOnly
- aws_iam_role_policy_attachment.managed-AmazonEC2RoleforSSM
- aws_iam_instance_profile.node


### Data Sources
- aws_caller_identity.current
- aws_region.current
- aws_iam_policy.AmazonEKSClusterPolicy
- aws_iam_policy.AmazonEKSServicePolicy
- aws_iam_policy.AmazonEKSVPCResourceController
- aws_vpc.main
- aws_subnets.main
- aws_ami.eks-worker-ami


### Prerequisites

    Terraform ~> 1.4.0
    aws ~> 5.0.0

### Tested

    Terraform ~> 1.4.6
    aws ~> 5.0.2

### Installing

This module should be called by a terraform environment configuration

```
    module "example_cluster" {
    source               = "git@github.com:sce81/terraform-aws-eks-cluster.git"
     name                = var.name
     env_name            = var.env_name
     vpc_name            = var.vpc_name
     subnet_name         = var.subnet_name
     node_instance_type  = var.node_instance_type
     desired_capacity    = var.desired_capacity
     max_size            = var.max_size
     key_name            = module.ssh-key.name
}
```

addional tags can be appended using the following map values

    extra_tags


### Outputs

The following values are outputted

- endpoint
- eks-version
- kubeconfig-certificate-authority-data
- nodes_sg_id


