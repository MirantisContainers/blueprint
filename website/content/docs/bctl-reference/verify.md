---
title: "verify"
draft: false
weight: 5
---

`bctl verify` is used to verify a blueprint file. It can then be used to verify modifications or additions of new addons to the cluster. Verification is not entirely client-side, as when verifying certain addons cluster resources will be temporarily created.

## Pre-Requisites
This command requires a barebone cluster to already be created via `apply` or otherwise.

## Usage

```bash
bctl verify [flags]
```

## Flags

| Flag             | Description                              | Default            |
|------------------|------------------------------------------|--------------------|
| `-h, --help`     | Display the help for verify              |
| `-f, --file`     | The path to the blueprint file to verify | `./blueprint.yaml` |
| `-l, --logLevel` | log level to use                         | info               |