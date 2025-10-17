# Kyverno Production Policies

This folder contains production-ready Kyverno policies, organized by category.

## block-privileged-containers.yaml
**Category**: Security

Blocks the use of privileged containers to prevent elevated access to the host.

## disallow-latest-tag.yaml
**Category**: Restrictions

Disallows the use of the 'latest' tag in container images.

## require-resources.yaml
**Category**: Best-practices

Requires memory and CPU requests and limits to be set on all containers.

## enforce-namespace-labels.yaml
**Category**: Restrictions

Enforces specific labels on all namespaces.

## restrict-hostpath.yaml
**Category**: Security

Restricts usage of hostPath volumes in Pods.

## require-probes.yaml
**Category**: Best-practices

Requires liveness and readiness probes for all containers.

## verify-signed-images.yaml
**Category**: Security

Allows only signed container images (Cosign-based verification).

## kustomization.yaml
**Category**: overlays/production
In the Kyverno policies Helm chart (like kyverno/kyverno-policies), the overlays/kustomization directory is typically used to provide Kustomize support for customizing or patching the base Kyverno policies before they are deployed.

Structure: overlays/kustomization/
Here's what this folder usually contains:

# kustomization.yaml
This file defines how to customize the Kyverno base policies using Kustomize. It may include:

Edit
resources:
  - ../../policies

patchesStrategicMerge:
  - patch-enforce.yaml
resources: points to the base policies directory (e.g., ../../policies)

patchesStrategicMerge: applies custom patches (like changing validationFailureAction from Audit to Enforce)

Patch Files (e.g., patch-enforce.yaml)
These YAML files are used to modify or override fields in the original policies, e.g.:

Edit
apiVersion: kyverno.io/v1
kind: ClusterPolicy
metadata:
  name: disallow-latest-tag
spec:
  validationFailureAction: Enforce
This patch would override the original policy to enforce rather than audit.