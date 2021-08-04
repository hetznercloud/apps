#!/bin/bash
set -e

wget "https://github.com/hetznercloud/cli/releases/download/v1.26.0/hcloud-linux-amd64.tar.gz"

sha256sum -c "./.github/checksum.sha256"

tar xzf hcloud-linux-amd64.tar.gz

if [ -z "$1" ];
then
	echo "please specify app label"
	exit 1
fi

##
# Remove old snapshots, keep last 2
ids=$(./hcloud image list --selector app=$1 -o noheader -o columns=id | head -n -2)

for i in $ids
do
  ./hcloud image delete $i
done

##
# Remove old snapshots in case of an workflow failure in the past
keys=$(./hcloud ssh-key list | grep packer | awk '{ print $1 }')
for k in $keys
do
  ./hcloud ssh-key delete $k
done
