---
title: "Addons"
draft: false
weight: 2
---

Update the `blueprint.yaml` file to add add-ons to the cluster. The add-ons are defined in the `spec.components.addons` section.

Any public Helm chart can be used as an add-on.

Use the following configuration to add the `grafana` as an add-on:
```yaml
spec:
 components:
   addons:
   - name: my-grafana
     enabled: true
     kind: HelmAddon
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
