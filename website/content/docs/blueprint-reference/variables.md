---
title: "Variables"
draft: false
weight: 1
---

Blueprints support using environment variables in the `blueprint.yaml` file. This allows you to use the same blueprint in different environments without having to change the blueprint itself. These variables should be used as part of best practices for sensitive information.

## Using Variables

Using a variable is as simple as defining it in your environment

```bash
export EXAMPLE_VERSION="15.1.1"
```

and then using it in your blueprint.yaml file

```yaml
apiVersion: boundless.mirantis.com/v1alpha1
kind: Blueprint
metadata:
  name: variable-example
spec:
  kubernetes:
    provider: kind
  components:
    addons:
      - name: example-server
        kind: HelmAddon
        enabled: true
        namespace: default
        chart:
          name: nginx
          repo: https://charts.bitnami.com/bitnami
          version: ${EXAMPLE_VERSION}
          values: |
            service:
              type: ClusterIP
```

That's it! Now you can use the same blueprint in different environments without having to change the blueprint itself.
