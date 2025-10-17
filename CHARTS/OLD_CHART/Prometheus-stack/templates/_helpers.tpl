{{- /*
  This file contains helper template functions used in the other manifest
  templates.  Even though the prom-stack chart deploys everything via the
  kube-prometheus-stack dependency, the helper functions defined here are
  maintained for completeness and to provide common labels and naming
  conventions.  See the official Helm chart best practices for details.
*/ -}}

{{- /* Generate a name for resources based on the release and chart name */ -}}
{{- define "prom-stack.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- /* Generate chart name */ -}}
{{- define "prom-stack.name" -}}
{{- default .Chart.Name .Values.nameOverride -}}
{{- end -}}

{{- /* Common labels applied to all resources */ -}}
{{- define "prom-stack.labels" -}}
app.kubernetes.io/name: {{ include "prom-stack.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}