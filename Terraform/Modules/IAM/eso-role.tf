resource "aws_iam_policy" "eso_policy" {
  name = "ESOSecretsAccesssPolicy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecrets",
          "secretsmanager:GetResourcePolicy",
          "kms:Decrypt"
        ],
        "Resource" : "*"
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt"
        ],
        "Resource" : "*"
      }
    ]
    }
  )
}

resource "aws_iam_role" "eso_irsa" {
  name = "external-secrets-irsaa"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = var.oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "${replace(var.oidc_issuer, "https://", "")}:sub" = "system:serviceaccount:external-secrets:external-secrets-sa",
            "${replace(var.oidc_issuer, "https://", "")}:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

}

resource "aws_iam_role_policy_attachment" "eso_attach" {
  role       = aws_iam_role.eso_irsa.name
  policy_arn = aws_iam_policy.eso_policy.arn
}

