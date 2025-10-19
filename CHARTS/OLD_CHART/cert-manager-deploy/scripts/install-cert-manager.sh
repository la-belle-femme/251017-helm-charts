#!/bin/bash

set -e

NAMESPACE=cert-manager

echo "Creating namespace..."
kubectl create namespace $NAMESPACE || true

echo "Installing cert-manager CRDs..."
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.14.3/cert-manager.crds.yaml


echo "Installing cert-manager via Helm..."
helm upgrade --install cert-manager .
  --namespace $NAMESPACE \
  --set installCRDs=true

echo "cert-manager deployed successfully!"
