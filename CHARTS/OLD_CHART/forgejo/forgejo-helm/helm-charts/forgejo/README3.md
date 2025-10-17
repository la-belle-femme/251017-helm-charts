Final Verification
Criteria	Status	Evidence
Functional Helm Chart	✅	Chart structure validated via tree and helm lint
Persistent Storage	✅	PVC shown as Bound with 10Gi capacity
Web/SSH Access	✅	Successful port-forward and SSH clone test
Customization Support	✅	Working --set overrides and values.yaml modifications
Kubernetes Best Practices	✅	Labels, resource limits, and namespace isolation implemented
State Retention on Restart	✅	Test repo persisted after pod deletion
Documentation	✅	README covers installation, access, and troubleshooting


													

 	
2. Check PersistentVolumeClaim (PVC) Status
 	
3. Verify Pod Mounts the PVC		

	
 	
 
4. Test Data Persistence create test data with command kubectl port-forward svc/forgejo-web 3000:3000 -n code-hosting

 	
5. Inspect Storage Logs with command kubectl logs -n code-hosting -l app.kubernetes.io/name=forgejo
 
	
 	Step 2: Simulate Pod Failure with command kubectl delete pod -n code-hosting -l app.kubernetes.io/name=forgejo	
 	
Step 3: Verify Data Retention With command kubectl get pods -n code-hosting -w	
 


