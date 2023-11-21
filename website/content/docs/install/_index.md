---
title: "Install"
draft: false
weight: 1
---

### Installing using the script

Installing the latest version of Boundless is as simple as running the following command:

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mirantis/boundless/main/script/install.sh)"
```
This install script will download the latest version and install it on your system.

### Installing manually

Open the [latest releases page](https://github.com/Mirantis/boundless/releases/latest) and download the correct binary for your machine along with the boundless_<version>_checksums.txt file.
Place both in the same directory and run the following command:

```shell
sha256sum -c boundless_<version>_checksums.txt
```

Look for the line that says "OK" with your correct binary name. Install the binary with the following command:

```shell
tar xvz -C /usr/local/bin/ -f bctl_<os>_<arch>.tar.gz
```

### Additional tools

These are tools that are not required to run Boundless, but are useful for interacting with the cluster.

* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - useful for interacting with the cluster

### Uninstall Boundless

To uninstall Boundless, simply delete the binary from your system.
```shell
rm /usr/local/bin/bctl
```

### Getting started

Now that you have boundless installed, check out the [getting started guide](/docs/getting-started) to walk through creating your first cluster or go straight to the [examples](/docs/examples) section to see some example blueprints.
