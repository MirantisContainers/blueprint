---
title: "Update a cluster"
draft: false
weight: 2
---

This section will cover the steps needed to update an already running cluster.

#### Modify the blueprint

Add a wordpress addon to the `blueprint.yaml`:
```YAML
- name: wordpress
   kind: chart
   enabled: true
   namespace: wordpress
   chart:
      name: wordpress
      repo: https://charts.bitnami.com/bitnami
      version: 18.0.11
```

#### Update the cluster

Update your cluster with the changes made to the blueprint:

```shell
bctl update --config k0s-example.yaml
```

#### Access the wordpress page

Verify that the wordpress addon is installed and running:

```shell
kubectl get pods --namespace wordpress
```

Your output should look similar to:

```shell
NAME                           READY   STATUS      RESTARTS   AGE
helm-install-wordpress-st8rh   0/1     Completed   0          2m58s
wordpress-79d45fc94c-vg7n7     1/1     Running     0          2m49s
wordpress-mariadb-0            1/1     Running     0          2m49s
```

Forward requests to the server by running:

```shell
kubectl port-forward --namespace wordpress wordpress-79d45fc94c-vg7n7 8080:8080
```
> This command will need to be left running in the background. It does not return.

You can then access the wordpress page at http://localhost:8080 in your browser.
