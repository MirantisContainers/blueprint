---
title: "Lens AppIQ on a single node k0s"
draft: false
---

## Lens AppIQ on a single node k0s Cluster

Bootstrap a single node k0s cluster and install Lens AppIQ.

#### Bootstrap a single node k0s cluster on Lima VM (Mac) and install Lens AppIQ

> Start Lima VM by running `limactl start`. Refer [Lima documentation](https://github.com/lima-vm/lima#getting-started) for details

Download a copy of the [example blueprint](https://raw.githubusercontent.com/Mirantis/boundless/main/blueprints/lensappiq/lensappiq-k0s-lima-blueprint.yaml) for Lens AppIQ and save it as `lensappiq-k0s-lima-blueprint.yaml`.

Bootstrap a single node k0s cluster and install Lens AppIQ:
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
