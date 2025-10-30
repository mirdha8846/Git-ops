output "argocd_access" {
  value = "ArgoCD server NodePort: http://localhost:32080  (or use port-forward: kubectl port-forward svc/argocd-server -n argocd 8080:443)"
}

output "argocd_initial_password_cmd" {
  value = "kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath='{.data.password}' | base64 --decode"
}
