#!/bin/bash
set -euo pipefail

# metrics-server 설치
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Rocky/VM 환경에서 kubelet 인증 문제 나면 대비 옵션 추가
kubectl -n kube-system patch deployment metrics-server \
  --type='json' \
  -p='[
    {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-insecure-tls"},
    {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname"}
  ]' || true

kubectl -n kube-system rollout status deploy/metrics-server --timeout=180s

# 동작 확인 (바로 안 나오면 30초~1분 후 다시)
kubectl top nodes || true
