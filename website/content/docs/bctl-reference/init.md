---
title: "init"
draft: false
weight: 5
---

`bctl init` is used to initialize a blueprint file. By default, it will print the blueprint to stdout. This can be redirected to a file for later use. By default, this blueprint will be for a k0s cluster.

## Usage

```bash
bctl init [flags]
bctl init [flags] > blueprint.yaml
```

## Flags

| Flag | Description | Default |
| ---- | ----------- | ------- |
| `-h, --help` | Display the help for init |
| `--kind` | Creates a blueprint that uses a kind cluster | `false` |
