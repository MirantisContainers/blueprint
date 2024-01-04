---
title: "Lens AppIQ with k0s, Terraform, and AWS"
draft: false
---

Bootstrap a k0s cluster in AWs with terraform and install Lens AppIQ.

#### Pre-requisite

Along with `boundless` CLI, the following tools will also be required:

* [AWS](https://aws.amazon.com/cli/) - used to create VMs for running the cluster
* [terraform](https://www.terraform.io/) - used setup VMs in AWS
* [k0sctl](https://github.com/k0sproject/k0sctl#installation) - required for installing a k0s distribution
* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - used to forward ports to the cluster

#### Setting up VMs in AWS

Refer to the [example Terraform scripts](https://github.com/mirantiscontainers/boundless/tree/main/terraform/k0s-in-aws) for creating VMs in AWS.

1. Change to the directory containing the Terraform scripts.
2. Copy the `terraform.tfvars.example` to `terraform.tfvars` and change the content to be similar to:
   ```
   cluster_name = "lens-appiq-boundless"
   controller_count = 1
   worker_count = 1
   cluster_flavor = "m5.large"
   ```
3. `terraform init`
4. `terraform apply`
5. `terraform output --raw bop_cluster > ./VMs.yaml`

#### Setting up the blueprint

Download the [example blueprint](https://raw.githubusercontent.com/mirantiscontainers/boundless/main/blueprints/k0s-lens-appiq/k0s-lens-appiq.yaml) for Lens AppIQ.

Modify the blueprint so that the `spec.kubernetes.infra.hosts` section matches your AWS VMs' IP address, username, SSH port, and SSH credentials. The values can be passed as environment variables or replaced with your own values. For example, the hosts section should match the output from `terraform output --raw bop_cluster`. For example:

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

#### Apply the blueprint

Apply the blueprint using using `bctl`:

```shell
bctl apply -f k0s-lens-appiq.yaml
```

It will take a few moments before the LensAppIQ pods are ready. You can monitor the progress with:

```shell
watch -n 1 kubectl get pods -n shipa-system
```

#### Access the Lens AppIQ UI

Use `kubectl` to temporarily forward ports to the cluster. This will need to be left running in the background:

``` bash
kubectl -n shipa-system port-forward service/shipa-ingress-nginx 8080:80
```

Open a browser and navigate to `http://localhost:8080`. You should see the Lens AppIQ UI.

From here, LensAppIQ can be configured using the [official LensAppIQ documentation](https://learn.lenscloud.io/docs/intro-to-lensappiq).

#### Cleanup

To remove the cluster, run:

```shell
bctl reset -f k0s-lens-appiq.yaml
```

This will remove all resources created by the blueprint but leave the k0s cluster.
