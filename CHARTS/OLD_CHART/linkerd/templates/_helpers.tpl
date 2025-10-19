{{/* Helper template file */}}
{{- define "linkerd.name" -}}
linkerd
{{- end -}}

{{- define "linkerd.namespace" -}}
{{ .Release.Namespace }}
{{- end -}}
