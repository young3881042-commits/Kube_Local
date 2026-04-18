#!/bin/bash
set -euo pipefail

kubectl get ns monitoring >/dev/null 2>&1 || kubectl create ns monitoring

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts >/dev/null
helm repo add grafana https://grafana.github.io/helm-charts >/dev/null
helm repo update >/dev/null

cat > prom-values.yaml <<'EOV'
alertmanager:
  enabled: false
pushgateway:
  enabled: false
server:
  resources:
    requests:
      cpu: 100m
      memory: 256Mi
  service:
    type: NodePort
    nodePort: 30090
  persistentVolume:
    enabled: false
kubeStateMetrics:
  enabled: true
nodeExporter:
  enabled: true
EOV

helm upgrade --install prom prometheus-community/prometheus \
  -n monitoring -f prom-values.yaml

cat > grafana-values.yaml <<'EOV'
adminPassword: "admin"
persistence:
  enabled: false
resources:
  requests:
    cpu: 100m
    memory: 128Mi
service:
  type: NodePort
  nodePort: 31300
datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
      - name: Prometheus
        type: prometheus
        url: http://prom-server.monitoring.svc.cluster.local
        access: proxy
        isDefault: true
EOV

helm upgrade --install grafana grafana/grafana \
  -n monitoring -f grafana-values.yaml

kubectl -n monitoring rollout status deploy/prom-server --timeout=300s
kubectl -n monitoring rollout status deploy/grafana --timeout=300s

kubectl -n monitoring get svc -o wide
