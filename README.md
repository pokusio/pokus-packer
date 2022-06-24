# Packer Virtual Box


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

* and witgh HCL insread of JSON : 

```bash
export PACKER_LOG=1
export PACKER_LOG_FILE=debian_hugo_64.logs

packer hcl2_upgrade ./debian_bullseye_64/debian_hugo_64.json
# packer build --force ./debian_bullseye_64/debian_hugo_64.json
packer build --force ./debian_bullseye_64/debian_hugo_64.json.pkr.hcl

```

## ANNEX A: Configuring the network on Virtual Box side


I have one issue : 



As mentioned in [this issue](https://github.com/hashicorp/packer/issues/3757#issuecomment-241244006) Solution here is to use : 






## ANNEX C: References


* https://www.packer.io/guides/automatic-operating-system-installs/preseed_ubuntu
* https://wiki.debian.org/DebianInstaller/Preseed#Obtaining_the_answers_given_during_an_interactive_installer_run
* About how to configure Virtualbox network adapters yeah : https://github.com/hashicorp/packer/issues/3757#issuecomment-241244006

* About setting the edfault network interdace for preseeded debian installer : https://unix.stackexchange.com/questions/506167/preseeding-debian-installation-still-asks-for-network-card
* About the problem "packer needs the Ip address of the created vm to ssh connect to it" : 
  * https://github.com/hashicorp/packer/issues/4993#issuecomment-394654170
  * with a `json` build configuration file, ssh_host does not seem to work... i will convert to `hcl` then test everything again with `ssh_host`, see https://www.packer.io/docs/commands/init and [`hcl2_upgrade`](https://www.packer.io/docs/commands/hcl2_upgrade)

  * find `ssh_host` in https://www.packer.io/plugins/builders/virtualbox/iso
