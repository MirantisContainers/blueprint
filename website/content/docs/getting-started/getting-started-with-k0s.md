---
title: "Getting started with k0s"
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

Applying the blueprint will create the k0s cluster and install the components defined in the blueprint.

```shell
bctl apply --config k0s-example.yaml
```

#### Verify the cluster is running

Use `kubectl`to verify the cluster is running.

```shell
kubectl cluster-info
```

> `bctl` will create a `kubeconfig` file in the current directory. Use this file to connect to the cluster.

## Update the cluster

This section will cover the steps needed to update an already running cluster.

#### Modify the blueprint

Add a wordpress addon to the `blueprint.yaml`:
```YAML
- name: wordpress
   kind: chart
   enabled: true
   namespace: wordpress
   chart:
      name: wordpress
      repo: https://charts.bitnami.com/bitnami
      version: 18.0.11
```

#### Update the cluster

Update your cluster with the changes made to the blueprint:

```shell
bctl update --config k0s-example.yaml
```

#### Access the wordpress page

Verify that the wordpress addon is installed and running:

```shell
kubectl get pods --namespace wordpress
```

Your output should look similar to:

```shell
NAME                           READY   STATUS      RESTARTS   AGE
helm-install-wordpress-st8rh   0/1     Completed   0          2m58s
wordpress-79d45fc94c-vg7n7     1/1     Running     0          2m49s
wordpress-mariadb-0            1/1     Running     0          2m49s
```

Forward requests to the server by running:

```shell
kubectl port-forward --namespace wordpress wordpress-79d45fc94c-vg7n7 8080:8080
```
> This command will need to be left running in the background. It does not return.

You can then access the wordpress page at http://localhost:8080 in your browser.

## Cleanup

Deleting a cluster is easily done in a single command:

```shell
bctl reset --config k0s-example.yaml
```

This will remove all of the resources created by the blueprint but leave the k0s cluster intact.
