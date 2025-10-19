#!/bin/bash

set -e

echo "=============================="
echo " Applying ClusterIssuer..."
echo "=============================="

kubectl apply -f manifests/clusterissuer.yaml

echo "=============================="
echo " Waiting for ClusterIssuer to become Ready..."
echo "=============================="

CLUSTERISSUER_NAME=$(kubectl get -f manifests/clusterissuer.yaml -o jsonpath='{.metadata.name}')

# Wait until it's Ready (timeout after 60 seconds)
for i in {1..30}; do
  STATUS=$(kubectl get clusterissuer "$CLUSTERISSUER_NAME" -o jsonpath='{.status.conditions[?(@.type=="Ready")].status}' 2>/dev/null || echo "NotFound")

  if [[ "$STATUS" == "True" ]]; then
    echo " ClusterIssuer '$CLUSTERISSUER_NAME' is Ready!"
    exit 0
  elif [[ "$STATUS" == "False" ]]; then
    echo " ClusterIssuer '$CLUSTERISSUER_NAME' exists but is not Ready yet..."
  else
    echo " Waiting for ClusterIssuer '$CLUSTERISSUER_NAME'..."
  fi

  sleep 2
done

echo " Timed out waiting for ClusterIssuer to become Ready."
kubectl describe clusterissuer "$CLUSTERISSUER_NAME"
exit 1
