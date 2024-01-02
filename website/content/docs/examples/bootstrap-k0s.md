---
title: "Create a k0s cluster in AWS using Terraform"
draft: false
weight: 2
---

This example shows how to create a k0s cluster in AWS using Terraform and then install Boundless Operator on it.

## Prerequisites

Along with `boundless` CLI, you will also need the following tools installed:

* [k0sctl](https://github.com/k0sproject/k0sctl#installation) - required for installing a k0s distribution
* [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) - for creating VMs in AWS

## Create virtual machines on AWS

Creating virtual machines on AWS can be easily done using the [example Terraform scripts](https://github.com/mirantiscontainers/boundless/tree/main/website/terraform/k0s-in-aws).

After copying the example TF scripts to your local machine, you can create the VMs with the following steps:

1. Create a `terraform.tfvars` file with the content similar to:
   ```
   cluster_name = "rs-boundless-test"
   controller_count = 1
   worker_count = 1
   cluster_flavor = "m5.large"
   ```
2. `terraform init`
3. `terraform apply`
4. `terraform output --raw bop_cluster > VMs.yaml`

## Install Boundless Operator on `k0s`

1. Download the example blueprint for [creating a k0s cluster in AWS with TF](/blueprints/k0s-in-aws-with-tf/k0s-in-aws-with-tf.yaml)

2. Edit the `k0s-in-aws-with-tf.yaml` blueprint to set the `spec.kubernetes.infra.hosts` values to those from the `VMs.yaml` file.

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
             keyPath: <TF examples folder>/aws_private.pem
             port: 22
             user: ubuntu
           role: controller
         - ssh:
             address: 10.0.0.2
             keyPath: <TF examples folder>/aws_private.pem
             port: 22
             user: ubuntu
           role: worker
   ```

3. Create the cluster:
   ```shell
   bctl apply -f k0s-in-aws-with-tf.yaml
   ```
   > Note: `bctl apply` adds kube config context to default location and sets it as the _current context_

4. Update the cluster by modifying `k0s-in-aws-with-tf.yaml` and then running:
   ```shell
   bctl update -f k0s-in-aws-with-tf.yaml
   ```

## Cleanup

Delete the cluster:
   ```shell
   bctl reset -f k0s-in-aws-with-tf.yaml
   ```

Delete virtual machines by changing to the example TF folder and running:
   ```bash
   terraform destroy --auto-approve
   ```
