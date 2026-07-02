
# WARNING: Generated module tests should be considered experimental and be reviewed by the module author.



run "variables_validation" {
  assert {
    condition     = var.env_name == "test"
    error_message = "var.env_name should be 'test'"
  }

  assert {
    condition     = var.vpc_name == "test"
    error_message = "var.vpc_name should be 'test'"
  }

  assert {
    condition     = var.name == "test"
    error_message = "var.name should be 'test'"
  }

  assert {
    condition     = var.key_name == "test"
    error_message = "var.key_name should be 'test'"
  }

  assert {
    condition     = var.min_size == 1
    error_message = "var.min_size should be 1"
  }

  assert {
    condition     = var.max_size == 3
    error_message = "var.max_size should be 3"
  }

  assert {
    condition     = var.desired_capacity == 1
    error_message = "var.desired_capacity should be 1"
  }

  assert {
    condition     = var.node_instance_type == "m5.large"
    error_message = "var.node_instance_type should be 'm5.large'"
  }

  assert {
    condition     = var.subnet_name == "private"
    error_message = "var.subnet_name should be 'private'"
  }

  assert {
    condition     = var.k8s_version == "1.25"
    error_message = "var.k8s_version should be '1.25'"
  }

  assert {
    condition     = var.enable_ssm == true
    error_message = "var.enable_ssm should be true"
  }

  assert {
    condition     = var.lt_version == null
    error_message = "var.lt_version should be null"
  }

  assert {
    condition     = var.ebs_optimized == true
    error_message = "var.ebs_optimized should be true"
  }

  assert {
    condition     = var.dynamic_iam_policies == {}
    error_message = "var.dynamic_iam_policies should be {}"
  }

  assert {
    condition     = var.node_ingress_rules == {}
    error_message = "var.node_ingress_rules should be {}"
  }
}