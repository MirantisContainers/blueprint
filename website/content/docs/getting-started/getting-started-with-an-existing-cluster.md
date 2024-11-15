---
title: "Getting Started with an existing cluster"
draft: false
weight: 3
---

This example shows how to start using blueprint on an existing cluster.

## Install the blueprint operator

Install Blueprint Operator

```shell
kubectl apply -f https://github.com/mirantiscontainers/blueprint/releases/latest/download/blueprint-operator.yaml
```

Wait for blueprint operator to be ready

```shell
kubectl get deploy -n blueprint-system
```

Once running, you should see something like this:

```shell
NAME                                    READY   UP-TO-DATE   AVAILABLE   AGE
blueprint-operator-controller-manager   1/1     1            1           33s
```

## Setting up a blueprint

Create a blueprint file `blueprint.yaml` with the following:

```yaml
apiVersion: blueprint.mirantis.com/v1alpha1
kind: Blueprint
metadata:
  name: blueprint-cluster
spec:
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
            service:
              type: ClusterIP
```

> The above example installs an example server addon by specifying a helm chart

## Apply the blueprint

Apply the blueprint

```shell
kubectl apply -f blueprint.yaml
```

After a while, the components specified in the blueprint will be installed:

```shell
kubectl get deploy
```

```
NAME    READY   UP-TO-DATE   AVAILABLE   AGE
nginx   1/1     1            1           35s
```
