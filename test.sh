#!/bin/bash
set -ueo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")"

function usage() {
  cat <<USAGE
test.sh <app> <snapshot>
=======
This script creates a new server based on a given snapshot and runs some
simple app-specific smoke tests on it.

The tests are a test.sh shell script placed in each app configuration dir,
which is is scp'd to the created server and run from there.

USAGE
}

if [[ "${1:-}" == "" || "${2:-}" == "" ]]; then
  usage
  exit 1
fi

app=$1
snapshot_id=$2

if ! hcloud image describe $snapshot_id >/dev/null 2>&1; then
  snapshot_id=$(hcloud image list -o noheader -o "columns=id,description" |  grep $snapshot_id | awk '{print $1}' || true)
fi

if ! hcloud image describe $snapshot_id >/dev/null 2>&1; then
  usage
  echo "ERROR: couldn't resolve snapshot \"$2\""
  exit 1
fi

echo running $app tests on snapshot ID $snapshot_id

test_prefix="apps-$app-$snapshot_id-test"

function cleanup() {
  key_cleanup="hcloud ssh-key delete $test_prefix"
  server_cleanup="hcloud server delete $test_prefix"

  if [[ -n "${SKIP_CLEANUP:-}" ]]; then
    echo skipping cleanup, cleanup commands below...
    echo $key_cleanup
    echo $server_cleanup
    return
  fi

  echo cleaning up...

  echo deleting ssh-key
  until ! hcloud ssh-key describe $test_prefix >/dev/null 2>&1; do
    $key_cleanup >/dev/null 2>&1 || true
    sleep 0.5
  done

  echo deleting server
  until ! hcloud server describe $test_prefix >/dev/null 2>&1; do
    $server_cleanup >/dev/null 2>&1 || true
    sleep 0.5
  done

  rm /tmp/$test_prefix*
}
trap cleanup EXIT

echo creating ssh-key...
ssh-keygen -N '' -t ed25519 -f /tmp/$test_prefix
hcloud ssh-key create --name $test_prefix --public-key-from-file /tmp/$test_prefix.pub

echo creating server...
hcloud server create --image $snapshot_id --name $test_prefix --type cpx31 --ssh-key $test_prefix
ip=$(hcloud server ip $test_prefix)
ssh="ssh -i /tmp/$test_prefix -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no root@$ip"

echo waiting for ssh...
until $ssh echo ping >/dev/null 2>&1; do
  sleep 1
done

$ssh bash < apps/hetzner/$app/test.sh
