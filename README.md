# Cluster Tooling

## ArgoCD Waves

ArgoCD, on a fresh install, will install applications in "Waves".

This enables you to install things, that for example, create CRDs, that are used by other application, first.

## Install

Create the following resource in your argocd autopilot's `/projects` directory

### Helm + ArgoCD

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: cluster-tooling
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "-1"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  description: Cluster Tooling wave 0 (things that create CRDs needed it later waves)
  sourceRepos:
  - '*'
  destinations:
  - namespace: '*'
    server: https://kubernetes.default.svc
  clusterResourceWhitelist:
  - group: '*'
    kind: '*'
  namespaceResourceWhitelist:
  - group: '*'
    kind: '*'

---

apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: cluster-tooling
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "-1"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: local-cluster-tooling
  source:
    repoURL: https://github.com/cloudnativeentrepreneur/cluster-tooling.git
    targetRevision: HEAD
    path: helm
    helm:
      version: v3
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      selfHeal: true
      prune: true
```
