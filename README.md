# Packer Virtual Box


This is a repo to design different very useful VM images


### How tobuild images


#### Unbuntu 64

```bash
packer build ./ubuntu_64/ubuntu_64.json
```


#### Debian 64

```bash
packer build ./debian_64/debian_hugo_64.json
```


References :
* https://www.packer.io/guides/automatic-operating-system-installs/preseed_ubuntu
* https://wiki.debian.org/DebianInstaller/Preseed#Obtaining_the_answers_given_during_an_interactive_installer_run


