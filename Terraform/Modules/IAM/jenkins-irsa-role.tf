resource "aws_iam_role" "jenkins_irsa" {
  name = "jenkins-irsa-role"

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
          "${replace(var.oidc_issuer, "https://", "")}:sub" = "system:serviceaccount:jenkins:jenkins"
        }
      }
    }]
  })
}

resource "aws_iam_policy" "secrets_manager_read" {
  name = "SecretsManagerReadOnlyForJenkins"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "jenkins_attach_policy" {
  role       = aws_iam_role.jenkins_irsa.name
  policy_arn = aws_iam_policy.secrets_manager_read.arn
}

resource "aws_iam_role_policy_attachment" "jenkins_ecr_access" {
  role       = aws_iam_role.jenkins_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess"
}
