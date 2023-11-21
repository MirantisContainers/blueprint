---
title: "Manifests"
draft: false
weight: 2
---

The following is an example of how to add metallb using a manifest as an add-on:

```yaml
spec:
  components:
    addons:
      - name: metallb
        kind: manifest
        enabled: true
        namespace: boundless-system
        manifest:
          url:"https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/admin/namespace-dev.yaml"
```

and then run `bctl update` to update the cluster.
