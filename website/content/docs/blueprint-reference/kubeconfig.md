---
title: "Kubeconfig"
draft: false
weight: 1
---

## Precedence

The following list shows the order of precedence for kubeconfig files used by `bctl`:

1. Provided to `bctl` using the `--kubeconfig` flag
2. Add to the blueprint under `kubernetes.kubeconfig`

```yaml
kubernetes:
  kubeconfig: <path to kubeconfig file>
```

3. File from the environment variable `KUBECONFIG`
4. File located at the default location (e.g. ~/.kube/config)

If an officially supported distro is being used, `bctl` is able to find the kubeconfig if it not specified by any of the above. If a custom distro is being used, the kubeconfig must be provided to `bctl` using one of the above methods.
