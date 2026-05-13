{{- define "3tier-app.fullname" -}}
{{ .Release.Name }}-{{ .Chart.Name }}
{{- end -}}
