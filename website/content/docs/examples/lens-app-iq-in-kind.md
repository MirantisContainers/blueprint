---
title: "Lens AppIQ in Kind"
draft: false
---

This blueprint bootstraps a kind cluster and installs Lens AppIQ.

### Bootsrap a Kind cluster with Lens AppIQ

#### Set ENV variables

Set admin user's email and password.
```shell
export LAIQ_USER=<Admin User Email>
export LAIQ_PASSWORD=<Admin user password>
```

#### Apply the blueprint

Our [example blueprint](https://raw.githubusercontent.com/Mirantis/boundless/main/blueprints/lensappiq/lensappiq-kind-blueprint.yaml) for Lens AppIQ will bootstrap a `kind` cluster, install `Boundless Operator`, install addons from the blueprint. Once you've downloaded the blueprint, apply it with `bctl`:

```shell
bctl apply -c lensappiq-kind-blueprint.yaml
```

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

Wait for `Lens AppIQ` installation to complete.
```shell
kubectl wait --namespace shipa-system \
                --for=condition=ready pod \
                --selector=app.kubernetes.io/managed-by=LensApps \
                --timeout=180s
```
