resource "aws_iam_policy" "kaniko_ecr_policy" {
  name        = "KanikoECRPolicy"
  description = "Policy for Kaniko to push images to ECR"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:CompleteLayerUpload",
          "ecr:GetDownloadUrlForLayer",
          "ecr:InitiateLayerUpload",
          "ecr:PutImage",
          "ecr:UploadLayerPart"
        ]
        Resource = "*"
      }
    ]
  })
}

# Create IAM role for IRSA (assume by service account)
resource "aws_iam_role" "kaniko_irsa_role" {
  name = "KanikoECRRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = var.oidc_provider_arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "${replace(var.oidc_issuer, "https://", "")}:sub" = "system:serviceaccount:jenkins:kaniko-serviceaccount"
          }
        }
      }
    ]
  })
}

