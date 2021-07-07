#!/bin/bash

wget "https://github.com/hetznercloud/cli/releases/download/v1.24.0/hcloud-linux-amd64.tar.gz"
tar xzf hcloud-linux-amd64.tar.gz

if [ -z "$1" ];
then
	echo "please specify app label"
	exit 1
fi

ids=$(./hcloud image list --selector app=$1 -o noheader -o columns=id | head -n -2)

for i in $ids
do
  ./hcloud image delete $i
done
