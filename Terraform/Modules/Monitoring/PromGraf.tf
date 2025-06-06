resource "kubectl_manifest" "monitoring_namespace" {
  yaml_body = <<-YAML
apiVersion: v1
kind: Namespace
metadata:
  name: monitoring
YAML
}


resource "helm_release" "prom_graf" {
  name       = "prom-graf"
  namespace  = "monitoring"
  repository = "https://prometheus-community.github.io/helm-charts"
  chart      = "kube-prometheus-stack"


  values = [
    templatefile("${path.module}/Values/monitoring-values.yaml", {
      grafana_host    = var.ingress_hosts["grafana"]
      prometheus_host = var.ingress_hosts["prometheus"]
    })
  ]
  depends_on = [kubectl_manifest.monitoring_namespace, kubectl_manifest.grafana_ebs_pvc, kubectl_manifest.prometheus_ebs_pvc,
  kubectl_manifest.grafana_secret]

}
