

{{- define "passbolt.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "passbolt.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "passbolt.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "passbolt.labels" -}}
helm.sh/chart: {{ include "passbolt.chart" . }}
{{ include "passbolt.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "passbolt.selectorLabels" -}}
app.kubernetes.io/name: {{ include "passbolt.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "passbolt.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "passbolt.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Database secret name
*/}}
{{- define "passbolt.databaseSecretName" -}}
{{- if .Values.database.existingSecret }}
{{- .Values.database.existingSecret }}
{{- else }}
{{- printf "%s-db" (include "passbolt.fullname" .) }}
{{- end }}
{{- end }}

{{/*
LDAP secret name
*/}}
{{- define "passbolt.ldapSecretName" -}}
{{- if .Values.ldap.existingSecret }}
{{- .Values.ldap.existingSecret }}
{{- else }}
{{- printf "%s-ldap" (include "passbolt.fullname" .) }}
{{- end }}
{{- end }}

{{/*
GPG secret name
*/}}
{{- define "passbolt.gpgSecretName" -}}
{{- if .Values.encryption.gpg.existingSecret }}
{{- .Values.encryption.gpg.existingSecret }}
{{- else }}
{{- printf "%s-gpg" (include "passbolt.fullname" .) }}
{{- end }}
{{- end }}

{{/*
JWT secret name
*/}}
{{- define "passbolt.jwtSecretName" -}}
{{- if .Values.encryption.jwt.existingSecret }}
{{- .Values.encryption.jwt.existingSecret }}
{{- else }}
{{- printf "%s-jwt" (include "passbolt.fullname" .) }}
{{- end }}
{{- end }}

{{/*
SMTP secret name
*/}}
{{- define "passbolt.smtpSecretName" -}}
{{- if .Values.app.existingSmtpSecret }}
{{- .Values.app.existingSmtpSecret }}
{{- else }}
{{- printf "%s-smtp" (include "passbolt.fullname" .) }}
{{- end }}
{{- end }}
```