---
title: "Helm Chart"
draft: false
weight: 2
---

Any public Helm chart can be used as an add-on.

Use the following configuration to add the `grafana` as an add-on:

```yaml
spec:
  components:
    addons:
      - name: my-grafana
        enabled: true
        kind: helm
        namespace: monitoring
        chart:
          name: grafana
          repo: https://grafana.github.io/helm-charts
          version: 6.58.7
          values: |
            ingress:
              enabled: true
```

and then run `bctl update` to update the cluster.
