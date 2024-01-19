---
title: "Components"
draft: false
weight: 11
---

The components section of the blueprint is where you can define the different components that you want to install on your cluster. There are two types of components that can be installed: [core](#core) and [addons](#addons).

```yaml
spec:
  components:
    core:
      ingress:
        enabled: true
        provider: ingress-nginx
        config:
          controller:
            service:
              nodePorts:
                http: 30000
                https: 30001
              type: NodePort
    addons:
      - name: example-server
        kind: chart
        enabled: true
        namespace: default
        chart:
          name: nginx
          repo: https://charts.bitnami.com/bitnami
          version: 15.1.1
          values: |
            "service":
              "type": "ClusterIP"
```

## Core

> Including core components with boundless is still under review and may change in the future.

Core components are components that are typically required for a cluster to function and so they are included with boundless. They are defined in the `spec.components.core` section of a blueprint. Each of these components has the option to be disabled if there is a need to replace it with another option.

## Addons

Addons allow you to easily install new software on your cluster. They are defined as an array in the `spec.components.addons` section of a blueprint.
There are two types of addons: [Helm Charts](#helm-charts) and [Manifests](#manifests).

| Field     |                            Description                            |
| :-------- | :---------------------------------------------------------------: |
| name      |               Used to specify the name of the addon               |
| enabled   | Used to specify if the addon should be installed **[true/false]** |
| kind      |      Used to specify the type of addon **[chart/manifest]**       |
| namespace |      Used to specify the namespace of the addon _(optional)_      |

### Helm Charts

Any public Helm chart can be used as an add-on.

The following is an example to add the `grafana` as a chart addon:

```yaml
spec:
  components:
    addons:
      - name: my-grafana
        enabled: true
        kind: chart
        namespace: monitoring
        chart:
          name: grafana
          repo: https://grafana.github.io/helm-charts
          version: 6.58.7
          values: |
            ingress:
              enabled: true
```

| Field         |                                                         Description                                                          |
| :------------ | :--------------------------------------------------------------------------------------------------------------------------: |
| chart         |                                                Used to specify the chart info                                                |
| chart.name    |                                          Used to specify the name of the helm chart                                          |
| chart.repo    |                                          Used to specify the repo of the helm chart                                          |
| chart.version |                                        Used to specify the version of the helm chart                                         |
| chart.values  | Used to specify the [configuration values](https://helm.sh/docs/chart_best_practices/values/) of the helm chart _(optional)_ |

### Manifests

The following is an example of how to add metallb using a manifest as an add-on:

```yaml
spec:
  components:
    addons:
      - name: metallb
        kind: manifest
        enabled: true
        manifest:
          url: "https://raw.githubusercontent.com/kubernetes/website/main/content/en/examples/admin/namespace-dev.yaml"
```

| Field        |               Description               |
| :----------- | :-------------------------------------: |
| manifest     |      Used to specify manifest info      |
| manifest.url | Used to specify the url of the manifest |
