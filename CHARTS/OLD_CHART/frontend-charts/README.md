# connect-frontend Helm Chart

This repository contains the Helm chart for deploying the **connect-frontend** application on Kubernetes.

---

## Key features

- Scalable, configurable frontend deployment
- Supports multiple environments: **dev** and **prod**
- Uses:
  - `ConfigMap` to inject environment variables
  - `Secret` (named `connect-frontend`) managed externally
  - Readiness and liveness probes
  - Autoscaling (HPA)
  - NetworkPolicy
  - PodDisruptionBudget
  - Configurable Ingress (Nginx) with TLS

---

## Chart structure

```bash
frontend-charts/
├── charts/
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── ...
├── values.yaml                # Default values
├── values-dev.yaml            # Overrides for development
└── values-prod.yaml           # Overrides for production


Important values
values.yaml (default)

| Key              | Description                         | Example              |
| ---------------- | ----------------------------------- | -------------------- |
| `replicaCount`   | Number of pods                      | `3`                  |
| `service.type`   | Service type (NodePort / ClusterIP) | `NodePort` (default) |
| `service.port`   | Service/container port (templated)  | `3000`               |
| `configMap.name` | Name of the external ConfigMap      | `connect-frontend`   |
| `secret.name`    | Name of the external Secret         | `connect-frontend`   |


Secrets & ConfigMaps
Note: The chart does not create the Secret or ConfigMap.
These must be created and managed externally by a configuration repository

Deploy to development

helm upgrade --install connect-frontend . -f values-dev.yaml


Verify the deployment

kubectl get pods
kubectl describe pod <pod-name>
kubectl logs <pod-name>

Notes and best practices
The connect-frontend Secret and ConfigMap must exist before deploying

All ports are templated via Values.service.port for future changes

Security features enabled (SecurityContext, NetworkPolicy, allowPrivilegeEscalation: false)

Autoscaling (HPA) and PodDisruptionBudget improve availability

Ingress configuration is flexible with annotations and TLS


Author
Derick
DevOps Engineer
