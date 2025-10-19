# Loki Helm Chart

This repository contains a Helm chart to deploy a **production-grade Loki** instance with S3-backed storage for long-term log retention.

---

## Overview

- Uses the official `grafana/loki` Docker image.
- Supports S3-compatible object storage (AWS S3, MinIO, etc.).
- Includes high availability setup with StatefulSet.
- PersistentVolumeClaims for durable storage.
- Horizontal Pod Autoscaler (HPA) and Pod Disruption Budget (PDB) included.
- Supports environment-specific overrides (`dev-values.yaml`, `test-values.yaml`, `prod-values.yaml`).
- Kubernetes secret for S3 credentials is managed separately.
- Easy installation via included install script.

---

## Prerequisites

- Kubernetes cluster (v1.20+ recommended).
- Helm 3.x installed.
- Access to an S3-compatible storage with bucket and credentials.
- `kubectl` configured to access your cluster.

---

## Installation

1. **Create Namespace & Secret**


kubectl create namespace loki --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -f manifests/loki-s3-secret.yaml

Install Loki Helm Chart

Use the install script to deploy with production values:


chmod +x scripts/install-loki.sh
./scripts/install-loki.sh
Or install manually with Helm:


helm upgrade --install loki ./loki -f loki/prod-values.yaml -n loki
Usage
Access Loki’s API via port-forward or ingress.

Query logs using Grafana (add Loki as a datasource).

Adjust resource requests and replica counts per environment.

Customize retention policies and storage backend in values files.

Development & Testing
Use dev-values.yaml for local or development environment.

Use test-values.yaml for testing with moderate resources.

Use prod-values.yaml for production deployment.

Cleanup
To uninstall Loki:

helm uninstall loki -n loki
kubectl delete namespace loki

Troubleshooting
Check pod logs with kubectl logs -n loki -l app=loki.

Ensure PVCs are properly bound and storage class supports your environment.

Verify the secret exists and has correct AWS credentials.

Check Helm release status: helm status loki -n loki.

License
MIT License.



Folder Structure: loki/

loki/
├── Chart.yaml
├── values.yaml
├── dev-values.yaml
├── test-values.yaml
├── prod-values.yaml
├── templates/
│   ├── _helpers.tpl
│   ├── NOTES.txt
│   ├── configmap.yaml
│   ├── deployment.yaml (or statefulset.yaml)
│   ├── hpa.yaml
│   ├── ingress.yaml
│   ├── pdb.yaml
│   ├── pvc.yaml
│   ├── role.yaml
│   ├── rolebinding.yaml
│   ├── service.yaml
│   ├── serviceaccount.yaml
│   └── networkpolicy.yaml
manifests/
└── loki-s3-secret.yaml
scripts/
└── install-loki.sh
README.md