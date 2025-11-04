# 🚀 GitOps Infrastructure with ArgoCD, Prometheus & Grafana

[![Kubernetes](https://img.shields.io/badge/Kubernetes-326CE5?style=for-the-badge&logo=kubernetes&logoColor=white)](https://kubernetes.io/)
[![ArgoCD](https://img.shields.io/badge/ArgoCD-EF7B4D?style=for-the-badge&logo=argo&logoColor=white)](https://argoproj.github.io/cd/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Prometheus](https://img.shields.io/badge/Prometheus-E6522C?style=for-the-badge&logo=prometheus&logoColor=white)](https://prometheus.io/)
[![Grafana](https://img.shields.io/badge/Grafana-F46800?style=for-the-badge&logo=grafana&logoColor=white)](https://grafana.com/)

A production-grade GitOps implementation using ArgoCD for continuous deployment, Prometheus for monitoring, and Grafana for visualization on a local Kubernetes cluster (KIND).

## 📋 Table of Contents

- [Overview](#overview)
- [Architecture](#architecture)
- [Features](#features)
- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [Project Structure](#project-structure)
- [Infrastructure Components](#infrastructure-components)
- [Monitoring & Observability](#monitoring--observability)
- [ArgoCD Application Sync](#argocd-application-sync)
- [Access URLs](#access-urls)
- [Configuration](#configuration)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)
- [Contributing](#contributing)

## 🎯 Overview

This repository implements a complete GitOps workflow using industry-standard tools and best practices. The infrastructure is fully automated using Terraform, with ArgoCD managing the continuous deployment of applications to Kubernetes. Monitoring is handled by Prometheus with visualization through Grafana dashboards.

### Key Highlights

- **🔄 GitOps Methodology**: Single source of truth for infrastructure and application deployment
- **🤖 Automated Deployment**: ArgoCD automatically syncs applications from Git to Kubernetes
- **📊 Complete Observability**: Real-time monitoring with Prometheus and Grafana
- **🏗️ Infrastructure as Code**: Fully automated cluster provisioning with Terraform
- **🔒 Production-Ready**: Implements security best practices and high availability patterns

## 🏛️ Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                     GitHub Repository                        │
│                    (Source of Truth)                         │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ Git Pull
                     ▼
┌─────────────────────────────────────────────────────────────┐
│                    ArgoCD Controller                         │
│              (Continuous Deployment)                         │
└────────────────────┬────────────────────────────────────────┘
                     │
                     │ Deploy & Sync
                     ▼
┌─────────────────────────────────────────────────────────────┐
│              Kubernetes Cluster (KIND)                       │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐     │
│  │  Application │  │  Prometheus  │  │   Grafana    │     │
│  │   Pods (x2)  │  │   (Metrics)  │  │(Dashboards)  │     │
│  └──────────────┘  └──────────────┘  └──────────────┘     │
│         │                  │                  │             │
│         └──────────────────┴──────────────────┘             │
│                    Monitoring Flow                           │
└─────────────────────────────────────────────────────────────┘
```

### Architecture Diagram

![ArgoCD Application Graph](docs/images/argocd-graph.png)
*ArgoCD application synchronization graph showing deployed resources and their health status*

## ✨ Features

### GitOps & CD
- ✅ Declarative infrastructure management with Terraform
- ✅ Automated application deployment via ArgoCD
- ✅ Self-healing and auto-pruning capabilities
- ✅ Git-based version control for all configurations
- ✅ Automated rollback on deployment failures

### Monitoring & Observability
- ✅ Real-time metrics collection with Prometheus
- ✅ Pre-configured Grafana dashboards
- ✅ Application and cluster health monitoring
- ✅ Custom metrics and alerting support
- ✅ Visual representation of deployment topology

### Infrastructure
- ✅ Multi-node KIND cluster (1 control-plane, 1 worker)
- ✅ Automated cluster provisioning
- ✅ Service mesh ready architecture
- ✅ High availability configuration
- ✅ Easy local development environment

## 📦 Prerequisites

Ensure the following tools are installed on your system:

| Tool | Version | Purpose |
|------|---------|---------|
| [Docker Desktop](https://www.docker.com/products/docker-desktop) | Latest | Container runtime |
| [kubectl](https://kubernetes.io/docs/tasks/tools/) | v1.25+ | Kubernetes CLI |
| [Terraform](https://www.terraform.io/downloads) | v1.5+ | Infrastructure provisioning |
| [Helm](https://helm.sh/docs/intro/install/) | v3.12+ | Kubernetes package manager |
| [KIND](https://kind.sigs.k8s.io/docs/user/quick-start/) | v0.20+ | Local Kubernetes cluster |

### System Requirements

- **OS**: Windows 10/11, macOS, or Linux
- **RAM**: Minimum 8GB (16GB recommended)
- **CPU**: 4+ cores recommended
- **Disk**: 20GB free space

## 🚀 Quick Start

### 1. Clone the Repository

```powershell
git clone https://github.com/mirdha8846/Git-ops.git
cd Git-ops
```

### 2. Initialize Terraform

```powershell
cd Terraform
terraform init
```

### 3. Review Infrastructure Plan

```powershell
terraform plan
```

### 4. Deploy the Infrastructure

```powershell
terraform apply -auto-approve
```

This will:
- ✅ Create a KIND cluster with 2 nodes
- ✅ Install ArgoCD via Helm
- ✅ Deploy the ArgoCD Application CRD
- ✅ Set up monitoring stack (Prometheus & Grafana)

### 5. Verify Deployment

```powershell
# Check cluster status
kubectl cluster-info --context kind-tf-kind-cluster

# Check all pods
kubectl get pods -A

# Check ArgoCD application
kubectl get applications -n argocd
```

### 6. Access Services

Get access to the services using port-forwarding:

```powershell
# ArgoCD UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Grafana Dashboard
kubectl port-forward svc/grafana-service -n default 3000:3000

# Prometheus UI
kubectl port-forward svc/prometheus-svc -n default 9090:9090
```

## 📁 Project Structure

```
git-ops-repo/
├── 🎛️ k8s/                      # Kubernetes Manifests
│   ├── deployment.yaml           # Your app with volume-mounted secrets
│   ├── app-config.yaml           # Non-sensitive configs (Prometheus URL, PORT)
│   ├── app-secret.yaml           # Secrets stored as volume mounts 🔒
│   ├── prometheus-config.yaml    # Metrics scraping config
│   ├── prometheus-deployment.yaml # Prometheus deployment
│   ├── grafana-config.yaml       # Grafana admin user config
│   ├── grafana-deployment.yaml   # Grafana with NodePort access
│   └── gloable-secrets.yaml      # Grafana credentials
│
├── Terraform/                            # Infrastructure as Code
│   ├── provider.tf                       # Provider configurations
│   ├── kind.tf                          # KIND cluster creation
│   ├── argocd.tf                        # ArgoCD Helm installation
│   ├── argocd-apply.tf                  # ArgoCD Application deployment
│   ├── app-application.yaml             # ArgoCD App manifest
│   ├── app-application.yaml.tpl         # Template for ArgoCD App
│   ├── kind-config.yaml                 # KIND cluster configuration
│   └── outputs.tf                       # Terraform outputs
│
├── docs/                                 # Documentation assets
│   └── images/                          # Screenshots and diagrams
│       ├── argocd-graph.png             # ArgoCD topology view
│       ├── grafana-dashboard.png        # Grafana monitoring
│       └── prometheus-metrics.png       # Prometheus metrics
│
└── README.md                            # This file
```

## 🏗️ Infrastructure Components

### 1. KIND Cluster

**Configuration**: Multi-node cluster for production-like environment

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: tf-kind-cluster
nodes:
  - role: control-plane
  - role: worker
```

- **Control Plane Node**: Manages cluster state and API server
- **Worker Node**: Runs application workloads

### 2. Application Deployment

**Image**: `pankajmirdha/testing:0985396a29210c20ae4af311dc3b478637896959`

**Configuration**:
- **Replicas**: 2 (High availability)
- **Port**: 3002
- **Service Type**: ClusterIP
- **Health Checks**: Ready and Live probes configured

### 3. ArgoCD

**Version**: 7.3.8  
**Namespace**: argocd  
**Sync Policy**: Automated with prune and self-heal

**Key Features**:
- 🔄 Automatic sync from Git repository
- 🔧 Self-healing on configuration drift
- 🗑️ Auto-prune of deleted resources
- 📊 Visual topology representation

### ArgoCD Application Synchronization

![alt text](<Screenshot 2025-10-30 195008.png>)
![ArgoCD Graph View](docs/images/argocd-graph.png)
*Real-time view of application health and synchronization status*

The ArgoCD graph shows:
- **Green nodes**: Healthy and synced resources
- **Service connections**: Application networking topology
- **Deployment status**: Current replica count and health
- **Auto-sync status**: Continuous deployment state

## 📊 Monitoring & Observability

### Prometheus Metrics Collection

![Prometheus Metrics](docs/images/prometheus-metrics.png)
*Prometheus collecting and storing time-series metrics*

**Features**:
- 📈 Real-time metrics scraping
- 💾 Time-series data storage
- 🎯 Custom metric queries with PromQL
- 🔔 Alert rule evaluation
- **Access**: http://localhost:9090

**Configuration**:
```yaml
scrape_interval: 15s
scrape_configs:
  - job_name: 'kubernetes-pods'
  - job_name: 'kubernetes-nodes'
  - job_name: 'kubernetes-apiservers'
```

### Grafana Dashboards

![alt text](<Screenshot 2025-10-30 200259.png>)
*Grafana providing rich visualization of Prometheus metrics*

**Default Credentials**:
- **Username**: `admin`
- **Password**: `admin`

**Pre-configured Dashboards**:
- 📊 Cluster Overview
- 🖥️ Node Metrics
- 📦 Pod Performance
- 🌐 Network Traffic
- 💾 Resource Utilization

**Access**: http://localhost:3000

### Setting Up Prometheus Data Source in Grafana

1. Navigate to **Configuration > Data Sources**
2. Add **Prometheus** data source
3. Set URL to: `http://prometheus-svc:9090`
4. Click **Save & Test**

## 🌐 Access URLs

After port-forwarding, access services at:

| Service | URL | Credentials |
|---------|-----|-------------|
| ArgoCD UI | https://localhost:8080 | `admin` / Get from: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" \| base64 --decode` |
| Grafana | http://localhost:3000 | `admin` / `admin` |
| Prometheus | http://localhost:9090 | No authentication |
| Application | http://localhost:3002 | N/A |

### Getting ArgoCD Password

```powershell
# Windows PowerShell
$password = kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}"
[System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($password))
```

## ⚙️ Configuration

### Modifying Application Replicas

Edit `k8s/deployment.yaml`:

```yaml
spec:
  replicas: 3  # Change from 2 to 3
```

Commit and push. ArgoCD will automatically sync within 3 minutes or trigger manual sync.

### Adding New Kubernetes Resources

1. Add manifest to `k8s/` directory
2. Commit and push to repository
3. ArgoCD automatically detects and deploys

### Customizing Prometheus Scrape Configs

Edit `k8s/prometheus-config.yaml` to add new scrape targets:

```yaml
scrape_configs:
  - job_name: 'my-custom-app'
    static_configs:
      - targets: ['my-app-service:8080']
```

## 🔧 Troubleshooting

### Common Issues

#### 1. ArgoCD Application Out of Sync

**Symptom**: Application shows "OutOfSync" status

**Solution**:
```powershell
# Force sync
kubectl patch application demo-app -n argocd --type merge -p '{"operation":{"initiatedBy":{"username":"admin"},"sync":{"revision":"HEAD"}}}'
```

#### 2. Pods Not Starting

**Check pod status**:
```powershell
kubectl get pods -A
kubectl describe pod <pod-name> -n <namespace>
kubectl logs <pod-name> -n <namespace>
```

#### 3. Prometheus Not Scraping Metrics

**Verify targets**:
- Access Prometheus UI: http://localhost:9090/targets
- Check target health status
- Verify service discovery configuration

#### 4. Grafana Cannot Connect to Prometheus

**Solution**:
- Verify Prometheus service: `kubectl get svc prometheus-svc`
- Check data source configuration in Grafana
- Use internal Kubernetes DNS: `http://prometheus-svc:9090`

#### 5. KIND Cluster Not Starting

**Solution**:
```powershell
# Check Docker
docker ps

# Delete and recreate cluster
kind delete cluster --name tf-kind-cluster
terraform apply -auto-approve
```

### Useful Commands

```powershell
# View all resources in namespace
kubectl get all -n <namespace>

# Check ArgoCD sync status
kubectl get applications -n argocd

# View logs from all pods in deployment
kubectl logs -l app=my-app --all-containers=true

# Restart deployment
kubectl rollout restart deployment/app-deployment

# Check cluster events
kubectl get events --sort-by='.lastTimestamp'

# Describe ArgoCD application
kubectl describe application demo-app -n argocd
```

## 🎯 Best Practices

### GitOps Principles

1. **✅ Declarative**: All desired state is declared in Git
2. **✅ Versioned**: Every change is tracked via Git commits
3. **✅ Immutable**: Deployments are reproducible and auditable
4. **✅ Automated**: Changes are automatically applied by ArgoCD
5. **✅ Observable**: Full monitoring and logging in place

### Security Recommendations

- 🔐 Change default passwords immediately in production
- 🔑 Use Kubernetes Secrets for sensitive data
- 🛡️ Enable RBAC for ArgoCD applications
- 🔒 Implement network policies for pod-to-pod communication
- 📜 Regular security audits and updates

### Operational Excellence

- 📊 Set up alerting rules in Prometheus
- 📈 Create custom Grafana dashboards for business metrics
- 🔄 Implement backup strategies for persistent data
- 📝 Document all custom configurations
- 🧪 Test changes in staging before production

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Development Workflow

1. Make changes to manifests in `k8s/` directory
2. Test locally by committing to a feature branch
3. Point ArgoCD to your branch for testing
4. Merge to `main` after validation

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📧 Contact & Support

- **Repository**: [https://github.com/mirdha8846/Git-ops](https://github.com/mirdha8846/Git-ops)
- **Issues**: [GitHub Issues](https://github.com/mirdha8846/Git-ops/issues)

## 🙏 Acknowledgments

- [ArgoCD Community](https://argoproj.github.io/)
- [Prometheus Project](https://prometheus.io/)
- [Grafana Labs](https://grafana.com/)
- [Kubernetes SIG](https://kubernetes.io/)
- [KIND Project](https://kind.sigs.k8s.io/)

---

<div align="center">

**⭐ Star this repository if you find it helpful!**

Made with ❤️ by [mirdha8846](https://github.com/mirdha8846)

</div>
