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
    arch=amd64
    ;;
arm64|aarch64)
    arch=arm64
    ;;
*)
    arch=amd64
    ;;
esac

RELEASE_URL="https://github.com/mirantis/boundless/releases/download/latest/bocli_$opsys_$arch.tar.gz"
curl -sLO "$RELEASE_URL" | tar xvz - -C $where
echo "bocli installed to ${where}/bocli"
