#!/bin/bash
set -euo pipefail

# 기본 유틸
dnf install -y \
  git curl wget jq vim-enhanced bash-completion \
  net-tools bind-utils telnet traceroute \
  tar unzip lsof

# kubectl 자동완성/alias
grep -q "source <(kubectl completion bash)" ~/.bashrc 2>/dev/null || \
  echo 'source <(kubectl completion bash)' >> ~/.bashrc
grep -q "alias k=" ~/.bashrc 2>/dev/null || \
  echo "alias k=kubectl" >> ~/.bashrc
grep -q "__start_kubectl k" ~/.bashrc 2>/dev/null || \
  echo "complete -o default -F __start_kubectl k" >> ~/.bashrc

# Helm 설치 (Rocky 9 기본 repo에 없을 수 있어, 공식 스크립트 사용)
if ! command -v helm >/dev/null 2>&1; then
  curl -fsSL https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
fi

# KUBECONFIG 영구 설정(root 기준)
grep -q "KUBECONFIG=/etc/kubernetes/admin.conf" ~/.bashrc 2>/dev/null || \
  echo "export KUBECONFIG=/etc/kubernetes/admin.conf" >> ~/.bashrc

