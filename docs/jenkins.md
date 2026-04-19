# Jenkins Placement Guide

This repository does not keep Jenkins secrets or controller-specific state in the root.
The recommended layout is:

- `env/jenkins.env.example` for non-secret Jenkins variables
- `env/jenkins.env` for local, ignored overrides
- `scripts/` for executable registration or deployment logic
- `manifests/` for Kubernetes resources only if Jenkins agents or helpers are deployed in-cluster
- `docs/` for the operator flow and job wiring

## Recommended split

Keep the Jenkins job definition at the repository root only when the job is a
Pipeline from SCM or Multibranch Pipeline that should read `Jenkinsfile`
directly.

Put reusable shell automation under `scripts/` so Jenkins can call the same
entrypoint locally and in CI.

Keep controller URLs, job names, branch names, and credential IDs in
`env/jenkins.env.example`. Do not commit real tokens.

## Current repo fit

For `Kube_Local`, the right place for Jenkins registration and deployment
metadata is:

1. `docs/jenkins.md` for the operational guide
2. `env/jenkins.env.example` for configuration examples
3. `scripts/` if a future job needs repo-local automation

If Jenkins later gets its own in-cluster agent or controller manifests, add a
dedicated `manifests/jenkins/` directory instead of mixing them into the cluster
bootstrap scripts.
