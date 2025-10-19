prom-stack

This repository provides a Helm wrapper chart for deploying a full
Prometheus monitoring stack on Kubernetes. It leverages the
kube‑prometheus‑stack chart from the prometheus-community/helm-charts
repository and adds opinionated overrides for development and
production environments.

Components

The deployed stack includes:

Prometheus – scrapes metrics from Kubernetes nodes, pods and
services and evaluates alerting/recording rules.

Alertmanager – routes alerts to receivers. The provided
values send notifications to a Mattermost incoming webhook and
an SMTP relay.

Grafana – visualises metrics. A Prometheus datasource is
provisioned automatically along with a simple node resource
dashboard.

Node Exporter – exposes node‑level metrics.

Kube State Metrics – exposes resource metrics about the
Kubernetes API objects.

Chart structure
prom-stack/
├── Chart.yaml           # Chart definition and dependency on kube‑prometheus‑stack
├── values.yaml          # Shared defaults for all environments
├── values-dev.yaml      # Overrides for development deployments
├── values-prod.yaml     # Overrides for production deployments
├── values-override.yaml # Placeholder pointing to dev/prod files
└── templates/           # Boilerplate templates (empty by default)

Values files

values.yaml contains common defaults such as enabling CRDs.

values-dev.yaml and values-prod.yaml enable all components and
configure alert receivers, Grafana dashboards and custom
Prometheus rules. Update these files with your own webhook URLs
and SMTP credentials as required.

Prerequisites

A Kubernetes cluster (Kubernetes ≥ 1.24) and kubectl configured to
access it.

Helm v3 installed locally.

(Optional) A Mattermost incoming webhook and SMTP credentials if you
want to receive alerts.

Installation

Add the prometheus-community chart repository and build the chart
dependencies:

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm dependency build prom-stack


Deploy the stack into the monitoring namespace using the dev values:

helm upgrade --install prom-stack prom-stack \
  -n monitoring --create-namespace \
  -f prom-stack/values.yaml -f prom-stack/values-dev.yaml


For production, substitute values-dev.yaml with values-prod.yaml:

helm upgrade --install prom-stack prom-stack \
  -n monitoring --create-namespace \
  -f prom-stack/values.yaml -f prom-stack/values-prod.yaml

Verifying the deployment

Check that all pods are running:

kubectl get pods -n monitoring


Port-forward services to access their UIs locally:

# Prometheus UI on http://localhost:9090
kubectl -n monitoring port-forward svc/prom-stack-kube-prometheus-prometheus 9090:9090

# Grafana UI on http://localhost:3000
kubectl -n monitoring port-forward svc/prom-stack-grafana 3000:3000

# Alertmanager UI on http://localhost:9093
kubectl -n monitoring port-forward svc/prom-stack-kube-prometheus-alertmanager 9093:9093


The default Grafana credentials are admin/admin. After login,
you should see a “Prometheus” datasource and a “Node Resource”
dashboard under Custom Dashboards.

Alerts and notifications

The chart provisions custom alerting and recording rules under
additionalPrometheusRulesMap. Alerts for high CPU and memory usage
are routed to the mattermost-and-email receiver defined in the
values files. Make sure to update the Mattermost webhook URL and
SMTP credentials in the dev/prod values to match your environment.

To test notifications, you can create a simple always‑firing rule:

apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: test-alert
  namespace: monitoring
  labels:
    release: prom-stack
spec:
  groups:
    - name: test-group
      rules:
        - alert: TestAlertAlwaysOn
          expr: vector(1)
          for: 1m
          labels:
            severity: critical
          annotations:
            summary: "Test alert (always firing)"
            description: "This is a test alert to verify notifications."


Apply it with kubectl apply -f and check that you receive alerts in
Mattermost and email. Delete the rule when you’re done testing.

CI/CD

For automated validation, the repository includes a sample Forgejo
workflow in .forgejo/workflows/helm-ci.yml that runs on every
push. It installs Helm, fetches chart dependencies, runs helm lint
and renders the chart using both dev and prod values to ensure there
are no templating errors.

If you’re using GitHub Actions instead of Forgejo, an equivalent
workflow is provided in helm-ci.yml. Copy it to
.github/workflows/ to enable the same checks on GitHub.