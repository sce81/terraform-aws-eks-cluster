variable env                        {}
variable k8s_version                {}
variable vpc_id                     {}
variable key_name                   {}
variable name                       {default = "eks"}
variable min_size                   {default = 3}
variable max_size                   {default = 3}
variable desired_capacity           {default = 3}
variable node_instance_type         {default = "m5.large"}
variable subnet_ids                 {type = list}
#variable security_group_ids         {type ="list"}
variable local_ip                   {default = "10.0.0.0/8"}
variable region                     {default = "eu-west-2"}
variable managed_iam_policy         {
                                    type = list
                                    default  = ["arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy","arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"]
                                    }
variable endpoint_public_access     {default = false}
variable endpoint_private_access    {default = true}