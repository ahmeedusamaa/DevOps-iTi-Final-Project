resource "kubectl_manifest" "sonarqube-namespace" {
  yaml_body = <<-YAML
apiVersion: v1
kind: Namespace
metadata:
  name: sonarqube
YAML
}


resource "helm_release" "sonarqube" {
  name      = "sonarqube"
  namespace = "sonarqube"

  repository = "https://SonarSource.github.io/helm-chart-sonarqube"
  chart      = "sonarqube"
  version    = "2025.3.0"

  values = [
    templatefile("${path.module}/Values/sonarqube-values.yaml", {
      domain_name = var.ingress_hosts["sonarqube"]
    })
  ]

  set {
    name  = "edition"
    value = "developer"
  }

  set {
    name  = "monitoringPasscode"
    value = "yourPasscode"
  }

  set {
    name  = "postgresql.persistence.enabled"
    value = "true"
  }

  set {
    name  = "postgresql.persistence.size"
    value = "20Gi"
  }

  set {
    name  = "postgresql.persistence.accessMode"
    value = "ReadWriteOnce"
  }

  set {
    name  = "postgresql.persistence.storageClass"
    value = "gp2"
  }

  depends_on = [kubectl_manifest.sonarqube-namespace, kubectl_manifest.sonar_pv,
  kubectl_manifest.sonar_pvc, kubectl_manifest.sonar_postgresql_pv, kubectl_manifest.sonar_postgresql_pvc]
}
