{{/* Define common labels */}}
{{- define "grafana.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* Selector labels */}}
{{- define "grafana.selectorLabels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{/* Full name */}}
{{- define "grafana.fullname" -}}
{{ printf "%s-%s" .Release.Name .Chart.Name }}
{{- end -}}

{{/* Service account name */}}
{{- define "grafana.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
  {{- default (include "grafana.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
  {{- default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}
