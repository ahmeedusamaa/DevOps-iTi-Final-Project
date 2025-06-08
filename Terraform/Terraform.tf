terraform {
  required_version = ">= 1.0"

  backend "s3" {
    bucket       = "zaboyzz-terraform-state"
    key          = "terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.95.0"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "1.19.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.0"
    }
  }
}

resource "null_resource" "wait_for_k8s_ready" {
  provisioner "local-exec" {
    command     = <<EOT
      for i in {1..30}; do
        echo "Checking if cluster is ready..."
        kubectl get nodes && exit 0 || sleep 10
      done
      echo "Cluster is not ready after waiting, exiting..."
      exit 1
    EOT
    interpreter = ["/bin/bash", "-c"]
  }

  depends_on = [module.EKS, module.NodeGroup]
}
