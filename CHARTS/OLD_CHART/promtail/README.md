# Promtail Deployment with Loki using Helm

## Overview

This document provides a step-by-step guide for deploying Promtail using Helm and configuring it to send logs to Loki. The setup ensures Promtail runs as a DaemonSet, following best practices for resource allocation, security, and performance tuning.

## Prerequisites

Before deploying Promtail, ensure you have the following:

- A running Kubernetes cluster
- Helm installed
- Loki deployed in the appropriate namespace (e.g., `logging`)

## Installation Steps

### 1. Create the Namespace

Create a dedicated namespace for logging components (if it doesn't already exist):

```sh
kubectl create namespace logging
```

### 2. Deploy Loki

If Loki is not already installed, deploy it in the `logging` namespace using Helm or your preferred method.

### 3. Configure Promtail

Prepare a custom `values.yaml` file to override the default Promtail settings (e.g., `test-values.yaml`). This should include your target Loki URL and any required configuration adjustments.

### 4. Deploy Promtail

Install Promtail with Helm using the configured override file:

```sh
helm install promtail grafana/promtail -n logging -f test-values.yaml
```

### 5. Verify Deployment

Check if Promtail pods are running:

```sh
kubectl get pods -n logging
```

Check Promtail logs:

```sh
kubectl logs -l app.kubernetes.io/name=promtail -n logging
```

## Updating Configuration

To update Promtail’s configuration, modify the override `values.yaml` file and apply the changes:

```sh
helm upgrade promtail grafana/promtail -n logging -f test-values.yaml
```

## Configuration Note

Ensure the `url` in your Promtail configuration correctly reflects the namespace where `loki-gateway` is deployed:

```yaml
clients:
  - url: "http://loki-gateway.<namespace>.svc.cluster.local/loki/api/v1/push"
    tenant_id: "1"
```

Replace `<namespace>` with the actual namespace. For example, if `loki-gateway` is in the `logging` namespace:

```yaml
clients:
  - url: "http://loki-gateway.logging.svc.cluster.local/loki/api/v1/push"
    tenant_id: "1"
```

## Future TLS Configuration

If enabling TLS in the future, update Promtail’s configuration accordingly:

```yaml
clients:
  - url: "https://loki-gateway/loki/api/v1/push"
    tenant_id: "1"
```

Ensure that Loki is accessible through a TLS-enabled gateway and certificates are configured properly.

## Monitoring with Prometheus

Promtail exposes metrics on port **3101**, which can be scraped by Prometheus.

## Troubleshooting

- **Check Promtail logs:**

  ```sh
  kubectl logs -l app.kubernetes.io/name=promtail -n logging
  ```

- **Ensure Loki is running:**

  ```sh
  kubectl get svc -n logging | grep loki
  ```

- **Verify Promtail is shipping logs:**

  ```sh
  kubectl exec -n logging -it $(kubectl get pod -n logging -l app.kubernetes.io/name=promtail -o jsonpath="{.items[0].metadata.name}") -- \
    curl -s http://localhost:3101/metrics | grep log_entries_total
  ```

## Sample LogQL Queries

Use these in the Loki UI or Grafana Explore view to test and explore log data:

```logql
{app="loki"} | logfmt
{app="grafana"} | logfmt
count_over_time({job=~".+"}[5m])
{job=~".+"}
{job=~".+"} | line_format "{{.message}}"
{job=~".+"} |~ "error|warn"
{namespace="logging", pod=~".+"}
```

## Next Steps

Update the `values.yaml` files for each environment accordingly before applying them.

## Conclusion

This setup ensures that Promtail efficiently collects logs from all Kubernetes nodes and ships them to Loki. The configuration is designed with security, observability, and future scalability in mind, including optional TLS support.

For further customization, refer to the official [Promtail documentation](https://grafana.com/docs/loki/latest/send-data/promtail/).
