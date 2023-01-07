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


## How to build images


<!--

### Unbuntu 64

```bash
packer build --force ./ubuntu_64/ubuntu_64.json
```


### Debian 64

```bash
packer build --force ./debian_bullseye_64/debian_hugo_64.json

```

or with verbose/debug logs : 

```bash 
export PACKER_LOG=1
export PACKER_LOG_FILE=debian_hugo_64.logs
packer build --force ./debian_bullseye_64/debian_hugo_64.json

# -- unfortunaltely: 
# + I have to use packer 1.6.6 , to be able to use 'ssh_host' variable
# + but with packer 1.6.6 , there are issues using a 
#   separate packer variables dedicated file 
#   (a json files containing only variables), 
#   see https://github.com/hashicorp/packer/pull/8914
# ---
# 
packer build -var-file ./debian_bullseye_64/debian_hugo_64.json.vars.json --force ./debian_bullseye_64/debian_hugo_64.novars.json

packer validate -var-file=./debian_bullseye_64/debian_hugo_64.json.vars.json ./debian_bullseye_64/debian_hugo_64.novars.json

```

Now :

* to discover my VirtualBox Host Network Interface, i run : 

```bash
./.npm.scripts/ops/utils/windows/get-vbox-host-net-interface.sh

```

* to discover my VirtualBox VM IP Adress, i run : 

```bash

./.npm.scripts/ops/utils/windows/get-vbox-vm-ipaddr.sh

```

* note that `./.npm.scripts/ops/utils/windows/create-vm-usb-wifi-net-adapter.sh` script purpose is to test the `vboxmanage modifyvm` commands to create the network interfaces of the VM

-->

### Debian 64 (Reloaded - that's the only one almost working)

Currently, this `packer` build is the most advanced i have : 
* I am working on a **networking issue** occuring during the `packer` build process.
* Before working on this networking issue during `packer` build, I first : 
  * started using `export PACKER_LOG=1` to get `packer` debug logs while running the `packer` build in dev mode `npm run packer:build:dev`
  * I experienced errors caused by using a separate packer variables file : 
  * I have to use `packer` `1.6.6`+ , to be able to use `ssh_host` variable (I do want, to use that `ssh_host` options).
  * but with `packer` `1.6.6`+ , there are issues using a separate `packer` variables dedicated file (a json files containing only variables), see https://github.com/hashicorp/packer/pull/8914
  * So, to get rid of the use of a separated variable file, I merged the separate packer variables a dedicated file (a json files containing only variables), with the packer image main definition file `./debian_bullseye_64/debian_hugo_64.json` 

Now, about the **networking issue** occuring during the `packer` build process :

* to discover my VirtualBox Host Network Interface, i run : 

```bash
./.npm.scripts/ops/utils/windows/get-vbox-host-net-interface.sh

```

* to discover my VirtualBox VM IP Adress, i run : 

```bash

./.npm.scripts/ops/utils/windows/get-vbox-vm-ipaddr.sh

```

* note that `./.npm.scripts/ops/utils/windows/create-vm-usb-wifi-net-adapter.sh` script purpose is to test the `vboxmanage modifyvm` commands to create the network interfaces of the VM.


* Packer build the Virtual Box images : 

```bash
npm run packer:build:dev
```

* When the VM has restarted, and `GNU/Linux Debian` is waiting for user login, execute in another git bash session : 

```bash
export POKUS_SPIT_FILE=$(pwd)/.catched.vm.ip.address
npm run packer:vm:scan:dev

# # ---
# # In the fun network programming, i developed a small module to send ARP request
# # (could easily be modified to perform arp poisoning) : 
# npm run packer:net:arp:dev

# ---
# [npm run packer:net:icmp:dev ]
# Will ping all IP Addresses in the same network as the
# IP Address catched for the VM in the ARP tables, for
# the VBox VM, during the GNU/Linux Debian preseeded automated installation
# ---
# 

# --
# The IP Address catched for the VM in the ARP tables, for
# the VBox VM, during the GNU/Linux Debian preseeded automated installation
# export CATCHED_TEMP_IP_ADDR='192.168.98.110'
export CATCHED_TEMP_IP_ADDR=$(cat ${POKUS_SPIT_FILE})
export TARGET_IP_ADDR_TO_PING='192.168.98.111'
npm run packer:net:icmp:dev
# [npm run packer:net:icmp:dev ] must end by interpolating the /etc/hosts file on Windows, so that packer finally successfully connects
# i can also end with nmap tests on the remote IP to check ssh port 22 is opened, things like that.
# btw, i didn't know there was a telnet port open on TP Link
# Advise : Running Wireshark in parallel makes it really easier to debug, with ARP or ICMP filter
# TODO : change the global script for it to ping all ip addresses, instead of one specific

```

<!-- 
# I did ARP, ICMP, I want to do BGP next, will implement twin with DPDK (java / node / rust : golang)
-->



<!--

Migrating to HCL is a bit of work, so i leave that aside, i want to stay focused on my first goal: obtaining a fully working packer build.

* and with HCL insread of JSON  : 

```bash
export PACKER_LOG=1
export PACKER_LOG_FILE=debian_hugo_64.logs

# $ packer hcl2_upgrade ./debian_bullseye_64/debian_hugo_64.json
# Successfully created ./debian_bullseye_64/debian_hugo_64.json.pkr.hcl
# 
# ---
# See https://discuss.hashicorp.com/t/working-json-breaks-after-hcl2-upgrade-error-variables-not-allowed/21220/3
# ---
# 
# --- <+> --- #
# --- <+> --- See ANNEX A. Json 2 HCL Upgrade  #
# --- <+> --- #
# 
# ---
# 

packer build --force ./debian_bullseye_64/debian_hugo_64.json.pkr.hcl
```
 -->

