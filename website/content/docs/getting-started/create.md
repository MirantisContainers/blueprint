---
title: "Create a Kind cluster"
draft: false
weight: 1
---

#### Prerequisites

Along with `boundless` CLI, you will also need the following tools:

* [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) - required for installing a kind distribution

#### Create a Kind cluster
1. Generate a sample blueprint file:
   ```shell
   bctl init --kind > blueprint.yaml
   ```
   This will create a blueprints file `blueprint.yaml` with a kind cluster definition, a core ingress component and an addon.

2. Deploy the blueprint
   ```shell
   bctl apply --config blueprint.yaml
   ```

3. Connect to the cluster:
    ```shell
    kubectl cluster-info
    ```
   > `bctl` will create a `kubeconfig` file in the current directory. Use this file to connect to the cluster.


