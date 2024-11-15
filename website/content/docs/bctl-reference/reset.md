---
title: "reset"
draft: false
weight: 5
---

`bctl reset` is used to reset a cluster. It is used to remove the underlying cluster, uninstall the `blueprint-operator`, and uninstall the designated blueprint addons.

## Usage

```bash
bctl reset [flags]
```

## Flags

| Flag | Description | Default |
| ---- | ----------- | ------- |
| `-h, --help` | Display the help for reset |
| `-f, --file` | The path to the blueprint file to reset | `./blueprint.yaml` |
