#!/bin/bash



choco install -y packer
choco install -y nodejs
choco install -y vscode
if [ -f $(which python) ]; then 
  rm $(which python)
fi;

if [ -f $(which python3) ]; then 
  rm $(which python3)
fi;

choco install -y python3

export PY3_FOLDER_TO_ADD_IN_PATH=$(ls -alh /C/ | grep Python3 | awk '{print $NF}' | awk -F '/' '{print $1}')
/C/${PY3_FOLDER_TO_ADD_IN_PATH}/python.exe --version

if [ -f ./.pokus_profile ]; then
  rm ./.pokus_profile
fi;

cat << EOF >./.pokus_profile
alias node="/C/Program\ Files/nodejs/node"
alias npm="/C/Program\ Files/nodejs/npm"
export PATH="\$PATH:/C/Program\ Files/nodejs/:/C/${PY3_FOLDER_TO_ADD_IN_PATH}"
EOF

touch ~/.profile
touch ~/.bash_profile
touch ~/.bashrc

cat ./.pokus_profile | tee -a ~/.profile
cat ./.pokus_profile | tee -a ~/.bash_profile
cat ./.pokus_profile | tee -a ~/.bashrc

exit 0
if [ -f ~/.profile ]; then
  rm ~/.profile
fi;
cp ./.pokus_profile ~/.profile
rm ./.pokus_profile





exit 0

curl -LO https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools