---
title: "Nginx in Kind"
draft: false
---

This blueprint bootstraps a kind cluster and installs Nginx. This is only a basic setup. For complete configuration options, see the [Nginx documentation](https://artifacthub.io/packages/helm/bitnami/nginx).

#### Prerequisites

Along with `boundless` CLI, the following tools will also be required:

- [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) - required for installing a kind distribution
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - used to forward ports to the cluster

#### Setting up the blueprint

The [example blueprint](https://raw.githubusercontent.com/mirantiscontainers/boundless/main/blueprints/kind-example/kind-example.yaml) for Nginx will bootstrap a `kind` cluster, install `Boundless Operator`, and install Nginx as an addon in the cluster.

The blueprint can be modified for your setup. Change the `spec.components.addons.chart.values` section to set your own values.

#### Apply the blueprint

Once modified, apply the blueprint with `bctl`:

```shell
bctl apply -f kind-example.yaml
```

It should print following output to the terminal:

```shell
INF Applying blueprint kind-example.yaml
Creating cluster "kind-cluster" ...
 ✓ Ensuring node image (kindest/node:v1.27.3) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-kind-cluster"
You can now use your cluster with:

kubectl cluster-info --context kind-kind-cluster

Have a nice day! 👋
INF Waiting for nodes to be ready
INF Installing Boundless Operator
INF Waiting for all pods to be ready
INF Applying Boundless Operator resource
INF Applying Blueprint
INF Finished installing Boundless Operator
```

It will take a few moments before the Nginx pods are ready. You can check the status.

```shell
kubectl get pods -w
```

#### Cleanup

To remove the cluster, run:

```shell
bctl reset -f kind-example.yaml
```

This will remove the cluster and all resources created by the blueprint.