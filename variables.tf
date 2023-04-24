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
  default     = "1.26"
}
