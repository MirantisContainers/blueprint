---
title: "Lens AppIQ with k0s on a VM"
draft: false
---

This example shows how use boundless to create a single node k0s cluster using a local VM and install [Lens AppIQ](https://k8slens.dev/appiq.html) on it.

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

Download a copy of the [example Lens AppIQ on k0s blueprint](https://raw.githubusercontent.com/mirantiscontainers/boundless/main/blueprints/k0s-lima-lens-appiq/k0s-lima-lens-appiq.yaml).

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

And the `spec.components.addons.chart.values.auth` section by either setting the environment variables or replacing the values with your own:

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

> Usernames and passwords are sensitive information that should not be stored in the blueprint. They should be passed as environment variables and replaced with your own values. See [Using Variables](/docs/blueprint-reference/variables/) for more information.

#### Apply the blueprint

Apply the blueprint using using `bctl`:

```shell
bctl apply -f lens-appiq-k0s-lima-blueprint.yaml
```

It should print following output to the terminal:

```shell
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

It will take a few moments before the LensAppIQ pods are ready. You can monitor the progress with:

```shell
watch -n 1 kubectl get pods -n shipa-system
```

#### Access the Lens AppIQ UI

Use `kubectl` to temporarily forward ports to the cluster. This will need to be left running in the background:

```bash
kubectl -n shipa-system port-forward service/shipa-ingress-nginx 8080:80
```

Open a browser and navigate to `http://localhost:8080`. You should see the Lens AppIQ UI.

From here, LensAppIQ can be configured using the [official LensAppIQ documentation](https://learn.lenscloud.io/docs/intro-to-lensappiq).

#### Cleanup

To remove the cluster, run:

```shell
bctl reset -f lens-appiq-k0s-lima-blueprint.yaml
```

This will remove all resources created by the blueprint but leave the k0s cluster.
