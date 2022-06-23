# Packer Virtual Box


This is a repo to design different very useful VM images


### How tobuild images


#### Unbuntu 64

```bash
packer build --force ./ubuntu_64/ubuntu_64.json
```


#### Debian 64

```bash
packer build --force ./debian_64/debian_hugo_64.json
```

## ANNEX A: Configuring the network on Virtual Box side


I have one issue : 



As mentioned in [this issue](https://github.com/hashicorp/packer/issues/3757#issuecomment-241244006) Solution here is to use : 






## ANNEX B: References


* https://www.packer.io/guides/automatic-operating-system-installs/preseed_ubuntu
* https://wiki.debian.org/DebianInstaller/Preseed#Obtaining_the_answers_given_during_an_interactive_installer_run
* About how to configure Virtualbox network adapters yeah : https://github.com/hashicorp/packer/issues/3757#issuecomment-241244006



