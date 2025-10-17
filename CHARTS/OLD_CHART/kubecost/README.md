# Kubecost Deployment

## Overview

This repository provides the configuration and manifests required to deploy a **production-grade Kubecost instance** using Helm. Kubecost enables real-time cost monitoring, resource optimization, and budgeting within your Kubernetes environment.

The deployment is designed to be:

- **Scalable** with horizontal auto-scaling and multiple replicas
- **Secure** with RBAC, NetworkPolicies, and optional TLS
- **Integrated** with Prometheus and Grafana for cost visualization and alerting
- **Customizable** via Helm overrides and cost allocation rules

---

## Directory Structure

```bash
kubecost-deployment/
├── cost-analyzer/                    # Optional: Helm chart directory or submodule
├── values/
│   ├── kubecost-override.yaml       # Primary Helm override values
│   └── values-eks-cost-monitoring.yaml # Example: EKS-specific configuration
├── manifests/
│   ├── prometheusrule-kubecost.yaml # PrometheusRule for alerting on cost anomalies
│   ├── ingress-kubecost.yaml        # Optional: Ingress with TLS for UI
│   └── grafana-dashboards/
│       └── kubecost-dashboard.json  # Dashboard to import into Grafana
├── README.md
```
                    
## Prerequisites

- Kubernetes cluster (v1.21+ recommended)
- Helm 3.x
- Prometheus installed (or use bundled one)
- Grafana instance (optional if using bundled)
- Persistent storage class (e.g., `standard-rwo`)

## Installation

### Add Helm Repo (if not using local chart)

```bash
helm repo add kubecost https://kubecost.github.io/cost-analyzer/
helm repo update
```

### Deploy with Overrides

```bash
helm upgrade --install kubecost kubecost/cost-analyzer \
  --namespace kubecost --create-namespace \
  -f values/kubecost-override.yaml
  ```

## Post-Deployment

### Access Kubecost UI

#### If using Ingress:

https://kubecost.internal.wft.com # use the actual domain

#### If using `kubectl port-forward`:

```bash
kubectl port-forward svc/kubecost-cost-analyzer -n kubecost 9090:9090
```

### Import Grafana Dashboard
Open Grafana
Go to Dashboards > Import
Upload grafana-dashboards/kubecost-dashboard.json

### Cost Alerting
The file manifests/prometheusrule-kubecost.yaml contains rules for cost anomaly alerts.

Apply it: 
```bash
kubectl apply -f manifests/prometheusrule-kubecost.yaml
```

Ensure your Prometheus instance is watching the namespace where the rule is applied.

### Configuration Notes
The deployment uses:

2 replicas for core components (kubecostModel, kubecostFrontend)

Horizontal Pod Autoscaling

50Gi persistent volume for long-term data

Custom internal pricing for CPU and RAM

Namespace-based cost allocation

Grafana and Prometheus can be bundled or external; see values/kubecost-override.yaml.

### Security Considerations
NetworkPolicies are enabled to restrict communication

TLS via Ingress is recommended in production

RBAC and service accounts are configured by default
