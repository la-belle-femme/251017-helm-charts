This repository provides a production-ready, Helm-based deployment of cert-manager, fully automated with a custom chart, a Let's Encrypt ClusterIssuer, and TLS certificate generation using Kubernetes-native resources.



## Repository Structure

cert-manager/
├── Chart.yaml                     # Helm chart metadata
├── values.yaml                    # Chart values (e.g., image, replicas, resources)
├── templates/                     # All Helm template files
│   ├── _helpers.tpl               # Helper template functions (name, labels, selectors)
│   ├── deployment.yaml            # cert-manager core deployment
│   ├── clusterrole.yaml           # RBAC role
│   ├── clusterrolebinding.yaml    # RBAC binding
│   ├── serviceaccount.yaml        # Service account
│   ├── service.yaml               # Webhook service
│   ├── webhook.yaml               # Webhook deployment
│   └── issuer.yaml                # Optional: issuer for namespace-level certs
├── manifests/
│   └── clusterissuer.yaml         # Let's Encrypt ClusterIssuer YAML
├── scripts/
│   ├── install-cert-manager.sh    # Full install script (Helm + CRDs + issuer)
│   └── setup-clusterissuer.sh     # Applies and waits for ClusterIssuer readiness


## Prerequisites
Kubernetes 1.20+

Helm 3.x

kubectl configured to access your cluster

##  Installation
Run the install script to deploy cert-manager, CRDs, webhook TLS, and the ClusterIssuer:


bash scripts/install-cert-manager.sh
This script will:

Create the cert-manager namespace (if not present)

Install or upgrade the chart using local Helm templates

Generate a self-signed TLS secret for the webhook using a Helm pre-install Job

Apply the ClusterIssuer manifest and wait for it to be ready

## Verifying Installation
Check cert-manager pods:


kubectl get pods -n cert-manager
Check Helm release:


helm list -n cert-manager
Check CRDs:


kubectl get crds | grep cert-manager.io
Check ClusterIssuer status:


kubectl get clusterissuer
kubectl describe clusterissuer letsencrypt-prod


## TLS Secret Generation
The webhook.yaml mounts a TLS secret named cert-manager-webhook-tls.
This secret is automatically created by a Helm hook (templates/webhook-cert-job.yaml) during install/upgrade using OpenSSL.

## Test Certificate (Optional)
You can create a test certificate to ensure cert-manager is working properly:


apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name: test-cert
  namespace: default
spec:
  dnsNames:
    - test.devopseasylearning.com
  secretName: test-cert-tls
  issuerRef:
    name: letsencrypt-prod
    kind: ClusterIssuer
Apply it:


kubectl apply -f test-cert.yam


## Cleanup
To remove everything:



helm uninstall cert-manager --namespace cert-manager
kubectl delete namespace cert-manager
kubectl get crd | grep cert-manager.io | awk '{print $1}' | xargs kubectl delete crd

## Customization
Edit values.yaml to change:

Image version

Replica count

Resource limits

Webhook settings

Prometheus monitoring options

## License
This project is provided for educational and DevOps automation use. Feel free to adapt it to your organization’s requirements.

