---
title: "k0s Cluster"
draft: false
weight: 1
---

```yaml
apiVersion: boundless.mirantis.com/v1alpha1
kind: Blueprint
metadata:
  name: boundless-cluster
spec:
  kubernetes:
    provider: k0s
    version: 1.27.4+k0s.0
    infra:
      hosts:
        - ssh:
            address: 52.91.89.114
            keyPath: ./example/aws-tf/aws_private.pem
            port: 22
            user: ubuntu
            role: controller
        - ssh:
            address: 10.0.0.2
            keyPath: ./example/aws-tf/aws_private.pem
            port: 22
            user: ubuntu
          role: worker
    components:
      core:
        ingress:
          enabled: true
          provider: ingress-nginx
          config:
            controller:
              service:
                nodePorts:
                  http: 30000
                  https: 30001
                type: NodePort
      addons:
        - name: example-server
          kind: HelmAddon
          enabled: true
          namespace: default
          chart:
            name: nginx
            repo: https://charts.bitnami.com/bitnami
            version: 15.1.1
            values: |2
              "service":
                "type": "ClusterIP"
```
