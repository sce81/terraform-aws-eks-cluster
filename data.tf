data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

data "template_file" "userdata" {
  template                      = file("${path.module}/userdata/node-userdata.sh")

    vars = {
      "CLUSTERNAME"                         = aws_eks_cluster.main.id
      "CERTIFICATE"                         = aws_eks_cluster.main.certificate_authority.0.data
      "ENDPOINT"                            = aws_eks_cluster.main.endpoint
      "REGION"                              = data.aws_region.current.name
    }
}


locals {
  common_tags = tomap({
    Name        = "${var.project}-${var.env}-${var.name}"
    Project     = var.project
    Environment = var.env
    Terraform   = "true"
    ManagedBy   = var.managedBy
  })



mapRoles = [
              {
                rolearn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.node.name}"
                username = "system:node:{{EC2PrivateDNSName}}"
                groups   = tolist(concat(["system:bootstrappers","system:nodes"]))
              },
              {
                rolearn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.admin_role_name}"
                username    = "admin"
                groups      = tolist(concat(["system:masters"]))
              }
            ]


}



resource "null_resource" "wait_for_cluster" {

  depends_on = [
    aws_eks_cluster.main,
  ]

  provisioner "local-exec" {
    command     = var.wait_for_cluster_cmd
    interpreter = var.wait_for_cluster_interpreter
    environment = {
      ENDPOINT = aws_eks_cluster.main.endpoint
    }
  }
}