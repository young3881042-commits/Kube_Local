<img width="1920" height="1013" alt="image" src="https://github.com/user-attachments/assets/143a63c5-6cfe-4aed-afa9-501cf6ad629b" />



# Kubernetes Install Template

이 레포는 Rocky Linux 기반 환경에서 kubeadm + containerd로 Kubernetes 클러스터를 구축하고,
기본 운영에 필요한 metrics-server, monitoring, Nexus registry까지 구성하기 위한 템플릿입니다.

단순 설치 기록이 아니라, 새 서버에서도 동일한 방식으로 재현 가능한 구조를 목표로 정리했습니다.

## 구성 범위

- OS bootstrap
- Kubernetes cluster 구성
- metrics-server
- Prometheus / Grafana
- Nexus registry
- agent manifest

## 디렉토리 구조

- scripts/bootstrap: OS 기본 설정
- scripts/cluster: master init / worker join
- scripts/addons: metrics-server
- scripts/monitoring: monitoring 설치
- scripts/registry: Nexus 설정
- env: 환경 변수 예제
- helm-values: Helm values
- manifests: Kubernetes yaml
- docs: 상세 문서

## 빠른 시작

cp env/cluster.env.example env/cluster.env
vi env/cluster.env

bash scripts/bootstrap/default_setup.sh
bash scripts/cluster/master-init.sh
bash scripts/cluster/worker-join.sh
bash scripts/addons/metrics-server.sh
bash scripts/monitoring/install-monitoring.sh
bash scripts/registry/install-nexus.sh

## 문서

docs/ 하위 참고
