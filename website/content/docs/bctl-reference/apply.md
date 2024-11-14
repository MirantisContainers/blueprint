---
title: "apply"
draft: false
weight: 5
---

`bctl apply` is used to apply a configuration to a cluster. It is used to create the underlying cluster, install the `blueprint-operator`, and install the designated blueprint addons.

## Usage

```bash
bctl apply [flags]
```

## Flags

| Flag | Description | Default |
| ---- | ----------- | ------- |
| `-h, --help` | Display the help for apply |
| `-f, --file` | The path to the blueprint file to apply | `./blueprint.yaml` |
| `operator-uri` | The URL or path of the blueprint-operator manifest to use | `The URL or path of the blueprint-operator manifest to use | `https://raw.githubusercontent.com/mirantiscontainers/boundless/main/deploy/static/boundless-operator.yaml` |
