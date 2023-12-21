---
title: "Lens AppIQ with k0s, terraform, and AWS"
draft: false
---

Bootstrap a k0s cluster in AWs with terraform and install Lens AppIQ.

#### Pre-requisite

* SSH Access to either one (single node) or two VMs (one controller and one worker)

For AWS there are `terraform` scripts in the `example/` directory that can be used to create machines on AWS.

Refer to the example TF scripts: https://github.com/mirantiscontainers/boundless-cli/tree/main/example/aws-tf

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

1. Download the [example blueprint](https://raw.githubusercontent.com/mirantiscontainers/boundless/main/blueprints/k0s-lens-appiq/k0s-lens-appiq.yaml) for Lens AppIQ and save it as `lensappiq-k0s-blueprint.yaml`.
2. Edit the `lensappiq-k0s-blueprint.yaml` file to set the `spec.kubernetes.infra.hosts` from the output of `terraform output --raw bop_cluster`.

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
