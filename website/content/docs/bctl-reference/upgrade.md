---
title: "upgrade"
draft: false
weight: 5
---

`bctl upgrade` is used to upgrade the blueprint operator on a cluster.

## Usage

```bash
bctl upgrade [flags]
```

## Flags

| Flag | Description | Default |
| ---- | ----------- | ------- |
| `-h, --help` | Display the help for update |
| `-f, --file` | The path to the blueprint file to use for the upgrade | `./blueprint.yaml` |
| `operator-uri` | The URL or path of the blueprint-operator manifest to use | `https://github.com/mirantiscontainers/blueprint/releases/latest/download/blueprint-operator.yaml` |
