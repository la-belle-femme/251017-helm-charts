Here's the complete, detailed README.md file for the Forgejo Helm chart:
markdown
Copy
# Forgejo Helm Chart

A production-ready Helm chart for deploying Forgejo Git Service on Kubernetes with persistence, security, and scalability.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Accessing Forgejo](#accessing-forgejo)
- [Persistence](#persistence)
- [Upgrading](#upgrading)
- [Uninstalling](#uninstalling)
- [Troubleshooting](#troubleshooting)
- [Configuration Reference](#configuration-reference)

## Prerequisites

- Kubernetes 1.19+ cluster
- Helm 3.8+
- PV provisioner supporting PersistentVolumeClaims
- (Optional) Ingress controller (e.g., nginx, traefik)
- (Optional) Cert-manager for TLS certificates

## Installation

1. Create namespace (if not using --create-namespace):
   ```bash
   kubectl create namespace code-hosting
2.	Install the chart:
bash
Copy
helm install forgejo ./forgejo \
  --namespace code-hosting \
  --create-namespace
Configuration
Customize deployment using values.yaml or CLI parameters:
Common Customizations
1.	Basic Configuration (values.yaml):
yaml
Copy
forgejoConfig:
  hostname: "git.my-company.com"
  rootUrl: "https://git.my-company.com/"
  ssh:
    domain: "ssh.git.my-company.com"
    port: 30222
2.	Enable Ingress with TLS:
yaml
Copy
ingress:
  enabled: true
  className: nginx
  annotations:
    cert-manager.io/cluster-issuer: letsencrypt-prod
  hosts:
    - host: git.my-company.com
      paths:
        - path: /
  tls:
    - secretName: forgejo-tls
      hosts:
        - git.my-company.com
3.	Resource Limits:
yaml
Copy
resources:
  requests:
    memory: "512Mi"
    cpu: "200m"
  limits:
    memory: "1Gi"
    cpu: "800m"
Installation with Custom Values
bash
Copy
helm install forgejo ./forgejo -n code-hosting \
  --set persistence.size=20Gi \
  --set ingress.enabled=true \
  --set forgejoConfig.hostname=git.my-company.com
Accessing Forgejo
Web Interface
1.	Port-forward (for testing):
bash
Copy
kubectl port-forward svc/forgejo-web 3000:3000 -n code-hosting
Access at: http://localhost:3000
2.	Via Ingress:
o	Ensure DNS record points to your ingress controller
o	Access at: https://git.my-company.com
SSH Access
bash
Copy
git clone ssh://git@<node-ip>:30222/<username>/<repository>.git
•	Replace <node-ip> with your Kubernetes node IP
•	Port 30222 is configurable via serviceSSH.nodePort
Persistence
•	Data stored at /data in the container
•	PVC configuration:
yaml
Copy
persistence:
  enabled: true
  size: 10Gi
  storageClass: "standard"
  accessMode: ReadWriteOnce
•	Important: Ensure your storage class supports ReadWriteOnce access mode
Upgrading
1.	Update your local chart:
bash
Copy
git pull
2.	Upgrade deployment:
bash
Copy
helm upgrade forgejo ./forgejo -n code-hosting -f values.yaml
Uninstalling
1.	Remove the deployment:
bash
Copy
helm uninstall forgejo -n code-hosting
2.	(Optional) Delete PVC (warning: data loss!):
bash
Copy
kubectl delete pvc -l app.kubernetes.io/name=forgejo -n code-hosting
Troubleshooting
1.	Check Pod Status:
bash
Copy
kubectl get pods -n code-hosting -l app.kubernetes.io/name=forgejo
2.	View Pod Logs:
bash
Copy
kubectl logs -f deploy/forgejo -n code-hosting
3.	Verify Services:
bash
Copy
kubectl get svc -n code-hosting | grep forgejo
4.	Check Persistent Volume:
bash
Copy
kubectl get pvc -n code-hosting
kubectl describe pvc forgejo -n code-hosting
5.	Test Network Connectivity:
bash
Copy
kubectl exec -it deploy/forgejo -n code-hosting -- curl localhost:3000
Configuration Reference
Parameter	Description	Default
replicaCount	Number of replicas	1
Image		
image.repository	Forgejo container image	codeberg.org/forgejo/forgejo
image.tag	Image tag	1.20.3
image.pullPolicy	Image pull policy	IfNotPresent
Persistence		
persistence.enabled	Enable PVC	true
persistence.size	Storage size	10Gi
persistence.storageClass	Storage class name	""
Service		
serviceWeb.type	Web service type	ClusterIP
serviceWeb.port	Web service port	3000
serviceSSH.type	SSH service type	NodePort
serviceSSH.port	SSH service port	22
serviceSSH.nodePort	SSH node port	30222
Ingress		
ingress.enabled	Enable ingress	false
ingress.className	Ingress class name	""
ingress.hosts[0].host	Ingress host	forgejo.example.com
Forgejo Config		
forgejoConfig.hostname	Web domain	forgejo.example.com
forgejoConfig.rootUrl	Full root URL	https://forgejo.example.com/
forgejoConfig.ssh.domain	SSH domain	git.example.com
forgejoConfig.ssh.port	SSH port	30222
Resources		
resources.requests	Pod resource requests	256Mi/100m
resources.limits	Pod resource limits	512Mi/500m
Notes
•	Initial Setup: Access the web interface to complete the initial configuration
•	SSH Keys: Users must add their SSH keys through the web interface
•	Backups: Regularly back up the persistent volume containing /data
•	Scaling: For high availability, set replicaCount: 2+ and ensure RWX storage

Copy

This README includes:
1. Comprehensive installation instructions
2. Configuration examples for common scenarios
3. Access methods for both web and SSH
4. Maintenance procedures
5. Troubleshooting guide
6. Complete configuration reference table
7. Best practice recommendations

The documentation follows Kubernetes/Helm best practices and provides multiple access methods suitable for different environments (development vs production).

