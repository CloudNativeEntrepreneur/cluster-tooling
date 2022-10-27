# Cluster Tooling

## ArgoCD Waves

ArgoCD, on a fresh install, will install applications in "Waves".

This enables you to install things, that for example, create CRDs, that are used by other application, first.

Put things like this (Operators, etc) into helm/wave-0 - for things then created before our applications, use wave-1 - such as cluster-wide resources.

## Install

Create the following resource in your argocd autopilot's `/projects` directory

### Wave 0

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: local-cluster-tooling-wave-0
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "0"
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
  name: local-cluster-tooling-wave-0
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "0"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: local-cluster-tooling-wave-0
  source:
    repoURL: https://github.com/cloudnativeentrepreneur/cluster-tooling.git
    targetRevision: HEAD
    path: helm/wave-0
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      selfHeal: true
      prune: true
```

### Wave 1

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: local-cluster-tooling-wave-1
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "1"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  description: Cluster Tooling wave 1 (things that create CRDs needed it later waves)
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
  name: local-cluster-tooling-wave-1
  namespace: argocd
  annotations:
    argocd.argoproj.io/sync-wave: "1"
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  project: local-cluster-tooling-wave-1
  source:
    repoURL: https://github.com/cloudnativeentrepreneur/cluster-tooling.git
    targetRevision: HEAD
    path: helm/wave-1
  destination:
    server: https://kubernetes.default.svc
    namespace: argocd
  syncPolicy:
    automated:
      selfHeal: true
      prune: true
```