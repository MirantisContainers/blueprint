---
title: "status"
draft: false
weight: 5
---

`bctl status` is used to get the status of a blueprint. It will check if the designated components are available.

## Usage

```bash
bctl status [flags]
```

## Flags

| Flag | Description                                                | Default |
| ---- |------------------------------------------------------------| ------- |
| `-h, --help` | Display the help for status                                |
| `-f, --file` | The path to the blueprint file to check the status of      | `./blueprint.yaml` |
| `operator-uri` | The URL or path of the blueprint-operator manifest to use  | `The URL or path of the blueprint-operator manifest to use | `https://github.com/mirantiscontainers/blueprint/releases/latest/download/blueprint-operator.yaml` |
