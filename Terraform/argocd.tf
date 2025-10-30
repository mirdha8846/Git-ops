# Add Helm repository for ArgoCD
resource "null_resource" "add_argocd_helm_repo" {
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
helm repo add argo https://argoproj.github.io/argo-helm 2>$null
helm repo update
EOT
  }

  depends_on = [null_resource.create_kind]
}

resource "helm_release" "argocd" {
  name             = "argocd"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argo-cd"
  namespace        = "argocd"
  create_namespace = true
  version          = "7.3.8"  # (or latest stable version)
  timeout          = 600

  values = [<<EOF
server:
  service:
    type: ClusterIP       # Default, suitable for Kind
  containerPort: 8080     # Expose port explicitly
EOF
  ]

  depends_on = [null_resource.add_argocd_helm_repo]
}
