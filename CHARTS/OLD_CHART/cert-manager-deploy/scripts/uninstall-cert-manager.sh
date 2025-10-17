#!/bin/bash

set -e

NAMESPACE="cert-manager"
RELEASE="cert-manager"

echo "=============================="
echo " Uninstalling Helm Release..."
echo "=============================="
helm uninstall "$RELEASE" --namespace "$NAMESPACE" || echo "Helm release not found."

echo
echo "=============================="
echo " Deleting Namespace: $NAMESPACE"
echo "=============================="
kubectl delete namespace "$NAMESPACE" --ignore-not-found

echo
echo "=============================="
echo " Deleting cert-manager CRDs..."
echo "=============================="
kubectl get crds | grep 'cert-manager.io' | awk '{print $1}' | xargs -r kubectl delete crd

echo
echo "=============================="
echo " Cleanup Complete."
echo "=============================="
