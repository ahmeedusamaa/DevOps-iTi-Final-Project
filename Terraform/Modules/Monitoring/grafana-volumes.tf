data "aws_ebs_volume" "grafana" {
  filter {
    name   = "tag:Name"
    values = ["grafana-ebs"]
  }
  most_recent = true
}

resource "kubectl_manifest" "grafana_ebs_pv" {
  yaml_body  = <<-YAML
apiVersion: v1
kind: PersistentVolume
metadata:
  name: grafana-ebs-pv
spec:
  capacity:
    storage: 5Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  awsElasticBlockStore:
    volumeID: ${data.aws_ebs_volume.grafana.id}
    fsType: ext4
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: topology.kubernetes.io/zone
              operator: In
              values:
                - us-east-1b
YAML
  depends_on = [kubectl_manifest.monitoring_namespace]
}

resource "kubectl_manifest" "grafana_ebs_pvc" {
  yaml_body  = <<-YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: grafana-ebs-pvc
  namespace: monitoring
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 5Gi
  volumeName: grafana-ebs-pv
YAML
  depends_on = [kubectl_manifest.grafana_ebs_pv, kubectl_manifest.monitoring_namespace]
}
