# Cluster Tooling

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
  description: Cluster tooling
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
  project: cluster-tooling
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

## Observability

Observability related tools can be found in the [Observability](https://github.com/CloudNativeEntrepreneur/observability) project.

## Included

### External Secrets and Fake Secret Store
### KNative Operator, Serving, and Eventing
### Zalando Postgres Operator
### Schemahero
