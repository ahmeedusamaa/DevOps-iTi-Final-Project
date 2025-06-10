data "external" "thumbprint" {
  program = ["${path.module}/Scripts/get-thumbprint.sh", var.oidc_provider_url]
}


resource "aws_iam_openid_connect_provider" "oidc" {
  url             = var.oidc_provider_url
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.external.thumbprint.result.thumbprint]

  tags = {
    Name = "${var.prefix}-${var.eks_name}-OIDC"
  }
}

