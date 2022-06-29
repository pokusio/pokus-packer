#!/bin/bash


# ---
# In git bash on windows 
# --
# Should work fine on most GNU/Linux Distribs, wih only a few changes on arp command options
# --
# How to use : 
# - execute the script in Git Bash for Windows
# - if the execution completes without error, then a file ahs been generated, containign the chased IPv4 address 
# - you can set the 'POKUS_SPIT_FILE' env. var. to set the path to the generated file
# 

export SCRIPTS_ZERO_PATH=$0
export INVOKED_SCRIPT_FILENAME=$(echo "${SCRIPTS_ZERO_PATH}" | awk -F '/' '{print $NF}')
export SCRIPTS_RELATIVE_PATH=$(echo "${SCRIPTS_ZERO_PATH}" | sed "s#${INVOKED_SCRIPT_FILENAME}##g" -)

echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# - SCRIPTS_ZERO_PATH=[${SCRIPTS_ZERO_PATH}] -- - #"
echo "# - INVOKED_SCRIPT_FILENAME=[${INVOKED_SCRIPT_FILENAME}] -- - #"
echo "# - SCRIPTS_RELATIVE_PATH=[${SCRIPTS_RELATIVE_PATH}] -- - #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"


# ---
# In git bash on windows 
# --
# Should work fine on most GNU/Linux Distribs, wih only a few changes on arp command options
# --
# How to use : 
# - 1./ get the relative path
# - 2./ invoke twice the 'get-vbox-host-net-interface.sh' script, to get IPv4 address of 2 network interfaces of the packer / Virtual Box Host : a USB Wifi adapter, and an Ethernet network adapter
# - 3./ set value of POKUS environment variables used in the packer JSON build definition.
# 





# --- POKUS environment variables used in the packer JSON build definition.

# export POKUS_SPIT_FILE="${SCRIPTS_RELATIVE_PATH}.pokus.created.vm.ipaddr.spit"
# ${SCRIPTS_RELATIVE_PATH}get-vbox-vm-ipaddr.sh
# export POKUS_CREATED_VM_IPADDR=$(cat ${POKUS_SPIT_FILE})

export POKUS_SPIT_FILE="${SCRIPTS_RELATIVE_PATH}.pokus.packer.host.ipaddr.wifi.spit"
export NETWORK_INTERFACE_SELECTOR_DESC='TP-Link Wireless USB Adapter'
${SCRIPTS_RELATIVE_PATH}get-vbox-host-net-interface.sh
export POKUS_PACKER_HOST_IPADDR_WIFI=$(cat ${POKUS_SPIT_FILE})

export NETWORK_INTERFACE_SELECTOR_DESC='Intel(R) Ethernet Connection I217-LM'
${SCRIPTS_RELATIVE_PATH}get-vbox-host-net-interface.sh
export POKUS_PACKER_HOST_ISOLATED_LAN_IPADDR=$(cat ${POKUS_SPIT_FILE})




echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
# echo "# - POKUS_CREATED_VM_IPADDR=[${POKUS_CREATED_VM_IPADDR}] -- - #"
echo "# - POKUS_PACKER_HOST_IPADDR_WIFI=[${POKUS_PACKER_HOST_IPADDR_WIFI}] -- - #"
echo "# - POKUS_PACKER_HOST_ISOLATED_LAN_IPADDR=[${POKUS_PACKER_HOST_ISOLATED_LAN_IPADDR}] -- - #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"




if [ -f ${SCRIPTS_RELATIVE_PATH}/.pokus.env ]; then
  rm ${SCRIPTS_RELATIVE_PATH}/.pokus.env
fi;

# echo "export POKUS_CREATED_VM_IPADDR=\"${POKUS_CREATED_VM_IPADDR}\"" | tee -a ${SCRIPTS_RELATIVE_PATH}/.pokus.env
echo "export POKUS_PACKER_HOST_IPADDR_WIFI=\"${POKUS_PACKER_HOST_IPADDR_WIFI}\"" | tee -a ${SCRIPTS_RELATIVE_PATH}/.pokus.env
echo "export POKUS_PACKER_HOST_ISOLATED_LAN_IPADDR=\"${POKUS_PACKER_HOST_ISOLATED_LAN_IPADDR}\"" | tee -a ${SCRIPTS_RELATIVE_PATH}/.pokus.env
echo "--- --- --- --- --- --- --- ---"
echo "    POKUS DEBUG STOP POINT"
echo "---"
# exit 0