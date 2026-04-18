# Nexus PyPI hosted repository

Web UI:

- `http://192.168.45.101:32457`

Repository:

- Name: `pypi-hosted`
- Simple index: `http://192.168.45.101:32457/repository/pypi-hosted/simple`
- Upload endpoint: `http://192.168.45.101:32457/repository/pypi-hosted/`

Scripts:

- Install Nexus: `/apps/kube_shell/04.registry_nexus/04.nexus.sh`
- Create PyPI hosted repo: `/apps/kube_shell/04.registry_nexus/05.configure-nexus-pypi-hosted.sh`
- Upload files in `dist/`: `/apps/kube_shell/04.registry_nexus/06.upload-demo-pypi-package.sh`

Demo package:

- `/apps/kube_shell/04.registry_nexus/pypi-demo`

Verified commands:

- `curl http://192.168.45.101:32457/repository/pypi-hosted/simple/`
- `python3 -m pip download --no-deps --index-url http://192.168.45.101:32457/repository/pypi-hosted/simple/ --trusted-host 192.168.45.101 nexus-demo-pkg==0.1.0 -d /tmp/nexus-pypi-download`

Example:

- `export NEXUS_PASS='<admin-password>'`
- `DIST_DIR=/apps/kube_shell/04.registry_nexus/pypi-demo/dist /apps/kube_shell/04.registry_nexus/06.upload-demo-pypi-package.sh`
