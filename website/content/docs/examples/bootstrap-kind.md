---
title: "Bootstrap a Kind cluster"
draft: false
weight: 2
---

This example shows how to create a kind cluster using a blueprint with the Boundless Operator and an example server installed on it.

#### Prerequisites

Along with `boundless` CLI, you will also need the following tools:

* [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) - required for installing a kind distribution

#### Create a Kind blueprint
Generate a sample blueprint file using the built in `init` command:

```shell
bctl init --kind > blueprint.yaml
```
This will create a blueprint file `blueprint.yaml` with a kind cluster definition, a core ingress component and an addon.

#### Deploy the blueprint
```shell
bctl apply --config blueprint.yaml
```

#### Connect to the cluster:
```shell
kubectl cluster-info
```

> `bctl` will create a `kubeconfig` file in the current directory. Use this file to connect to the cluster.

## Update the cluster

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

Update your cluster with the modified blueprint:

```shell
bctl update --config blueprint.yaml
```

Verify that the wordpress addon is installed and running:

```shell
kubectl get pods --namespace wordpress
```

You output will look similar to the following:

```shell
NAME                           READY   STATUS      RESTARTS   AGE
helm-install-wordpress-st8rh   0/1     Completed   0          2m58s
wordpress-79d45fc94c-vg7n7     1/1     Running     0          2m49s
wordpress-mariadb-0            1/1     Running     0          2m49s
```

#### Access the wordpress page

To connect to the cluster, forward requests to the server by running:

```shell
kubectl port-forward --namespace wordpress wordpress-79d45fc94c-vg7n7 8080:8080
```
> This command will need to be left running in the background. It does not return.

You can then access the wordpress page at http://localhost:8080 in your browser.

## Delete a cluster

Deleting a cluster is easily done in a single command:

```shell
bctl reset --config blueprint.yaml
```

You can see that the cluster no longer exists by running:

```shell
kind get clusters
```

And verifying that your cluster is no longer listed.
