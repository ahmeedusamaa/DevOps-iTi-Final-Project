data "aws_ebs_volume" "sonar" {
  most_recent = true
  filter {
    name   = "tag:Name"
    values = ["sonar-ebs"]
  }

}

data "aws_ebs_volume" "sonar_postgresql" {
  most_recent = true
  filter {
    name   = "tag:Name"
    values = ["sonar-postgresql-ebs"]
  }

}

resource "kubectl_manifest" "sonar_pv" {
  yaml_body  = <<-YAML
apiVersion: v1
kind: PersistentVolume
metadata:
  name: sonar-pv
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  awsElasticBlockStore:
    volumeID: ${data.aws_ebs_volume.sonar.id}
    fsType: ext4
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: topology.kubernetes.io/zone
              operator: In
              values:
                - us-east-1a
YAML
  depends_on = [kubectl_manifest.sonarqube-namespace]
}

resource "kubectl_manifest" "sonar_pvc" {
  yaml_body  = <<-YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: sonar-pvc
  namespace: sonarqube
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 10Gi
  volumeName: sonar-pv
YAML
  depends_on = [kubectl_manifest.sonarqube-namespace, kubectl_manifest.sonar_pv]
}

resource "kubectl_manifest" "sonar_postgresql_pv" {
  yaml_body  = <<-YAML
apiVersion: v1
kind: PersistentVolume
metadata:
  name: sonar-postgresql-pv
spec:
  capacity:
    storage: 20Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  awsElasticBlockStore:
    volumeID: ${data.aws_ebs_volume.sonar_postgresql.id}
    fsType: ext4
  nodeAffinity:
    required:
      nodeSelectorTerms:
        - matchExpressions:
            - key: topology.kubernetes.io/zone
              operator: In
              values:
                - us-east-1a

YAML
  depends_on = [kubectl_manifest.sonarqube-namespace, ]
}

resource "kubectl_manifest" "sonar_postgresql_pvc" {
  yaml_body  = <<-YAML
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: sonar-postgresql-pvc
  namespace: sonarqube
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 20Gi
  volumeName: sonar-postgresql-pv
YAML
  depends_on = [kubectl_manifest.sonarqube-namespace, kubectl_manifest.sonar_postgresql_pv]
}
