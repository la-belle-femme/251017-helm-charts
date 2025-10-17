Forgejo Helm Deployment: Acceptance Criteria & Validation
Generated on: April 06, 2025 at 07:25 PM

How Each Acceptance Criterion Was Met
1. ✅ Functional Helm Chart in Repo
Met:
- Created a Helm chart with proper structure (`Chart.yaml`, `values.yaml`, `templates/`)
- Hosted in a version-controlled repository (e.g., Git)
- Verified via `helm lint` and `helm install`
2. ✅ Working Forgejo with Persistent Storage
Met:
PVC configured in `values.yaml`:
```
persistence:
  enabled: true
  size: 10Gi
  accessMode: ReadWriteOnce
```
Validated with:
```
kubectl get pvc -n code-hosting  # Status: Bound
kubectl exec -it <pod> -- ls /data  # Confirmed repositories/configs
```
✔️ Data persisted after pod restarts.
3. ✅ Web & SSH Access Functional
Met:
Web:
```
kubectl port-forward svc/forgejo-web 3000:3000  # Accessed UI at http://localhost:3000
```
SSH:
```
git clone ssh://git@$(minikube ip):30222/your-username/test-repo.git
```

4. ✅ Customization via values.yaml
Met:
Key parameters configurable in `values.yaml`:
```
replicaCount: 1
image:
  repository: codeberg.org/forgejo/forgejo
  tag: 1.20.3-0
serviceSSH:
  nodePort: 30222
```
Overrides tested with:
```
--set persistence.size=20Gi
```

5. ✅ Kubernetes Best Practices
Met:
- Proper labels:
```
labels:
  app.kubernetes.io/name: {{ include "forgejo.name" . }}
  app.kubernetes.io/instance: {{ .Release.Name }}
```
- Resource limits/requests defined
- Namespace isolation used (`code-hosting`)
6. ✅ Deployment Survives Restarts
Met:
Tested via:
```
kubectl delete pod -l app.kubernetes.io/name=forgejo
kubectl get pods -w  # New pod retained PVC data
```

7. ✅ Complete Documentation
Met:
`README.md` includes:
- Installation steps
- Configuration options
- Access instructions (web/SSH)
- Upgrade/rollback procedures
- Troubleshooting guide
Final Status
Criteria	Status	Evidence
Functional Helm Chart	✅	Chart structure validated via tree and helm lint
Persistent Storage	✅	PVC bound + data retained across pod restarts
Web/SSH Access	✅	Successful port-forward and SSH clone test
Customization Support	✅	Working --set overrides and values.yaml modifications
Kubernetes Best Practices	✅	Labels, resource limits, and namespace isolation implemented
State Retention on Restart	✅	Test repo persisted after pod deletion
Documentation	✅	README covers installation, access, and troubleshooting

