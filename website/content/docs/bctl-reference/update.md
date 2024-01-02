---
title: "update"
draft: false
weight: 5
---

`bctl update` is used to update a cluster. It is used to update the underlying cluster, update the `boundless-operator`, and update the designated boundless addons according to the provided blueprint.

## Usage

```bash
bctl update [flags]
```

## Flags

| Flag | Description | Default |
| ---- | ----------- | ------- |
| `-h, --help` | Display the help for update |
| `-f, --file` | The path to the blueprint file to use for the update | `./boundless.yaml` |
