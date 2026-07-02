# terraform-aws-eks-cluster
### All code is provided for reference purposes only and is used entirely at own risk. Code is for use in development environments only. Not intended for Production use.
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



<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_eks_cluster.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_instance_profile.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_policy) | resource |
| [aws_iam_role.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.managed-AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.managed-AmazonEC2RoleforSSM](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.managed-AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.managed-AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.managed-AmazonEKSVPCResourceController](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.managed-AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.managed-AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.Cluster-Ingress-Local-HTTPS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.controller_ingress](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_dynamic](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.nodes_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.eks-worker-ami](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy.AmazonEKSClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.AmazonEKSServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy.AmazonEKSVPCResourceController](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy) | data source |
| [aws_iam_policy_document.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_subnets.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_vpc.main](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_desired_capacity"></a> [desired\_capacity](#input\_desired\_capacity) | Desired size of EKS Worker ASG | `number` | `1` | no |
| <a name="input_dynamic_iam_policies"></a> [dynamic\_iam\_policies](#input\_dynamic\_iam\_policies) | placeholder for passing custom iam policies to EKS nodes | `any` | `{}` | no |
| <a name="input_ebs_optimized"></a> [ebs\_optimized](#input\_ebs\_optimized) | enable EBS optimized volumes | `bool` | `true` | no |
| <a name="input_enable_ssm"></a> [enable\_ssm](#input\_enable\_ssm) | enable SSM for Worker Nodes | `bool` | `true` | no |
| <a name="input_env_name"></a> [env\_name](#input\_env\_name) | Name of environment for tagging purposes | `string` | n/a | yes |
| <a name="input_k8s_version"></a> [k8s\_version](#input\_k8s\_version) | EKS Supported version of Kubernetes to operate | `string` | `"1.25"` | no |
| <a name="input_key_name"></a> [key\_name](#input\_key\_name) | AWS Hosted SSH key to issue to EKS Worker | `string` | n/a | yes |
| <a name="input_lt_version"></a> [lt\_version](#input\_lt\_version) | Override for $Latest LT Version | `string` | `null` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Maximum size of EKS Worker ASG | `number` | `3` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Minimum size of EKS Worker ASG | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Name of Kubernetes cluster for tagging purposes | `string` | n/a | yes |
| <a name="input_node_ingress_rules"></a> [node\_ingress\_rules](#input\_node\_ingress\_rules) | map of security group rules for eks nodes | <pre>map(object({<br/>    from_port    = optional(string)<br/>    to_port      = optional(string)<br/>    protocol     = optional(string)<br/>    type         = optional(string)<br/>    description  = optional(string)<br/>    source_sg_id = optional(string)<br/>    cidr_blocks  = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_node_instance_type"></a> [node\_instance\_type](#input\_node\_instance\_type) | EC2 Instance size of EKS Workers | `string` | `"m5.large"` | no |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | name identifier of vpc subnets to use for EKS worker deployment | `string` | `"private"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | Identifier of VPC to pass into data source | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_eks-version"></a> [eks-version](#output\_eks-version) | n/a |
| <a name="output_endpoint"></a> [endpoint](#output\_endpoint) | n/a |
| <a name="output_kubeconfig-certificate-authority-data"></a> [kubeconfig-certificate-authority-data](#output\_kubeconfig-certificate-authority-data) | n/a |
| <a name="output_nodes_sg_id"></a> [nodes\_sg\_id](#output\_nodes\_sg\_id) | n/a |
<!-- END_TF_DOCS -->
