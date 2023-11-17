---
title: "Core Components"
draft: false
weight: 1
---

Currently, you can replace the ingress controller from `ingress-nginx` to `kong` by updating the `blueprint.yaml` file:
```yaml
spec:
 components:
   core:
     ingress:
       enabled: true
       provider: kong # ingress-nginx, kong, etc.
```

> If the cluster is already deployed, run `bctl reset` to destroy the cluster and then run `bctl apply` to recreate it.
