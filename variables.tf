variable "env_name" {
  type        = string
  description = "Name of environment for tagging purposes"
}
variable "vpc_name" {
  type        = string
  description = "Identifier of VPC to pass into data source"
}
variable "name" {
  type        = string
  description = "Name of Kubernetes cluster for tagging purposes"
}
variable "key_name" {
  type        = string
  description = "AWS Hosted SSH key to issue to EKS Worker"
}
variable "min_size" {
  type        = number
  description = "Minimum size of EKS Worker ASG"
  default     = 1
}
variable "max_size" {
  type        = number
  description = "Maximum size of EKS Worker ASG"
  default     = 3
}
variable "desired_capacity" {
  type        = number
  description = "Desired size of EKS Worker ASG"
  default     = 1
}
variable "node_instance_type" {
  type        = string
  description = "EC2 Instance size of EKS Workers"
  default     = "m5.large"
}
variable "subnet_name" {
  type        = string
  description = "name identifier of vpc subnets to use for EKS worker deployment"
  default     = "private"
}
variable "k8s_version" {
  type        = string
  description = "EKS Supported version of Kubernetes to operate"
  default     = "1.25"
}

variable "enable_ssm" {
  type        = bool
  description = "enable SSM for Worker Nodes"
  default     = true
}

variable "lt_version" {
  type        = string
  description = "Override for $Latest LT Version"
  default     = null
}
variable "ebs_optimized" {
  type        = bool
  description = "enable EBS optimized volumes"
  default     = true
}

variable "task_iam_policies" {
  type        = any
  default     = {}
  description = "placeholder for passing custom iam policies to EKS nodes"
}

variable "node_ingress_rules" {
  description = "map of security group rules for eks nodes"
  type = map(object({
    from_port    = optional(string)
    to_port      = optional(string)
    protocol     = optional(string)
    type         = optional(string)
    description  = optional(string)
    source_sg_id = optional(string)
    cidr_blocks  = optional(string)
  }))
  default = {}
}