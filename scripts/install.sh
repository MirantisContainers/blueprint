#!/bin/bash
INSTALL_DIR=/usr/local/bin
REPO_URL="https://github.com/mirantiscontainers/boundless"

# Check if there is sufficient permission for the binary download to succeed later in the script
touch testfile
if [[ $? -ne 0 ]]
then
  echo "Unable to write to directory: $(pwd)"
  echo "Change to a directory with sufficient permissions and retry."
  exit 1
fi
rm testfile

# Determine the version
if [[ ! -n $VERSION ]]
then
  # Get information about the latest release and pull version from the tag in it
  VERSION=`curl -s https://api.github.com/repos/mirantiscontainers/boundless/releases/latest | grep tag_name | tr -s ' ' | cut -d ' ' -f 3 | cut -d '"' -f 2`
  echo "VERSION not set, using latest release: ${VERSION}"
else
  # Make sure it is a valid version
  curl -s https://api.github.com/repos/mirantiscontainers/boundless/releases | grep tag_name | grep $VERSION &> /dev/null
  if [[ $? -ne 0 ]]
  then
    echo "Invalid version specified: ${VERSION}"
    exit 1
  fi
  echo "Using version ${VERSION}"
fi

DOWNLOAD_URL="${REPO_URL}/releases/download/${VERSION}"

# Determine the OS type
opsys=windows
if [[ "$OSTYPE" == linux* ]]; then
  opsys=linux
elif [[ "$OSTYPE" == darwin* ]]; then
  opsys=darwin
fi

# Determine the system architecture
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

BINARY_NAME="bctl_${opsys}_${arch}.tar.gz"
CHECKSUM_NAME="boundless_${VERSION:1}_checksums.txt"

cleanup() {
  rm -f ${BINARY_NAME}
  rm -f ${CHECKSUM_NAME}
}

# Download the binary
BINARY_URL=${DOWNLOAD_URL}/${BINARY_NAME}
echo "Downloading ${BINARY_URL}"
curl -sL ${BINARY_URL} -O
if [[ $? -ne 0 ]]
then
  echo "Downloading binary failed. Exiting without installing"
  cleanup
  exit 1
fi

# Download the checksum
CHECKSUM_URL=${DOWNLOAD_URL}/${CHECKSUM_NAME}
echo "Downloading ${CHECKSUM_URL}..."
curl -sL ${CHECKSUM_URL} -O
if [[ $? -ne 0 ]]
then
  echo "Downloading checksum failed. Exiting without installing"
  cleanup
  exit 1
fi

# Verify the checksum
echo "Verifying checksum..."
# Check shasum depending on which version of shasum is installed
if command -v sha256sum &> /dev/null
then
  sha256sum -c ${CHECKSUM_NAME} --ignore-missing 2>/dev/null
elif command -v shasum &> /dev/null
then
  shasum -a 256 -c ${CHECKSUM_NAME} --ignore-missing 2>/dev/null
else
  echo "Unable to find a shasum command installed. Exiting without installing"
  cleanup
  exit 1
fi

if [[ $? -ne 0 ]]
then
  echo "Checksum verification failed. Exiting without installing"
  cleanup
  exit 1
fi

# Install the binary
sudo tar xzf ${BINARY_NAME} -C ${INSTALL_DIR}
if [[ $? -ne 0 ]]
then
  echo "Installation failed. Exiting without installing"
  cleanup
  exit 1
fi

echo "bctl installed to ${INSTALL_DIR}"
cleanup

