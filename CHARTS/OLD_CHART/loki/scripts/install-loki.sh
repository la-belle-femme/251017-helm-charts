#!/bin/bash

set -e

NAMESPACE="loki"

echo " Ensuring namespace exists: $NAMESPACE"
kubectl get namespace $NAMESPACE >/dev/null 2>&1 || kubectl create namespace $NAMESPACE

echo " Applying S3 secret..."
kubectl apply -f manifests/loki-s3-secret.yaml


echo " Installing Loki..."
helm upgrade --install loki .  -f prod-values.yaml -n $NAMESPACE
