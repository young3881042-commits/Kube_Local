#!/bin/bash
set -euo pipefail

kubectl get ns nexus >/dev/null 2>&1 || kubectl create ns nexus

helm repo add sonatype https://sonatype.github.io/helm3-charts/ >/dev/null || true
helm repo update >/dev/null

cat > values.yaml <<'EOV'
nexus:
  resources:
    requests:
      cpu: 200m
      memory: 512Mi
  env:
    - name: INSTALL4J_ADD_VM_PARAMS
      value: "-Xms512m -Xmx512m -XX:MaxDirectMemorySize=512m"
persistence:
  enabled: false
service:
  type: NodePort
  nodePort: 32081
EOV

helm upgrade --install nexus sonatype/nexus-repository-manager -n nexus -f values.yaml

# deployment 이름 자동 탐지
DEPLOY="$(kubectl -n nexus get deploy -o jsonpath='{.items[0].metadata.name}')"
kubectl -n nexus rollout status "deploy/${DEPLOY}" --timeout=600s

kubectl -n nexus get svc -o wide
