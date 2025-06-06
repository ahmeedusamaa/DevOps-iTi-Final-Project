resource "kubectl_manifest" "argocd_namespace" {
  yaml_body = <<-YAML
    apiVersion: v1
    kind: Namespace
    metadata:
      name: argocd
      labels:
        name: argocd
  YAML

}

resource "helm_release" "ArgoCD" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = false

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "8.0.13"

  values = [
    templatefile("${path.module}/Values/argo-values.yaml", {
      argo_host = var.ingress_hosts["argocd"]
    })
  ]
  depends_on = [kubectl_manifest.argocd_namespace]

}

resource "helm_release" "argo_image_updater" {
  name             = "argocd-image-updater"
  namespace        = "argocd"
  create_namespace = false
  depends_on       = [helm_release.ArgoCD]

  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"
  version    = "0.12.2"

  values = [
    templatefile("${path.module}/Values/argo-image-updater-values.yaml", {
      irsa_role_arn = var.argou_irsa_role_arn
      region        = var.region
      AccountID     = var.Account_ID
    })
  ]

}
