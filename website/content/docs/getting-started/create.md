---
title: "Create a k0s cluster"
draft: false
weight: 1
---

This section covers the steps needed to created a basic k0s cluster.

#### Prerequisites

Along with `boundless` CLI, you will also need the following tools installed:

* [k0sctl](https://github.com/k0sproject/k0sctl#installation) - required for installing a k0s distribution

#### Download the example blueprint

Download the [example blueprint](https://github.com/mirantiscontainers/boundless/tree/main/blueprints/k0s-example/k0s-example.yaml) to your machine.

This blueprint is setup to install the cluster on your local machine without the need for any additional configuration.

#### Apply the blueprint

Applying the blueprint will create the cluster and install the components defined in the blueprint:

```shell
bctl apply --config k0s-example.yaml
```

#### Verify the cluster is running

Use `kubectl`to verify the cluster is running.

```shell
kubectl cluster-info
```

> `bctl` will create a `kubeconfig` file in the current directory. Use this file to connect to the cluster.
