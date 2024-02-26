---
title: "kubeconfig"
draft: false
weight: 5
---

`bctl kubeconfig` is used to generate kubeconfig file for the current Blueprint. This command prints the kubeconfig for the underlying cluster specified in the current blueprint. 

## Usage

```bash
bctl kubeconfig [flags]
```

## Flags

| Flag | Description                                                        | Default |
| ---- |--------------------------------------------------------------------| ------- |
| `-h, --help` | Display the help for kubeconfig                                    |
| `-f, --file` | The path to the current blueprint file used to generate kubeconfig | `./boundless.yaml` |
