resource "kubectl_manifest" "cluster_secretstore" {
  yaml_body  = <<-YAML
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: aws-cluster-secretstore
spec:
  provider:
    aws:
      service: SecretsManager
      region: ${var.region}
      auth:
        jwt:
          serviceAccountRef:
            name: external-secrets-sa
            namespace: external-secrets
YAML
  depends_on = [helm_release.external_secrets]
}
