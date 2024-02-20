---
title: "Components"
draft: false
weight: 11
---

The components section of the blueprint is where you can define the different addons that you want to install on your cluster: [addons](#addons).

```yaml
spec:
  components:
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

## Addons

Addons allow you to easily install new software on your cluster. There are two types of addons: [Helm Charts](#helm-charts) and [Manifests](#manifests). 
They are defined as an array in the `spec.components.addons` section of a blueprint. Please refer to this [example](#example) that uses both of these types in addons section.


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
          url: "https://raw.githubusercontent.com/metallb/metallb/v0.14.3/config/manifests/metallb-native.yaml"
```

| Field                   |                                           Description                                            |
|:------------------------|:------------------------------------------------------------------------------------------------:|
| manifest                |                                  Used to specify manifest info                                   |
| manifest.url            |                             Used to specify the url of the manifest                              |
| manifest.values         | Used to specify kustomizations (Optional). More details [here](#kustomize-manifest-based-addons) |


### Example

An example blueprint that uses both [Helm Charts](#helm-charts) and [Manifests](#manifests) in addons section.

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
      - name: metallb
        kind: manifest
        enabled: true
        manifest:
          url: "https://raw.githubusercontent.com/metallb/metallb/v0.14.3/config/manifests/metallb-native.yaml"
```

### Kustomize Manifest based addons

The users can now customize the static resources for URL based Manifest addons. These customization are based on [Kustomize](https://kustomize.io/).

Following kustomize primitives are currently supported:

- [Built-in images transformer](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/transformerconfigs/README.md#images-transformer).
- [Inline patches](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/inlinePatch.md)

The inline patches and images are specified under the field, `values`, in the manifest spec. Please refer to this [example](#manifest-addon-kustomization) that uses both inline patches and images in the manifest addon.

Field                   | Description                                                                                                           |
|:------------------------|:----------------------------------------------------------------------------------------------------------------------|
| manifest.values.patches | Used to specify list of inline patches to add or override manifest objects(Optional) [Example Usage](#inline-patches) |
| manifest.values.images  | Used to specify list of images to be replaced in the manifest(Optional)  [Example Usage](#images)                     |


### Inline Patches

The users can specify one or more inline patches to add or override manifest objects. 

The following example updates the `failureThreshold` of the metallb controller container to `2`.
```yaml
- name: metallb
  kind: "Manifest"
  enabled: true
  namespace: boundless-system
  manifest:
    url: "https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-native.yaml"
    values:
      patches:
      - patch: |-
          apiVersion: apps/v1
          kind: Deployment
          metadata:
            name: controller
            namespace: metallb-system
          spec:
            template:
              spec:
                containers:
                - name: controller
                  livenessProbe:
                    failureThreshold: 2
```

For more examples, please refer to [Kustomize - Inline Patches](https://github.com/kubernetes-sigs/kustomize/blob/master/examples/inlinePatch.md)

### Images

To replace the name of an image in the manifest, the user must specify the image `name`(that is to be replaced), the `new name` and the `new tag`.

```
images:
- name: quay.io/metallb/speaker:v0.13.10
  newName: quay.io/metallb/speaker
  newTag: v0.13.11

```

In the above snippet, the image with the name `quay.io/metallb/speaker:v0.13.10` in the manifest is replaced by `quay.io/metallb/speaker:v0.13.11`.


### Manifest Addon Kustomization

The following manifest addon uses both inline patch and images.

If the metallb addon is created using this example, the metalLB instance that gets installed via BOP uses `v0.13.11` images instead of `v0.13.10`(specified url). And as per the specified inline patch, the `failureThreshold` of livenessProbe for the metalLB controller container is updated to `2`. 

```yaml
- name: metallb
  kind: "Manifest"
  enabled: true
  namespace: boundless-system
  manifest:
    url: "https://raw.githubusercontent.com/metallb/metallb/v0.13.10/config/manifests/metallb-native.yaml"
    values:
      images:
      - name: quay.io/metallb/speaker:v0.13.10
        newName: quay.io/metallb/speaker
        newTag: v0.13.11
      - name: quay.io/metallb/controller:v0.13.10
        newName: quay.io/metallb/controller
        newTag: v0.13.11
      patches:
      - patch: |-
          apiVersion: apps/v1
          kind: Deployment
          metadata:
            name: controller
            namespace: metallb-system
          spec:
            template:
              spec:
                containers:
                - name: controller
                  livenessProbe:
                    failureThreshold: 2
```
