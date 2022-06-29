#!/bin/bash

export VM_NAME=$1
if [ "x${VM_NAME}" == "x" ]; then
  export VM_NAME=${VM_NAME:-"testjblvm"}
fi;

echo ''
echo "VM_NAME=[${VM_NAME}]"
echo ''

export DEBIAN_CPU_ARCH="amd64"
export VBOX_VM_OS_TYPE="Linux_64"
# To execute in Windows Git Bash

export OPS_HOME=$(mktemp -d -t "OPS_HOME-XXXXXXXXXX")
# Use VBoxManage Comand to provision the VirtualBox components

# -- Virtual Box (and all its binaries like VBoxManage) has been installed into the ${VBOX_INSTALL_FOLDER} Folder
export VBOX_INSTALL_FOLDER="C:\jibl_vbox\install"
# -- Virtual Box will persist the Virtual MAchines files into the ${VBOX_PLAYGROUND} Folder.
export VBOX_PLAYGROUND="C:\jibl_vbox\playground"
mkdir -p ${VBOX_PLAYGROUND}/ext-pack
mkdir -p ${VBOX_PLAYGROUND}/iso
mkdir -p ${VBOX_PLAYGROUND}/vms
mkdir -p ${VBOX_PLAYGROUND}/vms-disks


export PATH="$PATH:${VBOX_INSTALL_FOLDER}"
# VBoxManage --help
VBoxManage --version

# --- #
# 0./ Download the necessary files
# https://www.debian.org/distrib/netinst#netboot : The "Small CDs or USB sticks"
if ! [ -f ${VBOX_PLAYGROUND}/iso/debian-11.0.0-amd64-netinst.iso ]; then
  # other possible iso for debian 9 : https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-9.9.0-amd64-netinst.iso
  curl -LO https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-11.0.0-amd64-netinst.iso
  cp debian-11.0.0-amd64-netinst.iso ${VBOX_PLAYGROUND}/iso
else
  echo "[Debian iso image has already been downloaded]"
  ls -alh ${VBOX_PLAYGROUND}/iso/debian-11.0.0-amd64-netinst.iso
fi;

# ------------------------------------------------------------------------------


# process.env.HOST_NIC1_DEVICE_NAME
export VM_DISK_NAME="$(echo ${VM_NAME} | tr '[A-Z]' '[a-z]')"
export VM_DISK_NAME="${VM_DISK_NAME}-hdd-disk"

# --- #
# 1./ Create the VirtualBox VM
VBoxManage createvm --name "${VM_NAME}" --ostype "${VBOX_VM_OS_TYPE}" --register --basefolder ${VBOX_PLAYGROUND}/vms

# --- #
# 2./ Create the VirtualBox VM CPUs and RAM
# Set memory
VBoxManage modifyvm "${VM_NAME}" --ioapic on
VBoxManage modifyvm "${VM_NAME}" --memory 1024 --vram 128
# Set vCPUs
VBoxManage modifyvm "${VM_NAME}" --cpus 4

# --- #
# 3./ Create the VirtualBox VM NICs and the VirtualBox Networks

# Set networks : two bridged networks, and one internal



export HOST_NIC1_DEVICE_NAME=enp3s0
export HOST_NIC2_DEVICE_NAME=enp3s7
export HOST_NIC2_DEVICE_NAME=enp3s10

export VM_NETNAME1=vm_netname1
export VM_NETNAME2=vm_netname2
export VM_NETNAME3=vm_netname3


# $ VBoxManage list bridgedifs | grep -E -A7 '*TP-Link*' | grep GUID | awk '{print $2}'
# 3f7ac2f7-d65b-4f03-b195-1fe59b66a8cd
# 
# Utilisateur@Utilisateur-PC MINGW64 ~/packer_virtualbox/.npm.scripts/ops/utils/windows (develop)
# $ export GUID_TPLINK_BRIDGE_INTERFACE=$(VBoxManage list bridgedifs | grep -E -A7 '*TP-Link*' | grep GUID | awk '{print $2}')
# 
# Utilisateur@Utilisateur-PC MINGW64 ~/packer_virtualbox/.npm.scripts/ops/utils/windows (develop)
# $ echo "GUID_TPLINK_BRIDGE_INTERFACE=[${GUID_TPLINK_BRIDGE_INTERFACE}]"
# GUID_TPLINK_BRIDGE_INTERFACE=[3f7ac2f7-d65b-4f03-b195-1fe59b66a8cd]



# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# ---       THE FIRST NETWORK INTERFACE
# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# ------
# --- 

