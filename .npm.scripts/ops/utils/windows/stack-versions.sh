#!/bin/bash

# ---
# 
echo "# ---"
echo "#  Microsoft Windows version : "
systeminfo
# systeminfo -S localhost -U Utilisateur -FO CSV > systeminfo.pokus.csv
echo "# ---"
echo "#  Git bash for windows version : "
bash --version
echo "# ---"
echo "#  arp version : "
which arp
echo "# ---"
echo "#  ping version (part of the windows system) : "
which ping
echo "# ---"
echo "#  Chocolatey version : "
choco --version
echo "# ---"
echo "#  packer version : "
packer --version
echo "# ---"
echo "#  Virtual Box versions : "
export PATH="${PATH}:/c/jibl_vbox/install"
echo "# ---"
echo "#  VBoxManage version : "
vboxmanage --version
echo "# ---"
echo "#  VBoxBalloonCtrl version : "
VBoxBalloonCtrl --version
echo "# ---"
echo "#  VBoxHeadless  version : "
VBoxHeadless.exe --version
echo "# ---"
echo "#  nodejs/npm versions : "
node -v
npm -v
echo "# ---"
echo "#  Git Bash Shell profile : [cat ~/.profile] : "
# #!/bin/bash
# alias node="/C/Program\ Files/nodejs/node"
# alias npm="/C/Program\ Files/nodejs/npm"
# export PATH="$PATH:/C/Program\ Files/nodejs/"
