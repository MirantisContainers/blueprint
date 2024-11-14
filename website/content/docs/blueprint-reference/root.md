---
title: "Root"
draft: false
weight: 10
---

The root fields are the top level fields in a blueprint. These fields are used to configure the cluster and the components that will be installed on the cluster. Their are four root fields:
`apiVersion`, `kind`, `metadata`, and `spec`.

The following is an example of a blueprint with only the root fields:

```yaml
apiVersion: blueprint.mirantis.com/v1alpha1
kind: Blueprint
metadata:
  ...
  ...
spec:
  ...
  ...
```

## apiVersion

The `apiVersion` field is used to specify the blueprint version. This field is required and must be set to one of the versions found in the [blueprint repo](https://github.com/MirantisContainers/blueprint).

## kind

The `kind` field is used to specify the type of resource. This field is required and must be set to `Blueprint`.

## metadata

The `metadata` field is used to specify the name of the cluster. This field is optional and can be used for any additional information you want to add to the cluster.

| Field |               Description               |
| :---- | :-------------------------------------: |
| name  | Used to specify the name of the cluster |

## spec

The `spec` field is used to specify the configuration of the cluster. This field is required and must be set for a valid configuration.

This is where the majority of the configuration for the cluster will be done. The `spec` field contains the following fields:

| Field                       |                                                               Description                                                               |
| :-------------------------- | :-------------------------------------------------------------------------------------------------------------------------------------: |
| [kubernetes](../kubernetes) |         Used to specify the kubernetes provider and version. This field is required and must be set for a valid configuration.          |
| [components](../components) | Used to specify the components that will be installed on the cluster. This field is required and must be set for a valid configuration. |
