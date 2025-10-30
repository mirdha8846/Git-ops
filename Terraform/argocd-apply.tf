resource "null_resource" "create_argocd_application" {
  depends_on = [helm_release.argocd, null_resource.create_kind]

  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
$ErrorActionPreference = 'Stop'

# Wait for argocd server deployment to be ready
Write-Host "Waiting for ArgoCD server deployment to be ready..."
kubectl -n argocd rollout status deployment/argocd-server --timeout=180s

# Copy the template file to the final application file
if (Test-Path app-application.yaml.tpl) {
  Copy-Item -Path app-application.yaml.tpl -Destination app-application.yaml -Force
  Write-Host "Created app-application.yaml from template"
} else {
  Write-Host "Warning: app-application.yaml.tpl not found"
}

# Apply the Application manifest
Write-Host "Applying ArgoCD application..."
kubectl apply -f app-application.yaml
EOT
  }
}
