---
title: "Delete a cluster"
draft: false
weight: 3
---

#### Delete a cluster

Deleting a cluster is easily done in a single command:

```shell
bctl reset --config blueprint.yaml
```

You can see that the cluster no longer exists by running:

```shell
kind get clusters
```
And verifying that your cluster is no longer listed.
