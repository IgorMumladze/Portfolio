resource "helm_release" "argocd" {
  name             = "argocd"
  namespace        = "argocd"
  create_namespace = true
  wait             = true

  chart      = var.chart_path
  
  values = [
    "${file(var.values_path)}"
  ]
}

resource "kubectl_manifest" "main_cd" {
  depends_on = [helm_release.argocd, kubernetes_secret.gitops_repo_cred, kubernetes_secret.foodist_secret]

  yaml_body = file(var.main_cd_path)
}