# ------ ------ ------ 
# -- First, I get the name and GUID of the TP Link USB Wifi Network Adpater
# ------ ------
export GUID_TPLINK_BRIDGE_INTERFACE=$(VBoxManage list bridgedifs | grep -E -A7 '*TP-Link*' | grep GUID | awk '{print $2}')
export NAME_TPLINK_BRIDGE_INTERFACE=$(VBoxManage list bridgedifs | grep -E -A7 '*TP-Link*' | grep -E '^Name' | awk -F ':' '{print $2}' | awk '{ for (i=1; i <= NF; i++) { if ($i == $NF) { printf $i } else {printf $i " " } }; }')

echo "GUID_TPLINK_BRIDGE_INTERFACE=[${GUID_TPLINK_BRIDGE_INTERFACE}]"
echo "NAME_TPLINK_BRIDGE_INTERFACE=[${NAME_TPLINK_BRIDGE_INTERFACE}]"

# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# ---       Then I will create the first network interface
# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# 
# VBoxManage modifyvm "${VM_NAME}" --nic1 bridged
# VBoxManage modifyvm "${VM_NAME}" --bridgeadapter ${VM_NETNAME1}
export NETWORK_INDEX="1"
# VBoxManage modifyvm "${VM_NAME}" --nic1 bridged
VBoxManage modifyvm "${VM_NAME}" --nic$NETWORK_INDEX bridged
VBoxManage modifyvm "${VM_NAME}" --bridgeadapter$NETWORK_INDEX "${NAME_TPLINK_BRIDGE_INTERFACE}"
echo "POKUS >> DEBUG >> ---------------------------------------------------  "
echo "POKUS >> DEBUG >>   COMMAND TO CONFIGURE NETWORK ADAPTER 1 IS :  "
echo "POKUS >> DEBUG >> ---------------------------------------------------  "
echo "    VBoxManage modifyvm \"${VM_NAME}\" --bridgeadapter$NETWORK_INDEX \"${NAME_TPLINK_BRIDGE_INTERFACE}\""
echo "POKUS >> DEBUG >> ---------------------------------------------------  "
echo "POKUS >> DEBUG >> JUST CREATED THE FIRST vm NIC : NAME_TPLINK_BRIDGE_INTERFACE=[${NAME_TPLINK_BRIDGE_INTERFACE}] "
# VBoxManage modifyvm "${VM_NAME}" --bridgeadapter$NETWORK_INDEX ${VM_NETNAME1}
# echo "POKUS >> DEBUG >> JUST CREATED THE FIRST vm NIC : VM_NETNAME1=[ ${VM_NETNAME1}] "





# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# ---       THE SECOND NETWORK INTERFACE
# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# ------
# --- 


# ------ ------ ------ 
# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# -- First, I get the name and GUID of the 
# -- Hardware Ethernet Network Adpater
# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# ------ ------
# --- 
export GUID_ETHERNET_BRIDGE_INTERFACE=$(VBoxManage list bridgedifs  | grep -v 'VBoxNetworkName' | grep -E -A7 '*I217-LM*' | grep -E -A7 '*Ethernet*' | grep GUID | awk '{print $2}')
export NAME_ETHERNET_BRIDGE_INTERFACE=$(VBoxManage list bridgedifs  | grep -v 'VBoxNetworkName' | grep -E -A7 '*I217-LM*' | grep -E -A7 '*Ethernet*' | grep -E '^Name' | awk -F ':' '{print $2}' | awk '{ for (i=1; i <= NF; i++) { if ($i == $NF) { printf $i } else {printf $i " " } }; }')

echo "GUID_ETHERNET_BRIDGE_INTERFACE=[${GUID_ETHERNET_BRIDGE_INTERFACE}]"
echo "NAME_ETHERNET_BRIDGE_INTERFACE=[${NAME_ETHERNET_BRIDGE_INTERFACE}]"

# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# ---       Then I will create the first network interface
# ------ ------ ------ ------ ------ ------ ------ ------ ------ ------ #
# 

export NETWORK_INDEX="2"
VBoxManage modifyvm "${VM_NAME}" --nic$NETWORK_INDEX bridged
VBoxManage modifyvm "${VM_NAME}" --bridgeadapter$NETWORK_INDEX "${NAME_ETHERNET_BRIDGE_INTERFACE}"
echo "POKUS >> DEBUG >> ---------------------------------------------------  "
echo "POKUS >> DEBUG >>   COMMAND TO CONFIGURE NETWORK ADAPTER 2 IS :  "
echo "POKUS >> DEBUG >> ---------------------------------------------------  "
echo "    VBoxManage modifyvm \"${VM_NAME}\" --bridgeadapter$NETWORK_INDEX \"${NAME_ETHERNET_BRIDGE_INTERFACE}\""
echo "POKUS >> DEBUG >> ---------------------------------------------------  "
echo "POKUS >> DEBUG >> JUST CREATED THE SECOND vm NIC : NAME_ETHERNET_BRIDGE_INTERFACE=[${NAME_ETHERNET_BRIDGE_INTERFACE}] "



