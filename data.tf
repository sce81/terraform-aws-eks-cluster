data "template_file" "userdata" {
  template                      = file("${path.module}/userdata/node-userdata.sh")

  vars = {
      ClusterName               = "${var.env}-${var.name}"
      ClusterCA                 = aws_eks_cluster.main.certificate_authority.0.data
      ClusterAPIEndpoint        = aws_eks_cluster.main.endpoint
  }
}