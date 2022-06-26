# Packer Virtual Box

## Install Packer

Windows : 

```PowerShell
# -------- 
# we want packer 1.6.6 because of
# https://github.com/hashicorp/packer/issues/11115 , see : 
# https://github.com/hashicorp/packer/issues/11115#issuecomment-909385009
# --------
# 
# choco uninstall packer
choco install packer --version=1.6.6
```


This is a repo to design different very useful VM images


### How tobuild images


#### Unbuntu 64

```bash
packer build --force ./ubuntu_64/ubuntu_64.json
```


#### Debian 64

```bash
packer build --force ./debian_bullseye_64/debian_hugo_64.json
```
or with verbose logs : 

```bash 
export PACKER_LOG=1
export PACKER_LOG_FILE=debian_hugo_64.logs
packer build --force ./debian_bullseye_64/debian_hugo_64.json

```

* and with HCL insread of JSON : 

```bash
export PACKER_LOG=1
export PACKER_LOG_FILE=debian_hugo_64.logs

# packer hcl2_upgrade ./debian_bullseye_64/debian_hugo_64.json
packer build --force ./debian_bullseye_64/debian_hugo_64.json.pkr.hcl
```

## GEtting the guest VM IP Address to ssh into

```bash
# in git bash on windows

export PATH="${PATH}:/c/jibl_vbox/install"
vboxmanage --version

# --- 
export VBOX_VM_NAME=${VBOX_VM_NAME:-"packer-virtualbox-iso-1656194566"}

vboxmanage showvminfo ${VBOX_VM_NAME} | grep Ethernet | awk -F 'MAC:' '{print $2}' | awk -F ',' '{print $1}' | awk '{print $1}'

export VM_MAC_ADDRESS=$(VBoxManage showvminfo ${VBOX_VM_NAME} | grep Ethernet | awk -F 'MAC:' '{print $2}' | awk -F ',' '{print $1}' | awk '{print $1}')


# foo=string
# for (( i=0; i<${#foo}; i++ )); do
#   echo "${foo:$i:1}"
# done

export FMT_VM_MAC_ADDRESS=""
for (( i=0; i<${#VM_MAC_ADDRESS}; i++ )); do
  export CURRENT_DIGIT="${VM_MAC_ADDRESS:$i:1}"
  echo "${CURRENT_DIGIT}"
  export FMT_VM_MAC_ADDRESS="${FMT_VM_MAC_ADDRESS}${CURRENT_DIGIT}"
  if ! [ `expr $i % 2` == 0 ]; then
    echo "the current index is ODD : [$i]"
    echo "therefore we add the hyphen separator"
    export FMT_VM_MAC_ADDRESS="${FMT_VM_MAC_ADDRESS}-"
  else 
    echo "the current index is even : [$i]"
    echo "therefore we do nothign just continue to next iteration"
  fi;
  # everything to lower case 
  export FMT_VM_MAC_ADDRESS=(echo "${FMT_VM_MAC_ADDRESS}" | tr '[:upper:]' '[:lower:]')
  echo "# -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- #"
  echo "# -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- #"
  echo "# -+- -+- On iteration #[]"
  echo "# -+- -+-  The formated VM Mac Address is :"
  echo "    ${FMT_VM_MAC_ADDRESS}"
  echo "# -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- #"
  echo "# -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- #"

done


echo "  >>> -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- <<< "
echo "  >>> -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- <<< "
echo "  >>> -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- <<< "
echo "  >>> -+- -+-  AFTER FORMATING MAC ADDRESS : "
echo "  >>> -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- <<< "
echo "  >>> -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- <<< "
echo "  >>> -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- <<< "


echo "  -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- "
echo "  -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- "
echo "  -+- VM_MAC_ADDRESS=[${VM_MAC_ADDRESS}]"
echo "  -+- FMT_VM_MAC_ADDRESS=[${FMT_VM_MAC_ADDRESS}]"
echo "  -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- "
echo "  -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- "


```

## ANNEX A: Configuring the network on Virtual Box side


I have one issue : 



As mentioned in [this issue](https://github.com/hashicorp/packer/issues/3757#issuecomment-241244006) Solution here is to use : 



## ANNEX C: MS-DOS commands


```Msdos
netstat -anobq > ./netstat.logs
```


## ANNEX D: References


* https://www.packer.io/guides/automatic-operating-system-installs/preseed_ubuntu
* https://wiki.debian.org/DebianInstaller/Preseed#Obtaining_the_answers_given_during_an_interactive_installer_run
* About how to configure Virtualbox network adapters yeah : https://github.com/hashicorp/packer/issues/3757#issuecomment-241244006

* About setting the edfault network interdace for preseeded debian installer : https://unix.stackexchange.com/questions/506167/preseeding-debian-installation-still-asks-for-network-card
* About the problem "packer needs the Ip address of the created vm to ssh connect to it" : 
  * https://github.com/hashicorp/packer/issues/4993#issuecomment-394654170
  * with a `json` build configuration file, ssh_host does not seem to work... i will convert to `hcl` then test everything again with `ssh_host`, see https://www.packer.io/docs/commands/init and [`hcl2_upgrade`](https://www.packer.io/docs/commands/hcl2_upgrade)

  * find `ssh_host` in https://www.packer.io/plugins/builders/virtualbox/iso


* Using Packer `1.6.6` to fix issue https://github.com/hashicorp/packer/issues/11115 , see https://github.com/hashicorp/packer/issues/11115#issuecomment-909385009





<!-- 

./packer_virtualbox/documentation/virtualbox-knowledge/vbox-create-vm/get-vbox-vm-ipaddr.sh
./packer_virtualbox/documentation/virtualbox-knowledge/vbox-create-vm/get-vbox-vm-ipaddr.sh
VBoxManage.exe list vms
export VBOX_VM_NAME="packer-virtualbox-iso-1656203734"
./packer_virtualbox/documentation/virtualbox-knowledge/vbox-create-vm/get-vbox-vm-ipaddr.sh
arp -av
ssh pokus@192.168.164.37
export VBOX_VM_NAME="packer-virtualbox-iso-1656203734"
VBoxManage.exe list vms
./packer_virtualbox/documentation/virtualbox-knowledge/vbox-create-vm/get-vbox-vm-ipaddr.sh
ssh pokus@192.168.164.37
arp -av
arp -av
arp -av
arp -av
history | grep details
history | grep detail
arp
export VBOX_VM_NAME="packer-virtualbox-iso-1656204881"
./packer_virtualbox/documentation/virtualbox-knowledge/vbox-create-vm/get-vbox-vm-ipaddr.sh
arp -av
arp -a
history

-->