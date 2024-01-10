---
title: "Install"
draft: false
weight: 1
---

### Installing using the script

#### Latest

Installing the latest version of Boundless is as simple as running the following command:

```shell
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mirantiscontainers/boundless/main/scripts/install.sh)"
```
The install script will download the latest version of the boundless cli, verify it with the checksum, and install it to `/usr/local/bin/bctl`.

#### Specific version

If you would like to install a specific version of Boundless, you can specify the version as an environment var for the install script:

```shell
/bin/bash -c "VERSION=<desired version> $(curl -fsSL https://raw.githubusercontent.com/mirantiscontainers/boundless/main/scripts/install.sh)"
```

You can find the different releases on the [releases page](https://github.com/mirantiscontainers/boundless/releases).

### Manual installation

Open the [releases page](https://github.com/mirantiscontainers/boundless/releases) and download the correct binary for your machine along with the boundless_\<version\>_checksums.txt file.
Place both in the same directory and run the following command:

```shell
sha256sum -c boundless_<version>_checksums.txt --ignore-missing 2>/dev/null
```

This will only print `OK` if at least one of the files matches the checksums in the checksum file. Otherwise, it will return an error.

Next you can install the binary on your system using the following `tar` command:

```shell
tar xzf bctl_<os>_<arch>.tar.gz -C /usr/local/bin/
```

### Upgrading the bctl binary version
To upgrade the boundless operator binary version, first perform an [uninstall](#uninstall-boundless) then perform an [installation](#installing-using-the-script).   

### Additional tools

These are tools that are not required to run Boundless, but are useful for interacting with the cluster.

* [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) - useful for interacting with the cluster

### Uninstall Boundless

To uninstall Boundless, simply delete the binary from your system.
```shell
rm /usr/local/bin/bctl
```

### Getting started

Now that you have boundless installed, check out the [getting started guide](../getting-started) to walk through creating your first cluster or go straight to the [examples](docs/examples) section to see some example blueprints.
