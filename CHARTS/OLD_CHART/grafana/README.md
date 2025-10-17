## Grafana Helm Chart

This Helm chart deploys a **production-grade Grafana instance** on Kubernetes with high availability, external MySQL, TLS ingress, persistent storage, and integration with Prometheus, Loki, and Alertmanager.

---

###  Features

-  **TLS-secured** access via NGINX Ingress
-  **RBAC** and custom service accounts
-  **Persistent dashboards & datasources**
-  **Preconfigured datasources**: Prometheus, Loki, Alertmanager
-  **External MySQL** used as Grafana data source
-  **HPA-ready** with defined resource limits
-  Dev/Prod ready using Helm overrides
-  Works on **Minikube**, GKE, EKS, etc.

---

###  Prerequisites

- Kubernetes cluster (e.g., Minikube, GKE, EKS)
- Helm v3+
- External MySQL instance with:
  - Database created
  - User with access
  - Secret in Kubernetes (`grafana-mysql-secret`)
- TLS secret for Ingress (`grafana-tls`)
- Secrets:
  - `grafana-admin-secret` — contains admin password
  - `grafana-mysql-secret` — contains MySQL credentials

---

### Installation

```bash
helm upgrade --install grafana ./helm-charts/grafana \
  -n monitoring --create-namespace \
  -f helm-charts/grafana/values.yaml \
  -f helm-charts/grafana/prod-values.yaml
```

 For development environments, replace `prod-values.yaml` with `dev-values.yaml`.

---

### Ingress Access

-  HTTPS access:
  ```
  https://grafana.192.168.49.2.nip.io
  ```
- If using Minikube, make sure `minikube tunnel` is running

---

###  Helm Values Overview

#### `values.yaml` (base config)
- Defines common/shared settings across all environments
- Includes storage, resource templates, service definitions, RBAC scaffolding

#### `dev-values.yaml` (development overrides)
- Uses minimal resources (1 pod)
- Smaller persistent storage
- Simpler or test secrets
- Lower traffic load expected

#### `prod-values.yaml` (production overrides)
- Enables high availability (2+ replicas)
- Sets stronger resource requests & limits
- Uses secure secrets (existing Kubernetes Secret references)
- Enables TLS with `grafana-tls`

---

###  File Structure

```
grafana/
├── Chart.yaml
├── values.yaml
├── dev-values.yaml
├── prod-values.yaml
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── pvc.yaml
│   └── _helpers.tpl
└── README.md
```

---

###  Preconfigured Datasources

- Prometheus
- Loki
- Alertmanager  
Configured via `datasources.yaml`

---

###  Dashboards

- Loaded using `dashboardproviders.yaml`
- Mount your custom JSON files in:
  ```
  /var/lib/grafana/dashboards/
  ```

---

###  Customize

To modify for your environment, edit:
- `values.yaml` — for base settings
- `dev-values.yaml` — for development/testing
- `prod-values.yaml` — for production setup