addNetworkInterfaceForVBoxInternalNetworkType () {
  # internal network
  export PXE_INT_NETWORK_NAME="pokusbox_pxe_net"
  export NETWORK_INDEX="3"
  # Below command: "intnet" is the type of network
  VBoxManage modifyvm "${VM_NAME}" --nic$NETWORK_INDEX "intnet"
  # Optionally, you can specify a network name with the command
  VBoxManage modifyvm "${VM_NAME}" --intnet$NETWORK_INDEX "${PXE_INT_NETWORK_NAME}"
  # VBoxManage modifyvm "${VM_NAME}" --intnet$NETWORK_INDEX "${PXE_INT_NETWORK_NAME}" --bridgeadapter$NETWORK_INDEX ${HOST_NIC2_DEVICE_NAME}

  export VM_UUID=$(VBoxManage list vms | grep $VM_NAME | awk '{print $NF}' | awk -F '{' '{print $2}' | awk -F '}' '{print $1}')
  echo "VM_UUID=[${VM_UUID}]"

}

# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #
# Adding a third Network Adapter bridged to 
# an internal VBox Network, could be used to 
# connect the VM to an isolated network used to pxe boot: but here i use packer
# --- # --- # --- # --- # --- # --- # --- # --- # --- # --- #

# ... add more bridged nic interfaces if needed... Won't go into much options : my cloud provider is going to be very simple, enabling people to easily change it, which will require a new version of the terraform provider as well, same for pulumi on top.
# ... will also have very simple error handling : it should properly pass on to terraform virtualbox error messages

# --- #
# 4./ Create the VM Disks

# Create Disk and connect Debian Iso

# VBoxManage createhd --filename `pwd`/"${VM_NAME}"/$VM_DISK_NAME.vdi --size 80000 --format VDI
# VBoxManage createhd --filename ${VBOX_PLAYGROUND}/vms-disks/${VM_NAME}/${VM_DISK_NAME}.vmdk --size 80000 --format VMDK
VBoxManage createhd --filename ${VBOX_PLAYGROUND}/vms-disks/${VM_NAME}/${VM_DISK_NAME}.vmdk --size 80000 --format VMDK


# export DISK_UUID=$(VBoxManage list hdds -l | grep -B10 "In use by VMs:  testjblvm (UUID: ${VM_UUID})" | grep -E '^UUID:' | awk '{print $NF}')
# echo "DISK_UUID=[${DISK_UUID}]"

export DISK_UUID=$(VBoxManage list -l hdds | grep -EB10 "Location:       .*${VM_DISK_NAME}.*" | grep -E '^UUID:' | awk '{print $NF}')
echo "DISK_UUID=[${DISK_UUID}]"

VBoxManage storagectl "${VM_NAME}" --name "SATA Controller" --add sata --controller IntelAhci
VBoxManage storageattach "${VM_NAME}" --storagectl "SATA Controller" --port 0 --device 0 --type hdd --medium  ${VBOX_PLAYGROUND}/vms-disks/${VM_NAME}/${VM_DISK_NAME}.vmdk

VBoxManage storagectl "${VM_NAME}" --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach "${VM_NAME}" --storagectl "IDE Controller" --port 1 --device 0 --type dvddrive --medium ${VBOX_PLAYGROUND}/iso/debian-11.0.0-amd64-netinst.iso

VBoxManage modifyvm "${VM_NAME}" --boot1 dvd --boot2 disk --boot3 none --boot4 none
# VBoxManage modifyvm "${VM_NAME}" --boot1 dvd --boot2 disk --boot3 none --boot4 pxe


echo ''
echo '# ----- #'
echo ''
echo "# TO DELETE THIS VM, RUN : "
echo ''
echo "  VBoxManage unregistervm ${VM_UUID} --delete"
echo "  VBoxManage storagectl \"${DISK_UUID}\" --name $VM_NAME --remove"
echo "  VBoxManage closemedium disk ${DISK_UUID} --delete"
echo ''
echo '# ----- #'
echo ''

echo "DEBUG right after creating the HDD"
exit 0

# --- #
# 5./ Start the VM
VBoxHeadless --startvm "${VM_NAME}"


