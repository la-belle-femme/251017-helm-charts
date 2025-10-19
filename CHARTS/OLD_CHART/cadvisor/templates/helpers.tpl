{{/*
Expand the name of the chart.
*/}}
{{- define "cadvisor.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "cadvisor.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end }}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "cadvisor.labels" -}}
app.kubernetes.io/name: {{ include "cadvisor.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

