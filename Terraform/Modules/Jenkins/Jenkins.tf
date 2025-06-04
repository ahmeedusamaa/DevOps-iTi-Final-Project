resource "kubectl_manifest" "jenkins-namespace" {
  yaml_body = <<-YAML
apiVersion: v1
kind: Namespace
metadata:
  name: jenkins
YAML
}

resource "helm_release" "jenkins" {
  name             = "jenkins"
  namespace        = "jenkins"
  create_namespace = false

  repository = "https://charts.jenkins.io"
  chart      = "jenkins"
  version    = "5.1.15"

  values = [
    templatefile("${path.module}/Values/jenkins-values.yaml", {
      jenkins_host = var.ingress_hosts["jenkins"]
    })
  ]

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = var.jenkins_irsa_role_arn
  }


  depends_on = [kubectl_manifest.jenkins-namespace,
  kubectl_manifest.jenkins-ebs-pv, kubectl_manifest.jenkins-ebs-pvc, kubectl_manifest.jenkins_secret]
}
