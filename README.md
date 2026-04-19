<img width="1920" height="1013" alt="image" src="https://github.com/user-attachments/assets/143a63c5-6cfe-4aed-afa9-501cf6ad629b" />

<img width="1914" height="1016" alt="image" src="https://github.com/user-attachments/assets/016966f6-cd11-464f-8878-36de364e794d" />


# Kubernetes Install Template

이 레포는 Rocky Linux 기반 환경에서 kubeadm + containerd로 Kubernetes 클러스터를 구축하고,
기본 운영에 필요한 metrics-server, monitoring, Nexus registry까지 구성하기 위한 템플릿입니다.

단순 설치 기록이 아니라, 새 서버에서도 동일한 방식으로 재현 가능한 구조를 목표로 정리했습니다.

## 왜 이 기술들을 쓰는가

- `Rocky Linux`
  기업형 리눅스 계열로 운영 절차를 표준화하기 쉽고, 서버 초기 세팅 문서를 맞추기 좋습니다.
- `kubeadm`
  관리형 서비스 없이도 클러스터 구성 과정을 명확하게 문서화할 수 있어 재현성과 학습 목적에 유리합니다.
- `containerd`
  현재 Kubernetes 기본 흐름과 잘 맞고, Docker 의존 없이 런타임을 단순하게 유지할 수 있습니다.
- `metrics-server`
  HPA나 리소스 상태 확인의 기본 전제라서 최소 운영 기능으로 필요합니다.
- `Prometheus + Grafana`
  설치 후 바로 CPU/메모리/서비스 상태를 볼 수 있어 장애 원인 파악 속도를 높여줍니다.
- `Nexus registry`
  내부 이미지와 패키지 프록시를 한곳에서 관리해 외부 레지스트리 의존을 줄일 수 있습니다.
- `Jenkins`
  클러스터 설치 저장소와 애플리케이션 저장소를 나눠도, 반복 검증과 배포 작업을 한곳에서 관리할 수 있습니다.

## 구성 범위

- OS bootstrap
- Kubernetes cluster 구성
- metrics-server
- Prometheus / Grafana
- Nexus registry
- agent manifest
- Jenkins registration / deployment metadata

## 디렉토리 구조

- scripts/bootstrap: OS 기본 설정
- scripts/cluster: master init / worker join
- scripts/addons: metrics-server
- scripts/monitoring: monitoring 설치
- scripts/registry: Nexus 설정
- scripts/ci: Jenkins 검증 스크립트
- env/jenkins.env.example: Jenkins controller/job 설정 예제
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

- [Jenkins placement guide](docs/jenkins.md)

## Jenkins 검증

`Jenkinsfile`은 `main` 브랜치 push 기준으로 저장소 구조를 검증합니다.

- `docs/`, `env/` 핵심 파일 존재 여부 확인
- `scripts/**/*.sh` 문법 검사
- `manifests/**/*.yaml` 파일 존재 및 비어있지 않음 확인

## 현재 진행 사항

- [x] 클러스터 부트스트랩/애드온/모니터링/레지스트리 스크립트 정리
- [x] Jenkins 배치 가이드와 환경 변수 예제 추가
- [x] `main` 기준 Jenkins 검증 파이프라인 추가
- [x] Jenkins 잡 `kube-local-main` 등록 및 1회 성공 확인
- [ ] Jenkins 전용 서비스어카운트/RBAC를 저장소 매니페스트로 정리
- [ ] 운영용 Jenkinsfile 경로/브랜치/토큰 값을 환경별로 분리

## 앞으로 할 일

- [ ] `manifests/jenkins/` 또는 별도 디렉터리로 Jenkins 운영 리소스 분리
- [ ] 클러스터 설치 후 검증 절차를 체크리스트 문서로 추가
- [ ] registry/monitoring 설치 결과를 점검하는 스모크 스크립트 보강
- [ ] 환경별 `env/*.example`를 더 세분화해 신규 서버 초기 입력을 줄이기
