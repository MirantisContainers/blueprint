---
title: "Lens AppIQ"
draft: false
---

# Lens AppIQ Blueprint

Lens AppIQ Boundless Blueprint Tech Preview.

## Lens AppIQ on Kind Cluster

This blueprint bootstraps a kind cluster and installs Lens AppIQ.

### Pre-req
* [Install Boundless CLI `bctl`](https://github.com/Mirantis/boundless/blob/main/README.md#pre-requisite)

### Bootsrap a Kind cluster with Lens AppIQ

### Installation

Set admin user's email and password.
```shell
export LAIQ_USER=<Admin User Email>
export LAIQ_PASSWORD=<Admin user password>
```

```shell
bctl apply -f lensappiq-kind-blueprint.yaml
```

> Above command bootstraps a `kind` cluster, install `Boundless Operator`, once Boundless Operator is up, it installs addons from the blueprint.

```shell
$ bctl apply -c lensappiq-kind-blueprint.yaml
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

## Lens AppIQ on k0s Cluster

Bootstrap a k0s cluster and install Lens AppIQ.


#### Pre-requisite

* SSH Access to either one (single node) or two VMs (one controller and one worker)

For AWS there are `terraform` scripts in the `example/` directory that can be used to create machines on AWS.

Refer to the example TF scripts: https://github.com/Mirantis/boundless-cli/tree/main/example/aws-tf

1. `cd example/aws-tf`
2. Create a `terraform.tfvars` file with the content similar to:
   ```
   cluster_name = "rs-boundless-test"
   controller_count = 1
   worker_count = 1
   cluster_flavor = "m5.large"
   ```
3. `terraform init`
4. `terraform apply`
5. `terraform output --raw bop_cluster > ./blueprint.yaml`

#### Install blueprint on `k0s`

1. Edit the `lensappiq-k0s-blueprint.yaml` file to set the `spec.kubernetes.infra.hosts` from the output of `terraform output --raw bop_cluster`.

   The `spec.kubernetes.infra.hosts` section should look similar to:
   ```yaml
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
   ```

> For Single node configuration (such as when running for testing on Lima VM on Mac or a QEMU VM on linux), remove worker ssh entry and change `role: controller` to `role: single`

2. Bootstrap k0s on provided VMs and install Lens AppIQ
   Bootstrap a controller and worker k0s nodes and install Lens AppIQ:
   ```shell
   bctl apply --config lensappiq-k0s-blueprint.yaml
   ```
   Bootstrap a single node k0s cluster on Lima VM (Mac) and install Lens AppIQ

> Start Lima VM by running `limactl start`. Refer [Lima documentation](https://github.com/lima-vm/lima#getting-started) for details

   ```shell
   lensappiq-k0s-lima-blueprint.yaml
   ```

It should print following output on your terminal:

```shell
$ bctl apply -c lensappiq-k0s-lima-blueprint.yaml
INFO[0000] Installing Kubernetes distribution: k0s

⠀⣿⣿⡇⠀⠀⢀⣴⣾⣿⠟⠁⢸⣿⣿⣿⣿⣿⣿⣿⡿⠛⠁⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀█████████ █████████ ███
⠀⣿⣿⡇⣠⣶⣿⡿⠋⠀⠀⠀⢸⣿⡇⠀⠀⠀⣠⠀⠀⢀⣠⡆⢸⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀███          ███    ███
⠀⣿⣿⣿⣿⣟⠋⠀⠀⠀⠀⠀⢸⣿⡇⠀⢰⣾⣿⠀⠀⣿⣿⡇⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀███          ███    ███
⠀⣿⣿⡏⠻⣿⣷⣤⡀⠀⠀⠀⠸⠛⠁⠀⠸⠋⠁⠀⠀⣿⣿⡇⠈⠉⠉⠉⠉⠉⠉⠉⠉⢹⣿⣿⠀███          ███    ███
⠀⣿⣿⡇⠀⠀⠙⢿⣿⣦⣀⠀⠀⠀⣠⣶⣶⣶⣶⣶⣶⣿⣿⡇⢰⣶⣶⣶⣶⣶⣶⣶⣶⣾⣿⣿⠀█████████    ███    ██████████
k0sctl v0.16.0 Copyright 2023, k0sctl authors.
Anonymized telemetry of usage will be sent to the authors.
By continuing to use k0sctl you agree to these terms:
https://k0sproject.io/licenses/eula
INFO ==> Running phase: Connect to hosts
INFO [ssh] 127.0.0.1:60022: connected
INFO ==> Running phase: Detect host operating systems
INFO [ssh] 127.0.0.1:60022: is running Ubuntu 23.10
INFO ==> Running phase: Acquire exclusive host lock
INFO ==> Running phase: Prepare hosts
INFO ==> Running phase: Gather host facts
INFO [ssh] 127.0.0.1:60022: using lima-default as hostname
INFO [ssh] 127.0.0.1:60022: discovered eth0 as private interface
INFO [ssh] 127.0.0.1:60022: discovered 192.168.5.15 as private address
INFO ==> Running phase: Validate hosts
INFO ==> Running phase: Gather k0s facts
INFO ==> Running phase: Validate facts
INFO ==> Running phase: Download k0s on hosts
INFO [ssh] 127.0.0.1:60022: downloading k0s v1.28.3+k0s.0
INFO ==> Running phase: Install k0s binaries on hosts
INFO ==> Running phase: Configure k0s
WARN [ssh] 127.0.0.1:60022: generating default configuration
INFO [ssh] 127.0.0.1:60022: validating configuration
INFO [ssh] 127.0.0.1:60022: configuration was changed, installing new configuration
INFO ==> Running phase: Initialize the k0s cluster
INFO [ssh] 127.0.0.1:60022: installing k0s controller
INFO [ssh] 127.0.0.1:60022: waiting for the k0s service to start
INFO [ssh] 127.0.0.1:60022: waiting for kubernetes api to respond
INFO ==> Running phase: Release exclusive host lock
INFO ==> Running phase: Disconnect from hosts
INFO ==> Finished in 1m31s
INFO k0s cluster version v1.28.3+k0s.0 is now installed
INFO[0092] Waiting for nodes to be ready
INFO[0142] Installing Boundless Operator
INFO[0142] Waiting for all pods to be ready
INFO[0172] Applying Boundless Operator resource
INFO[0172] Applying Blueprint
INFO[0172] Finished installing Boundless Operator
```

> Wait for Lens AppIQ to come up
```shell
kubectl wait --namespace shipa-system \
                --for=condition=ready pod \
                --selector=app.kubernetes.io/managed-by=LensApps \
                --timeout=180s
```

3. Connect to the cluster:
   ```shell
   export KUBECONFIG=./kubeconfig
   kubectl get pods
   ```
   Note: `bctl` will create a `kubeconfig` file in the current directory.
   Use this file to connect to the cluster.


# Access Lens AppIQ
## Install Lens AppIQ CLI
See [Lens AppIQ CLI installation guide](https://learn.lenscloud.io/docs/downloading-the-lensapps-client) for details.

```shell
curl -s https://storage.googleapis.com/shipa-client/install-cloud-cli.sh | bash
```

## Setup route to access Lens AppIQ API
If Lens AppIQ serviceType is ClusterIP, you need to setup route to the nginx-ingress cluster ip:

**Linux**
```shell
sudo ip route add $(kubectl get service shipa-ingress-nginx -n shipa-system -o jsonpath='{.spec.clusterIP}') via $(docker container inspect lens-appiq-cluster-control-plane --format '{{ .NetworkSettings.Networks.kind.IPAddress }}')
```

**Mac**
```shell
sudo route -n add -net $(kubectl get service shipa-ingress-nginx -n shipa-system -o jsonpath='{.spec.clusterIP}')  $(docker container inspect lens-appiq-cluster-control-plane --format '{{ .NetworkSettings.Networks.kind.IPAddress }}')
```
## Login to Lens AppIQ

Setup Lens AppIQ Target
```shell
lapps target add laiq $(kubectl get service shipa-ingress-nginx -n shipa-system -o jsonpath='{.spec.clusterIP}')
```
Login using `$LAIQ_USER` and `$LAIQ_PASSWORD`
```shell
lapps login $LAIQ_USER
```

## Open Lens AppIQ Dashboard in the browser
```shell
lapps dashboard open
```

# Delete Lens AppIQ installation

```shell
bctl delete -c lensappiq-kind-blueprint.yaml
# Team workaround
delete helmcharts.helm.cattle.io -n shipa-system shipa
```
