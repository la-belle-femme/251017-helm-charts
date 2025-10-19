## Alertmanager Helm Chart
This Helm chart deploys a production-grade Alertmanager instance integrated with Prometheus, supporting high availability, persistence, secure networking, alert routing, and external notifications (e.g. mattermost).

## Project Structure
alertmanager/
├── Chart.yaml
├── values.yaml
├── dev-values.yaml
├── test-values.yaml
├── prod-values.yaml
├── charts/
├── templates/
│   ├── _helpers.tpl
│   ├── NOTES.txt
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── pvc.yaml
│   ├── pdb.yaml
│   ├── serviceaccount.yaml
│   ├── rbac.yaml
│   ├── networkpolicy.yaml
│   ├── servicemonitor.yaml
│   ├── configmap.yaml
│   ├── secret.yaml
│   ├── hpa.yaml
│   └── prometheusrule.yaml

## Installation
You can install this chart using the provided script. This supports different environments (dev, test, prod) with environment-specific overrides.

## Prerequisites
Helm 3+

Kubernetes cluster with access to namespace monitoring

kubectl configured

 Step-by-Step

Navigate to the Chart Directory:

kubens into the alertmanager namespace or create if it does not exist;

Deploy Alertmanager using one of the following environments:

helm install alertmanager .  #default

Deploy Alertmanager using one of the following environments:

helm install alertmanager . -f prod-values.yaml  # Production
   
helm install alertmanager . -f  test-values.yaml  # Testing

helm install alertmanager . -f  prod-values.yaml  #development



## Verification
Check that the pods are running:


kubectl get pods -n monitoring -l app.kubernetes.io/name=alertmanager
Port forward to access the UI (if ingress is disabled):


kubectl -n monitoring port-forward svc/alertmanager 9093:9093
 mattermost Integration (Optional)
If you're using mattermost notifications:

Set the mattermost webhook URL in prod-values.yaml:

secrets:
mattermostWebhookUrl: "https://hooks.mattermost.com/services/XXX/YYY/ZZZ"
This value is injected into the Alertmanager configuration using a Kubernetes Secret.

# Metrics & Monitoring
This chart includes:

ServiceMonitor for Prometheus scraping

PrometheusRule to alert when Alertmanager is down

Optional HPA for CPU-based autoscaling

# Security & Best Practices
Feature	Description
RBAC	Custom role and binding for least privilege
NetworkPolicy	Restrict inbound traffic to Prometheus only
PodDisruptionBudget	Ensures availability during upgrades
Secret management	mattermost webhooks stored securely
Persistent Storage	PVC-backed alert state retention

# Cleanup
To uninstall Alertmanager:
helm uninstall alertmanager -n monitoring
kubectl delete pvc -n monitoring -l app.kubernetes.io/name=alertmanager

# Notes
The default configuration is tuned for Kubernetes clusters monitored by kube-prometheus-stack
You can extend routing rules and receivers in configmap.yaml

