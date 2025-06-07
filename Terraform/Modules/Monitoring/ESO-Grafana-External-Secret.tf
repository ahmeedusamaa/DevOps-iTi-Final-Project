resource "kubectl_manifest" "grafana_secret" {
  yaml_body = <<-YAML
    apiVersion: external-secrets.io/v1beta1
    kind: ExternalSecret
    metadata:
      name: grafana-secrets
      namespace: monitoring
    spec:
      secretStoreRef:
        name: aws-cluster-secretstore
        kind: ClusterSecretStore
      target:
        name: grafana-secret
      data:
        - secretKey: admin-user
          remoteRef:
            key: app-secrets
            property: GRAFANA_ADMIN_USER
        - secretKey: admin-password
          remoteRef:
            key: app-secrets
            property: GRAFANA_ADMIN_PASSWORD

  YAML
  depends_on = [
    kubectl_manifest.monitoring_namespace
  ]
}

