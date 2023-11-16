---
title: "Create a k0s cluster in AWS using Terraform"
draft: false
weight: 2
---

#### Prerequisites

Along with `boundless` CLI, you will also need the following tools:

* [k0sctl](https://github.com/k0sproject/k0sctl#installation) - required for installing a k0s distribution
* [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) - for creating VMs in AWS

#### Create virtual machines on AWS

There are `terraform` scripts in the `example/` directory that can be used to create machines on AWS.

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

#### Install Boundless Operator on `k0s`

1. Generate a basic blueprint file:
   ```shell
   bctl init > blueprint.yaml
   ```
   This will create a blueprints file `blueprint.yaml` with k0s specific kubernetes definition and addons that get installed in specific namespace. See a [sample here](#sample-blueprint-for-k0s-cluster)

2. Now, edit the `blueprint.yaml` file to set the `spec.kubernetes.infra.hosts` from the output of `terraform output --raw bop_cluster`.

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
3. Create the cluster:
   ```shell
   bctl apply --config blueprint.yaml
   ```
4. Connect to the cluster:
   ```shell
   export KUBECONFIG=./kubeconfig
   kubectl get pods
   ```
   Note: `bctl` will create a `kubeconfig` file in the current directory.
   Use this file to connect to the cluster.
5. Update the cluster by modifying `blueprint.yaml` and then running:
   ```shell
   bctl update --config blueprint.yaml
   ```
6. Delete the cluster:
   ```shell
   bctl reset --config blueprint.yaml
   ```
7. Delete virtual machines:
   ```bash
   cd example/aws-tf
   terraform destroy --auto-approve
