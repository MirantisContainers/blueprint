---
title: "Getting Started with k0s and Terraform"
draft: false
weight: 4
---

This example shows how to create a k0s cluster in AWS using Terraform and then install Boundless Operator on it.

#### Prerequisites

Along with `boundless` CLI, you will also need the following tools installed:

* [k0sctl](https://github.com/k0sproject/k0sctl#installation) - required for installing a k0s distribution
* [terraform](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli) - for creating VMs in AWS

You will also need an AWS account and the `AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`, and `AWS_SESSION_TOKEN` env variables set for the AWS CLI.

#### Create virtual machines on AWS

Creating virtual machines on AWS can be easily done using the [example Terraform scripts](https://github.com/mirantiscontainers/boundless/tree/main/terraform/k0s-in-aws).

After copying the example TF scripts to your local machine, you can create the VMs with the following steps:

1. Create a copy of `terraform.tfvars.example` file with the content similar to:
```
cluster_name = "k0s-cluster"
controller_count = 1
worker_count = 1
cluster_flavor = "m5.large"
region = "us-east-1"
```
2. `terraform init`
3. `terraform apply -auto-approve --var-file="terraform.tfvars.example"`
4. `terraform output --raw k0s_cluster > VMs.yaml`

> To get detailed information about the created VMs, use the AWS CLI:
> ```
> aws ec2 describe-instances --region $(grep "region" terraform.tfvars | awk -F' *= *' '{print $2}' | tr -d '"')
> ```
> Alternatively, for a visual overview:
> Go to the AWS EC2 page. Select the desired region from the dropdown menu at the top-right corner.

#### Install Boundless Operator on `k0s`

1. Download the example blueprint for [creating a k0s cluster in AWS with TF](https://github.com/mirantiscontainers/boundless/tree/main/blueprints/k0s-in-aws-with-tf/k0s-in-aws-with-tf.yaml)

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

5. Monitor the status of the cluster's Kubernetes pods with:
```
watch -n 1 kubectl get pods --all-namespaces
```
It will take a few moments before the pods are ready:
```
NAMESPACE          NAME                                                     READY   STATUS              RESTARTS   AGE
boundless-system   boundless-operator-controller-manager-677b86bdc4-rtjwb   1/2     Running             0          25s
boundless-system   helm-controller-79cc59c76b-vsr2v                         1/1     Running             0          5s
default            helm-install-nginx-mj2qt                                 0/1     ContainerCreating   0          3s
kube-system        coredns-878bb57ff-d4j99                                  1/1     Running             0          40s
kube-system        konnectivity-agent-jkz62                                 1/1     Running             0          39s
kube-system        kube-proxy-22rxj                                         1/1     Running             0          39s
kube-system        kube-router-mrbks                                        1/1     Running             0          39s
kube-system        metrics-server-7f86dff975-gs26h                          0/1     Running             0          40s
```

#### Accessing the cluster

The example app addon can now be accessed through the `http://<controller-node-ip>:6443` URL.

#### Cleanup

Delete the cluster:
``` bash
bctl reset -f k0s-in-aws-with-tf.yaml
```

Delete virtual machines by changing to the example TF folder and running:
``` bash
terraform destroy --auto-approve
```
