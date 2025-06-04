resource "kubectl_manifest" "kaniko_serviceaccount" {
  yaml_body  = <<-YAML
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: kaniko-serviceaccount
      namespace: jenkins
      annotations:
        eks.amazonaws.com/role-arn: "${var.kaniko_irsa_role_arn}"
  YAML
  depends_on = [var.kaniko_irsa_role, helm_release.jenkins]
}


resource "aws_iam_role_policy_attachment" "kaniko_ecr_access" {
  role       = var.kaniko_irsa_role_name
  policy_arn = var.kaniko_ecr_policy_arn
}

