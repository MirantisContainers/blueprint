# Lens AppIQ on Kind Cluster

This blueprint bootstraps a kind cluster and installs Lens AppIQ.

## Pre-req
* [Install Boundless CLI `bctl`](https://github.com/Mirantis/boundless/blob/main/README.md#pre-requisite)

## Bootsrap a Kind cluster with Lens AppIQ

## Installation 

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

Watch for `Lens AppIQ` installation to complete

```shell

```

### Delete Lens AppIQ 

```shell
delete helmcharts.helm.cattle.io -n shipa-system shipa 
```