variable "env"                                          {}
variable "k8s_version"                                  {}
variable "vpc_id"                                       {}
variable "ami_id"                                       {}
variable "project"                                      {}
variable "managedBy"                                    {}
variable "key_name"                                     {}
variable "userdata"                                     {}
variable "enabled_cluster_log_types"                    {
                                                          type = list
                                                          default = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
                                                        }
variable "name"                                         {default = "eks"}
variable "min_size"                                     {default = 3}
variable "max_size"                                     {default = 3}
variable "desired_capacity"                             {default = 3}
variable "node_instance_type"                           {default = "m5.large"}
variable "subnet_ids"                                   {type = list}
#variable security_group_ids                            {type ="list"}
variable "local_ip"                                     {
                                                        type = list
                                                        default = ["10.0.0.0/8"]
                                                        }
variable "region"                                       {default = "eu-west-2"}
variable "managed_iam_policy"                           {
                                                        type = list
                                                        default  = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy","arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
                                                        }
variable "endpoint_public_access"                       {default = true}
variable "endpoint_private_access"                      {default = true}
variable "public_access_cidr"                           {default = ["78.136.22.232/32"]}
variable "admin_role_name"                              {}
variable "common_tags"                                  {
                                                        type = map
                                                        default = {}
                                                        }
variable "extra_tags"                                     {
                                                        type = map
                                                        default = {}
                                                        }
//variable "extraRoles"                                     {
//                                                        type = map
//                                                        default = {}
//                                                        }

variable "map_accounts"                                 {
                                                        description = "Additional AWS account numbers to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
                                                        type        = list(string)
                                                        default     = []
                                                        }

variable "map_roles"                                    {
                                                        description = "Additional IAM roles to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
                                                        type = list(object({
                                                          rolearn  = string
                                                          username = string
                                                          groups   = list(string)
                                                        }))
                                                        default = []
                                                        }

variable "map_users"                                    {
                                                        description = "Additional IAM users to add to the aws-auth configmap. See examples/basic/variables.tf for example format."
                                                        type = list(object({
                                                          userarn  = string
                                                          username = string
                                                          groups   = list(string)
                                                        }))
                                                        default = []
                                                        }

variable "wait_for_cluster_cmd"                         {
                                                        description = "Custom local-exec command to execute for determining if the eks cluster is healthy. Cluster endpoint will be available as an environment variable called ENDPOINT"
                                                        type        = string
                                                        default     = "for i in `seq 1 60`; do wget --no-check-certificate -O - -q $ENDPOINT/healthz >/dev/null && exit 0 || true; sleep 5; done; echo TIMEOUT && exit 1"
                                                        }

variable "wait_for_cluster_interpreter"                 {
                                                        description = "Custom local-exec command line interpreter for the command to determining if the eks cluster is healthy."
                                                        type        = list(string)
                                                        default     = ["/bin/sh", "-c"]
                                                        }
variable "eks_bootstrap_options"                        {
                                                        default = null
}