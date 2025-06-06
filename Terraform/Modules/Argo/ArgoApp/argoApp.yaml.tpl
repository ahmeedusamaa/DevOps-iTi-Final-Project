apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: 3-tier-app
  namespace: argocd
  annotations:
    argocd-image-updater.argoproj.io/image-list: frontend=${account_id}.dkr.ecr.${region}.amazonaws.com/${frontend_repo}:1.0.x, backend=${account_id}.dkr.ecr.${region}.amazonaws.com/${backend_repo}:1.0.x

    argocd-image-updater.argoproj.io/frontend.update-strategy: semver
    argocd-image-updater.argoproj.io/frontend.helm.image-name: frontend-chart.image.repository
    argocd-image-updater.argoproj.io/frontend.helm.image-tag: frontend-chart.image.tag

    argocd-image-updater.argoproj.io/backend.update-strategy: semver
    argocd-image-updater.argoproj.io/backend.helm.image-name: backend-chart.image.repository
    argocd-image-updater.argoproj.io/backend.helm.image-tag: backend-chart.image.tag

    argocd-image-updater.argoproj.io/write-back-method: git:secret:argocd/github-credentials
    argocd-image-updater.argoproj.io/git-branch: master
  finalizers:
    - resources-finalizer.argocd.argoproj.io
   
spec:
  project: default
  destination:
    server: https://kubernetes.default.svc
    namespace: default
  source: 
    repoURL: ${App_Chart_Repo}
    targetRevision: master
    path: K8sManifests/app-of-apps-chart
    helm:
      valueFiles:
        - values.yaml
  syncPolicy:
    automated:
      allowEmpty: true
      prune: true
      selfHeal: true
    syncOptions:
      - CreateNamespace=false
      - Validate=true
      - PrunePropagationPolicy=foreground
      - PruneLast=true