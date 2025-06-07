resource "kubectl_manifest" "jenkins_secret" {
  yaml_body = <<-YAML
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: jenkins-secret
  namespace: jenkins
spec:
  secretStoreRef:
    name: aws-cluster-secretstore
    kind: ClusterSecretStore
  target:
    name: jenkins-secret
  data:
    - secretKey: admin-user
      remoteRef:
        key: app-secrets
        property: JENKINS_ADMIN_USERNAME
    - secretKey: admin-password
      remoteRef:
        key: app-secrets
        property: JENKINS_ADMIN_PASSWORD
  YAML
  depends_on = [
    kubectl_manifest.jenkins-namespace
  ]
}
