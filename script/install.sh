#!/usr/bin/env bash
set -e
where=/usr/local/bin
opsys=windows
if [[ "$OSTYPE" == linux* ]]; then
  opsys=linux
elif [[ "$OSTYPE" == darwin* ]]; then
  opsys=darwin
fi

# supported values of 'arch': amd64, arm64
case $(uname -m) in
x86_64)
    arch=x86_64
    ;;
arm64|aarch64)
    arch=arm64
    ;;
*)
    arch=amd64
    ;;
esac

RELEASE_URL="https://github.com/mirantis/boundless/releases/latest/download/bocli_${opsys}_${arch}.tar.gz"
echo "Downloading $RELEASE_URL"
curl -sL "$RELEASE_URL" | tar xvz - -C $where
echo "bocli installed to ${where}/bocli"
