---
title: "Nginx with k0s on a VM"
draft: false
---

This example shows how use boundless to create a single node k0s cluster using a local VM and install [Nginx](https://artifacthub.io/packages/helm/bitnami/nginx) on it.

Popular VMs include

- [lima VM](https://github.com/lima-vm/lima)
- [multipass VM](https://multipass.run/)

Any type of VM can be used to run boundless. If you choose to use another type of VM, you will need to locate the VM's IP address, username, SSH port, and SSH credentials. This example uses a lima VM.

#### Prerequisites

Along with `boundless` CLI, the following tools will also be required:

- [k0sctl](https://github.com/k0sproject/k0sctl#installation) - required for installing a k0s distribution
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - used to forward ports to the cluster

#### Creating the VM

Start a Lima VM by running `limactl start`. Refer the [Lima documentation](https://github.com/lima-vm/lima#getting-started) for more information.

#### Setting up the blueprint

Download a copy of the [example Nginx on k0s blueprint](https://raw.githubusercontent.com/mirantiscontainers/boundless/main/blueprints/k0s-example/k0s-example.yaml).

Modify the blueprint so that the `spec.kubernetes.infra.hosts` section matches your VM's IP address, username, SSH port, and SSH credentials. The values can be passed as environment variables or replaced with your own values. For example, if you are using a Lima VM, the section should look like this:

```yaml
hosts:
  - ssh:
    address: 127.0.0.1 # Change this to your VM's IP address
    keyPath: $HOME/.lima/_config/${USER} # Change this to your VM's key path
    port: 60022 # Change this to your VM's SSH port
    user: $USER # Change this to your VM's username
  role: single
```

You can also modify the `spec.components.addons.chart.values` section. For complete configuration options, see the [Nginx documentation](https://artifacthub.io/packages/helm/bitnami/nginx).

#### Apply the blueprint

Apply the blueprint using using `bctl`:

```shell
bctl apply -f k0s-example.yaml
```

It will take a few moments before the Nginx pods are ready. You can monitor the progress with:

```shell
watch -n 1 kubectl get pods
```

#### Cleanup

To remove the cluster, run:

```shell
bctl reset -f k0s-example.yaml
```

This will remove all resources created by the blueprint but leave the k0s cluster.