#!/bin/bash

./.npm.scripts/ops/utils/windows/.pokus.env.sh
# ./packer_virtualbox./.npm.scripts/ops/utils/windows/

unset POKUS_PACKER_HOST_IPADDR_WIFI
unset POKUS_PACKER_HOST_ISOLATED_LAN_IPADDR

source ./.npm.scripts/ops/utils/windows/.pokus.env

echo "POKUS_PACKER_HOST_IPADDR_WIFI=[${POKUS_PACKER_HOST_IPADDR_WIFI}]"
echo "POKUS_PACKER_HOST_ISOLATED_LAN_IPADDR=[${POKUS_PACKER_HOST_ISOLATED_LAN_IPADDR}]"

# -- setting value for dev tests
# export POKUS_CREATED_VM_IPADDR="192.168.98.12"
export POKUS_CREATED_VM_IPADDR=${POKUS_CREATED_VM_IPADDR:-"vm.pokusbox.io"}


export PACKER_LOG=1
export PACKER_LOG_FILE=debian_hugo_64.logs
packer build --force ./debian_bullseye_64/debian_hugo_64.json
