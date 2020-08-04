data "aws_eks_cluster" "cluster" {
  name = element(concat(aws_eks_cluster.main.*.id, list("")), 0)
}

data "aws_eks_cluster_auth" "cluster" {
  name = element(concat(aws_eks_cluster.main.*.id, list("")), 0)
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}


resource "kubernetes_config_map" "aws_auth" {
  depends_on = [null_resource.wait_for_cluster]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(
      distinct(concat(
        local.mapRoles
      ))
    )
   // mapUsers    = yamlencode(var.map_users)
   // mapAccounts = yamlencode(var.map_accounts)
  }

}