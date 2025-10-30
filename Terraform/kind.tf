resource "null_resource" "create_kind" {
  provisioner "local-exec" {
    interpreter = ["PowerShell", "-Command"]
    command = <<EOT
$ErrorActionPreference = 'Continue'

# Check if Docker is running
Write-Host "Checking if Docker is running..."
$dockerRunning = docker ps 2>$null
if ($LASTEXITCODE -ne 0) {
  Write-Host "ERROR: Docker is not running. Please start Docker Desktop and try again."
  exit 1
}
Write-Host "Docker is running."

# Create kind config file
@"
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: tf-kind-cluster
nodes:
  - role: control-plane
  - role: worker
"@ | Out-File -FilePath kind-config.yaml -Encoding UTF8

# Check if cluster exists
Write-Host "Checking for existing kind cluster..."
$clusters = kind get clusters 2>$null
$clusterExists = $clusters | Where-Object { $_ -eq 'tf-kind-cluster' }

if (-not $clusterExists) {
  Write-Host "Creating kind cluster tf-kind-cluster..."
  kind create cluster --name tf-kind-cluster --config kind-config.yaml
  if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Failed to create kind cluster"
    exit 1
  }
} else {
  Write-Host "kind cluster tf-kind-cluster already exists"
}

# Ensure kubectl context is set
Write-Host "Setting kubectl context..."
kubectl config use-context kind-tf-kind-cluster
if ($LASTEXITCODE -ne 0) {
  Write-Host "Warning: Could not set kubectl context"
}

# Wait for nodes ready
Write-Host "Waiting for nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=120s
if ($LASTEXITCODE -ne 0) {
  Write-Host "ERROR: Nodes did not become ready in time"
  exit 1
}

Write-Host "Kind cluster is ready!"
EOT
  }
}
