---
title: "upgrade"
draft: false
weight: 5
---

`bctl upgrade` is used to upgrade the boundless operator on a cluster.

## Usage

```bash
bctl upgrade [flags]
```

## Flags

| Flag | Description | Default |
| ---- | ----------- | ------- |
| `-h, --help` | Display the help for update |
| `-f, --file` | The path to the blueprint file to use for the upgrade | `./boundless.yaml` |
| `operator-uri` | The URL or path of the boundless-operator manifest to use | `https://raw.githubusercontent.com/mirantiscontainers/boundless/main/deploy/static/boundless-operator.yaml` |
