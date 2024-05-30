#!/usr/bin/env bash
set -e

if [ $# != 2 ]; then
    echo "Usage: $0 <app> <arch>"
    echo "* app: subfolder in apps/hetzner/"
    echo "* arch: either amd64 or arm64"
    echo ""
    exit 1
fi

APP=$1
ARCH=$2

if [ -z "$HCLOUD_TOKEN" ]; then
  echo "No HCLOUD_TOKEN set"
  exit 1
fi

GIT_REVISION=`git symbolic-ref HEAD 2> /dev/null | cut -b 12-`-`git log --pretty=format:\"%h\" -1 | xargs`
SNAPSHOT_NAME=${APP}-${ARCH}-${GIT_REVISION}-${CI_PIPELINE_ID}

export HCLOUD_SERVER_LOCATION="fsn1"

# Target architecture for the new VM created by Packer
if [ "$ARCH" == "amd64" ]; then
	export HCLOUD_SERVER_TYPE_BEFORE_UPSCALE="cx11"
	export HCLOUD_SERVER_TYPE="cpx21"
fi
if [ "$ARCH" == "arm64" ]; then
    export HCLOUD_SERVER_TYPE_BEFORE_UPSCALE="cax11"
	export HCLOUD_SERVER_TYPE="cax21"
fi

# Local architecture (used to execute hcloud and packer)
LOCAL_ARCH='amd64'
if [ $(uname -i) == 'aarch64' ]; then
    LOCAL_ARCH='arm64'
fi

if [ -z "$CI_JOB_ID" ]; then
    export CI_JOB_ID=`date +%s`
fi

# Download dependencies
rm -rf hcloud || true
mkdir hcloud
cd hcloud
wget -q "https://cs1.hetzner.de/cloud/hcloud-linux-${LOCAL_ARCH}.tar.gz"
tar xzf hcloud-linux-${LOCAL_ARCH}.tar.gz
export PATH=$PATH:$(pwd)

cd ..
rm -rf packer || true
mkdir packer
cd packer
wget -q "https://releases.hashicorp.com/packer/1.10.3/packer_1.10.3_linux_${LOCAL_ARCH}.zip"
unzip packer_1.10.3_linux_${LOCAL_ARCH}.zip
export PATH=$PATH:$(pwd)
cd ..

# Check syntax
packer validate -syntax-only apps/hetzner/${APP}/

# Create VMs, install one-click-apps, create snapshot
packer build -color=false -on-error=abort -var snapshot_name=${SNAPSHOT_NAME} apps/hetzner/${APP}/

# Tag the resulting image with the application it contains
snapshot_id=$(hcloud image list -o noheader -o "columns=id,description" | grep "${SNAPSHOT_NAME}" | awk '{print $1}')
hcloud image add-label $snapshot_id app=${APP}

# Cleanup any VMs, etc. that might be remaining
./cleanup.sh ${APP}
