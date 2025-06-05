resource "kubectl_manifest" "letsencrypt_issuer" {
  yaml_body = <<-EOF
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: letsencrypt
    spec:
      acme:
        email: ${var.email}
        server: https://acme-v02.api.letsencrypt.org/directory
        privateKeySecretRef:
          name: letsencrypt
        solvers:
          - http01:
              ingress:
                class: nginx
  EOF

  depends_on = [helm_release.cert_manager]
}
