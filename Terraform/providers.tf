provider "aws" {
  region = local.region
}

provider "kubectl" {
  host                   = module.EKS.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.EKS.eks_cluster_certificate_authority_data)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.EKS.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.EKS.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.EKS.eks_cluster_certificate_authority_data)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.EKS.cluster_name]
    }
  }
}
