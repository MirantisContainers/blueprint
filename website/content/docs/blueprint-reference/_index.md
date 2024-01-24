---
title: "Blueprint Reference"
draft: false
weight: 7
---

Boundless uses a YAML blueprint to configure the application. The blueprint is
a single file that contains all the information needed to setup and work with a cluster.
This section will cover the different fields in a blueprint and how you can customize it to
fit your needs.

An example of the full blueprint structure is shown below:

```yaml
apiVersion: boundless.mirantis.com/v1alpha1
kind: Blueprint
metadata:
  name: k0s-cluster
spec:
  kubernetes:
    provider: k0s
    version: 1.28.5+k0s.0
    infra:
      hosts:
        - ssh:
            address: 10.0.0.1
            keyPath: ""
            port: 22
            user: root
          role: controller
        - ssh:
            address: 10.0.0.2
            keyPath: ""
            port: 22
            user: root
          role: worker
  components:
    addons:
      - name: example-server
        kind: chart
        enabled: true
        namespace: default
        chart:
          name: nginx
          repo: https://charts.bitnami.com/bitnami
          version: 15.1.1
          values: |
            "service":
              "type": "ClusterIP"
```
