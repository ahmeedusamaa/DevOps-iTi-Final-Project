data "aws_ebs_volume" "jenkins" {
  filter {
    name   = "tag:Name"
    values = ["jenkins-ebs"]
  }
  most_recent = true
}

resource "kubectl_manifest" "jenkins-ebs-pv" {
  yaml_body  = <<-YAML
apiVersion: v1
kind: PersistentVolume
metadata:
  name: jenkins-ebs-pv
spec:
  capacity:
    storage: 10Gi
  volumeMode: Filesystem
  accessModes:
    - ReadWriteOnce
  persistentVolumeReclaimPolicy: Retain
  storageClassName: manual
  awsElasticBlockStore:
    volumeID: ${data.aws_ebs_volume.jenkins.id}
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
  depends_on = [kubectl_manifest.jenkins-namespace]
}


resource "kubectl_manifest" "jenkins-ebs-pvc" {
  yaml_body  = <<-YAML
# jenkins-ebs-pvc.yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: jenkins-ebs-pvc
  namespace: jenkins
spec:
  accessModes:
    - ReadWriteOnce
  storageClassName: manual
  resources:
    requests:
      storage: 10Gi
  volumeName: jenkins-ebs-pv
YAML
  depends_on = [kubectl_manifest.jenkins-ebs-pv, kubectl_manifest.jenkins-namespace]
}