## Getting the guest VM IP Address to ssh into

You may also have run into this issue : 
* packer is trying to ssh into the VM it created, 
* but it is trying that using a wrong IP Address
* and packer stays in the loop trying to ssh intot he VM, until it reaches the timeout.


I personnally ran into this issue, because i want to 


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


## ANNEX A. Json 2 HCL Upgrade

After executing `packer hcl2_upgrade <json packer file>`, I try and run again the packer build, using the new fresh HCL file.

It immediately gives me an error :

```bash
$ packer build --force ./debian_bullseye_64/debian_hugo_64.json.pkr.hcl
Error: Variables not allowed

  on ./debian_bullseye_64/debian_hugo_64.json.pkr.hcl line 57, in variable "boot_command_env_addon":
  57:   default = "packer_fileserver_ip={{ .HTTPIP }} packer_fileserver_port={{ .HTTPPort }} hostname=${var.hostname} golang_version=1.18.3 hugo_version=0.100.2"

Variables may not be used here.

```

So here i use a variable `${var.hostname}` and it is not allowed : I replaced that occurence by a raw value, `packerpokus.io`

After that, i run again the packer build, and i get new errors : 

```
$ packer build --force ./debian_bullseye_64/debian_hugo_64.json.pkr.hcl
Error: Incorrect attribute value type

  on ./debian_bullseye_64/debian_hugo_64.json.pkr.hcl line 136:
  (source code not available)

Inappropriate value for attribute "memory": a number is required.

Error: Incorrect attribute value type

  on ./debian_bullseye_64/debian_hugo_64.json.pkr.hcl line 129:
  (source code not available)

Inappropriate value for attribute "disk_size": a number is required.

Error: Incorrect attribute value type

  on ./debian_bullseye_64/debian_hugo_64.json.pkr.hcl line 128:
  (source code not available)

Inappropriate value for attribute "cpus": a number is required.



==> Wait completed after 0 seconds

==> Builds finished but no artifacts were created.
```


* https://discuss.hashicorp.com/t/working-json-breaks-after-hcl2-upgrade-error-variables-not-allowed/21220
* https://bailey.st/2020/11/01/packer-virtualbox-builder-from-json-to-hcl.html


## ANNEX B: Configuring the network on Virtual Box side


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

* Packer user variables from Environment variables : https://www.packer.io/docs/templates/legacy_json_templates/user-variables#environment-variables
* Packer user variables from Vault Secrets (very important) : https://www.packer.io/docs/templates/legacy_json_templates/user-variables#vault-variables
* About the issue of installing `arpjs` npm package, because of node-gyp, see : 
  * https://stackoverflow.com/questions/57879150/how-can-i-solve-error-gypgyp-errerr-find-vsfind-vs-msvs-version-not-set-from-c
  * and https://github.com/nodejs/node-gyp#on-windows
  * https://github.com/node-pcap/node_pcap/issues/224#issuecomment-310177406
  * but using cap instead of arpjs does not make disappear the central problem, which is the windows system and the WinPCap / npcap installed windows libraries... (in th end complexity is on windows) : https://github.com/mscdex/cap/issues/83
  * node-gyp on windows : https://github.com/nodejs/node-gyp/issues/1709#issuecomment-479848736

<!-- 

./packer_virtualbox/.npm.scripts/ops/utils/windows/get-vbox-vm-ipaddr.sh
./packer_virtualbox/.npm.scripts/ops/utils/windows/get-vbox-vm-ipaddr.sh
VBoxManage.exe list vms
export VBOX_VM_NAME="packer-virtualbox-iso-1656203734"
./packer_virtualbox/.npm.scripts/ops/utils/windows/get-vbox-vm-ipaddr.sh
arp -av
ssh pokus@192.168.164.37
export VBOX_VM_NAME="packer-virtualbox-iso-1656203734"
VBoxManage.exe list vms
./packer_virtualbox/.npm.scripts/ops/utils/windows/get-vbox-vm-ipaddr.sh
ssh pokus@192.168.164.37
arp -av
arp -av
arp -av
arp -av
history | grep details
history | grep detail
arp
export VBOX_VM_NAME="packer-virtualbox-iso-1656204881"
./packer_virtualbox/.npm.scripts/ops/utils/windows/get-vbox-vm-ipaddr.sh
arp -av
arp -a
history

-->


## Annex Z: A Decisive Networking information

* I run a packer `virtualbox-iso` build : 
  * with only one network interface setup
> 
> This is because of how `VirtualBox` NAT networks work. From the host you can't reach the guest VM directly. `Packer` solves this by setting up port forwarding rule. A random port between `ssh_host_port_min` and `ssh_host_port_max` is forwarded to the guest VMs `ssh_port`.
> 
> If you want to turn this of set `ssh_skip_nat_mapping` to `true`, but then you have to ensure that you have a network setup where `Packer` can reach the guest.
> 
> 
> _Quote from_ https://stackoverflow.com/questions/56527682/packer-ssh-communicator-ignores-ssh-port
> 

 ## ANNEX ZZ : Paravirtualization Interface for Windows 10

I experienced many virtualbox issue after installing / uninstalling Docker Desktop for Windows (it messed up with the paravirtualization of course, and the uninstallation, as always with Microsoft, is not idempotent, it does not take you back to the exact point you were)

This resulted that all my VirtualBox VMs failed to start again.


So I had to consider re-installing the paravirtualization Interface : yet i had another issue, i did not check what paravirtualization interface i used to create my VM images with `Packer`...

* https://learn.microsoft.com/en-US/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v


* Note I also, several weeks later, tried many Windows tips to "repair" , and even improve virtualbox performance on Windows : https://github.com/pokusio/virtualbox-operator/issues/2