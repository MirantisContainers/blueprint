---
title: "Kubernetes"
draft: false
weight: 11
---

The `kubernetes` field is used to specify the kubernetes provider and version. This field is optional and not specifying it will result in boundless defaulting to the `existing` provider.

There are currently two kubernetes providers that are officially supported by boundless: `kind` and `k0s`.

An `existing` provider can also be used to specify an unsupported kubernetes provider. Using this provider will install boundless and the specified addons on an existing kubernetes cluster but no cluster management will be possible. If a kubeconfig is not specified, boundless will fail to find the existing cluster.

> Using an unsupported kubernetes provider expects that the underlying cluster is being managed outside of boundless.

## k0s

Specifying a `k0s` will create a k0s cluster, install the boundless operator, and install the specified components. The following is an example of how to specify a `k0s` cluster:

```yaml
spec:
  kubernetes:
    provider: k0s
    version: 1.28.5+k0s.0
    infra:
      hosts:
        - ssh:
            address: 10.0.0.1
            keyPath: ""
            port: 22
            user: root
          role: controller
        - ssh:
            address: 10.0.0.2
            keyPath: ""
            port: 22
            user: root
          role: worker
    config: ...
```

| Field                   |                                                                            Description                                                                            |
| :---------------------- | :---------------------------------------------------------------------------------------------------------------------------------------------------------------: |
| provider                |                                      Used to specify the kubernetes provider to use for the cluster **[k0s/kind/existing]**                                       |
| version                 |                                    Used to specify the [version](https://github.com/k0sproject/k0s/releases) of k0s to install                                    |
| infra                   |                                         Used to specify the nodes for the cluster. _(Atleast one node must be specified)_                                         |
| infra.hosts.ssh.address |                                                              Used to specify the address of the node                                                              |
| infra.hosts.ssh.keyPath |                                                          Used to specify the path to the node's ssh key                                                           |
| infra.hosts.ssh.port    |                                                            Used to specify the port of the node's ssh                                                             |
| infra.hosts.ssh.user    |                                                            Used to specify the user of the node's ssh                                                             |
| infra.hosts.role        |                                        Used to specify the role of the node's ssh **[controller/worker/single/localhost]**                                        |
| config                  | Used to specify the [k0s configuration](https://docs.k0sproject.io/v1.23.6+k0s.2/configuration/#configuration-file-reference) to use for the cluster _(optional)_ |

## kind

Specifying a `kind` provider will create a kind cluster, install the boundless operator, and install the specified components. The following is an example of how to specify a `kind` cluster:

```yaml
apiVersion: boundless.mirantis.com/v1alpha1
kind: Blueprint
metadata:
  name: boundless-cluster
spec:
  kubernetes:
    provider: kind
    config: ...
```

| Field    |                                                                  Description                                                                   |
| :------- | :--------------------------------------------------------------------------------------------------------------------------------------------: |
| provider |                             Used to specify the kubernetes provider to use for the cluster **[k0s/kind/existing]**                             |
| config   | Used to specify the [kind configuration](https://kind.sigs.k8s.io/docs/user/configuration/#runtime-config) to use for the cluster _(optional)_ |

## existing

> Using an unsupported kubernetes provider expects that the underlying cluster is being managed outside of boundless.

Specifying an `existing` provider will install boundless and the specified addons on an existing kubernetes cluster. This is the default value that will be used if not `kubernetes` section is provided. The following is an example of how to specify an `existing` cluster:

```yaml
apiVersion: boundless.mirantis.com/v1alpha1
kind: Blueprint
metadata:
  name: boundless-cluster
spec:
  kubernetes:
    provider: existing
    kubeConfig: /home/user/.kube/config
```

> Read more about kubeconfig precedence in the ../kubeconfig section.

| Field      |                                      Description                                       |
| :--------- | :------------------------------------------------------------------------------------: |
| provider   | Used to specify the kubernetes provider to use for the cluster **[k0s/kind/existing]** |
| kubeConfig |  Used to specify the path to the kubeconfig file to use for the cluster _(optional)_   |
