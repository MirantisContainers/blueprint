---
title: "Getting Started with k0s and libvirt"
draft: false
weight: 4
---

This example shows how to create a single-node k0s cluster in a local VM using Terraform and libvirt. The boundless-operator may then be installed.

#### Prerequisites

Along with `boundless` CLI, you will also need the following tools installed:

* [k0sctl](https://github.com/k0sproject/k0sctl#installation) - required for installing a k0s distribution
* [terraform](https://www.terraform.io/) - for creating VMs
* [libvirt](https://libvirt.org/) - required for running the local VM
* [terraform-provider-libvirt](https://registry.terraform.io/providers/dmacvicar/libvirt) - required for provisioning libvirt VMs through terraform

You will also need an SSH key for authentication with the created VM.

#### Create virtual machines

Creating virtual machines can be done using the [example Terraform scripts](https://github.com/mirantiscontainers/boundless/tree/main/terraform/k0s-libvirt).

After copying the example TF scripts to your local machine, you can create the VMs with the following steps:

1. Create a `terraform.tfvars` file with content similar to:
```
cluster_name = "boundless-cluster"
cores = 2
mem_size = "2048"
disk_size = 20
user_account = "user"
ssh_public_key = "ssh-rsa AAAEXAMPLE user@example.com"
ssh_key_path = "/home/user/.ssh/id_rsa"
```
2. `terraform init`
3. `terraform plan`
3. `terraform apply`
4. `terraform output --raw k0s_cluster > cluster.yaml`

> To get detailed information about the created VMs, you can use [virsh](https://www.libvirt.org/manpages/virsh.html):
> ```
> virsh machine list
> ```

#### Install Boundless Operator on `k0s`

1. Verify or edit the blueprint created in the previous step, `cluster.yaml`

2. Create the cluster:

```shell
bctl apply -f cluster.yaml
```


> Note: `bctl apply` adds kube config context to default location and sets it as the _current context_


3. Update the cluster by modifying `cluster.yaml` and then running:
```shell
bctl update -f cluster.yaml
```

4. Monitor the status of the cluster's Kubernetes pods with:
```
watch -n 1 kubectl get pods --all-namespaces
```

#### Accessing the cluster

The example app addon can now be accessed through the `http://<vm-node-ip>:6443` URL.

#### Cleanup

Delete the cluster:
``` bash
bctl reset -f cluster.yaml
```

Delete virtual machines by changing to the example TF folder and running:
``` bash
terraform destroy
```
