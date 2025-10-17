#!/bin/bash

set -e

NAMESPACE="logstash"  # You can change this to something else

echo "📁 Creating namespace '$NAMESPACE'..."
kubectl create namespace $NAMESPACE || true

echo "🔐 Applying TLS certificate secret..."
kubectl apply -f secrets/logstash-tls-secret.yaml -n $NAMESPACE

echo "🔐 Creating Elasticsearch credentials secret..."
kubectl apply -f secrets/elastic-creds.yaml -n $NAMESPACE

echo "📦 Adding Elastic Helm repo and updating..."
helm repo add elastic https://helm.elastic.coS
helm repo update

echo "🚀 Deploying Logstash via Helm..."
helm upgrade --install logstash elastic/logstash \
  -n $NAMESPACE \
  -f values/logstash-values.yaml \
  --create-namespace

echo "✅ Logstash deployed successfully in namespace '$NAMESPACE'."
echo "👉 Remember to update your Prometheus scrape config with: prometheus/scrape-config.yaml"
