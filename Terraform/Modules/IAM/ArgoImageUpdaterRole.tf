resource "aws_iam_policy" "argo_ECR_Access" {
  name = "ArgoImageUpdaterECRAccessPolicy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "ecr:DescribeImages",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetAuthorizationToken",
          "ecr:ListImages"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_role" "argoiu_irsa" {
  name = "argoiu-irsa-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect = "Allow",
      Principal = {
        Federated = var.oidc_provider_arn
      },
      Action = "sts:AssumeRoleWithWebIdentity",
      Condition = {
        StringEquals = {
          "${replace(var.oidc_issuer, "https://", "")}:sub" = "system:serviceaccount:argocd:imageupdater-sa"
        }
      }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "argo_attach_policy" {
  role       = aws_iam_role.argoiu_irsa.name
  policy_arn = aws_iam_policy.argo_ECR_Access.arn
}


resource "aws_iam_role_policy_attachment" "argo_attach_policy_ECR_Access" {
  role       = aws_iam_role.argoiu_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

