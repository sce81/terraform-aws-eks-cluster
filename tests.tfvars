env_name           = "terraform"
name               = "test-eks"
instance_type      = "t3.micro"
vpc_name           = "demo-public-vpc"
subnet_name        = "private"
min_size           = 1
max_size           = 3
desired_capacity   = 1
node_instance_type = "m5.large"
k8s_version        = "1.28"
enable_ssm         = true
key_name = "test"
#vpc_cidr           = "10.0.0.0/16"
#subnet_ids         = ["subnet-0c2a66fd6e03e4789"]
#user_data          = "echo 'Hello, world!'"
#instance_profile   = "test"
#security_group_ids = ["sg-0bc80596b878aea86"]


# doormat aws tf-push private-module-test --module-name ec2-instance --organization HashiCorp_TFC_Automation_Demo
