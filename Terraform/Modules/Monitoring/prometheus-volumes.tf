data "aws_ebs_volume" "prometheus" {
  filter {
    name   = "tag:Name"
    values = ["prometheus-ebs"]
  }
  most_recent = true
}

resource "kubectl_manifest" "prometheus_ebs_pv" {
  yaml_body  = <<-YAML
apiVersion: v1
kind: PersistentVolume
metadata:
  name: prometheus-ebs-pv
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  awsElasticBlockStore:
    volumeID: ${data.aws_ebs_volume.prometheus.id}
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

resource "kubectl_manifest" "prometheus_ebs_pvc" {
  yaml_body  = <<-YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: prometheus-ebs-pvc
  namespace: monitoring
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 10Gi
  volumeName: prometheus-ebs-pv
YAML
  depends_on = [kubectl_manifest.monitoring_namespace, kubectl_manifest.prometheus_ebs_pv]
}
