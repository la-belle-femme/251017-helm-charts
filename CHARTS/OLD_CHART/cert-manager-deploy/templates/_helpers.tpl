{{/*
Return the base name of the chart (e.g. "cert-manager")
*/}}
{{- define "cert-manager.name" -}}
cert-manager
{{- end }}

{{/*
Return the full name of the release with chart name suffix
(e.g. "myrelease-cert-manager")
*/}}
{{- define "cert-manager.fullname" -}}
{{ printf "%s-%s" .Release.Name (include "cert-manager.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels for all resources
*/}}
{{- define "cert-manager.labels" -}}
app.kubernetes.io/name: {{ include "cert-manager.name" . }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Labels for selectors (must match pod labels)
*/}}
{{- define "cert-manager.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cert-manager.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Annotations for cert-manager webhook resources
*/}}
{{- define "cert-manager.webhookAnnotations" -}}
cert-manager.io/inject-ca-from-secret: cert-manager-webhook-ca
{{- end }}

