#! /usr/bin/env bash

set -e
 
# Helps clear issues of not finding Ansible package,
# perhaps due to updates running when server is first spun up
sleep 10
 
export DEBIAN_FRONTEND="noninteractive"

export RETRIEVED_IPADDR=$(ip addr show enp0s3 | grep 192 | awk '{print $2}' | awk -F '/' '{print $1}')
echo "export RETRIEVED_IPADDR=${RETRIEVED_IPADDR}" 
echo "export RETRIEVED_IPADDR=${RETRIEVED_IPADDR}" | tee ./pokus.guest.ipaddr

exit 0 

export RETRIEVED_IPADDR=$(ip addr show enp0s3 | grep 192 | awk '{print $2}' | awk -F '/' '{print $1}')
ip addr show enp0s3 | grep 192 | awk '{print $2}' | awk -F '/' '{print $1}'



exit 0

#! /usr/bin/env bash
 
set -e
 
# Helps clear issues of not finding Ansible package,
# perhaps due to updates running when server is first spun up
sleep 10
 
export DEBIAN_FRONTEND="noninteractive"
 
# Install Ansible
echo ">>>>>>>>>>> INSTALLING ANSIBLE"
sudo apt-get update
sudo apt-get install -y ansible
