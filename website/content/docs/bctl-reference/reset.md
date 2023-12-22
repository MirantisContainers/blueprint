---
title: "reset"
draft: false
weight: 5
---

`bctl reset` is used to reset a cluster. It is used to remove the underlying cluster, uninstall the `boundless-operator`, and uninstall the designated boundless addons.

## Usage

```bash
bctl reset [flags]
```

## Flags

| Flag | Description | Default |
| ---- | ----------- | ------- |
| `-h, --help` | Display the help for reset |
| `-f, --file` | The path to the blueprint file to reset | `./boundless.yaml` |
