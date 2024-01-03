---
title: "Lens AppIQ in Kind"
draft: false
---

This blueprint bootstraps a kind cluster and installs Lens AppIQ. This is only a basic setup. For complete configuration options, see the [Lens AppIQ documentation](https://learn.lenscloud.io/docs/intro-to-lensappiq).

#### Prerequisites

Along with `boundless` CLI, the following tools will also be required:

* [kind](https://kind.sigs.k8s.io/docs/user/quick-start/) - required for installing a kind distribution
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - used to forward ports to the cluster

#### Setting up the blueprint

The [example blueprint](https://raw.githubusercontent.com/mirantiscontainers/boundless/main/blueprints/kind-lens-appiq/kind-lens-appiq.yaml) for Lens AppIQ will bootstrap a `kind` cluster, install `Boundless Operator`, and install LensAppIQ as an addon in the cluster.

The blueprint should be modified for your setup. Specifically, the admin user and password should be changed to more secure values.  Change these in the `spec.components.addons.chart.values.auth` section by either setting the environment variables or replacing the values with your own:

> The password needs to contain letters, numbers, and special characters. An invalid password will cause the installation to fail silently.

```yaml
spec:
  components:
    addons:
      chart:
        values: |
          auth:
            adminUser: "admin" # Required. This should be changed
            adminPassword: "Pass123$" # Required. This should be changed. It must include letters, numbers, and symbols
```

#### Apply the blueprint

Once modified, apply the blueprint with `bctl`:

```shell
bctl apply -f lensappiq-kind-blueprint.yaml
```

It should print following output to the terminal:

```shell
INFO[0000] Installing Kubernetes distribution: kind
INFO[0000] Installing Kubernetes distribution: kind
Creating cluster "lens-appiq-cluster" ...
 ✓ Ensuring node image (kindest/node:v1.27.3) 🖼
 ✓ Preparing nodes 📦
 ✓ Writing configuration 📜
 ✓ Starting control-plane 🕹️
 ✓ Installing CNI 🔌
 ✓ Installing StorageClass 💾
Set kubectl context to "kind-lens-appiq-cluster"
You can now use your cluster with:

kubectl cluster-info --context kind-lens-appiq-cluster --kubeconfig kubeconfig

Not sure what to do next? 😅  Check out https://kind.sigs.k8s.io/docs/user/quick-start/
INFO[0030] Waiting for nodes to be ready
INFO[0045] Installing Boundless Operator
INFO[0047] Waiting for all pods to be ready
INFO[0057] Applying Boundless Operator resource
INFO[0057] Applying Blueprint
INFO[0057] Finished installing Boundless Operator
```

It will take a few moments before the LensAppIQ pods are ready. You can monitor the progress with:

```shell
watch -n 1 kubectl get pods -n shipa-system
```

#### Access the Lens AppIQ UI

Use `kubectl` to temporarily forward ports to the cluster. This will need to be left running in the background:

``` bash
kubectl -n shipa-system port-forward service/shipa-ingress-nginx 8080:80
```

Open a browser and navigate to `http://localhost:8080`. You should see the Lens AppIQ UI.

From here, LensAppIQ can be configured using the [official LensAppIQ documentation](https://learn.lenscloud.io/docs/intro-to-lensappiq).

#### Cleanup

To remove the cluster, run:

```shell
bctl reset -f lensappiq-kind-blueprint.yaml
```

This will remove the cluster and all resources created by the blueprint.
