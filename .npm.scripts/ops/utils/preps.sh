#!/bin/bash



choco install -y packer
choco install -y nodejs
# NOT YET AUTOMATED : we also need VERY IMPORTANT FOR NODEJS NODE-GGYP ERRORS : to install VS Studio Build Tools for C++
choco install -y vscode
if [ -f $(which python) ]; then 
  rm $(which python)
fi;

# -- install python3 on windows is for node-gyp, a,d node-gyp required to use 'arpjs' npm package
if [ -f $(which python3) ]; then 
  rm $(which python3)
fi;

choco install -y python3

export PY3_FOLDER_TO_ADD_IN_PATH=$(ls -alh /C/ | grep Python3 | awk '{print $NF}' | awk -F '/' '{print $1}')
/C/${PY3_FOLDER_TO_ADD_IN_PATH}/python.exe --version


# ----
# Now Install lib pcap : also required by 'arpjs' npm package
#
# -> see : https://stackoverflow.com/questions/41762868/fatal-error-c1083-cannot-open-include-file-pcap-h
# -> see : https://www.winpcap.org/devel.htm
# -> see : https://github.com/node-pcap/node_pcap/issues/95#issuecomment-102388747
# -> see : https://github.com/node-pcap/node_pcap/issues/95
#    curl -LO https://www.winpcap.org/install/bin/WpdPack_4_1_2.zip
# 
#    mkdir -p ./.here_i_have_it/
# 
#    unzip -d ./.here_i_have_it/ WpdPack_4_1_2.zip
# 
# 
#    mkdir -p $LOCALAPPDATA/Microsoft/MSBuild/Include
#    mkdir -p $LOCALAPPDATA/Microsoft/MSBuild/Lib
# 
#    cp -fR ./.here_i_have_it/WpdPack/Include/* $LOCALAPPDATA/Microsoft/MSBuild/Include
#    cp -fR ./.here_i_have_it/WpdPack/Lib/* $LOCALAPPDATA/Microsoft/MSBuild/Lib
# 


# ---
# Npcap installation (instead of WinPcap)

curl -LO https://npcap.com/dist/npcap-1.70.exe
# curl -LO https://npcap.com/dist/npcap-0.991.exe

# Now to silenty rn the npcap-1.70.exe (an msi installer), see https://npcap.com/guide/npcap-users-guide.html#:~:text=Installs%20Npcap%20without%20showing%20any,available%20only%20for%20Npcap%20OEM.&text=The%20default%20for%20this%20option%20is%20yes%20%2C%20so%20the%20installer,installation%20independent%20from%20this%20option.


choco install wireshark && /c/Program\ Files/wireshark/wireshark.exe --version
choco install nmap && /c/Program\ Files\ \(x86\)/Nmap/nmap.exe --version
# ---
# Shell profile addon 


if [ -f ./.pokus_profile ]; then
  rm ./.pokus_profile
fi;

cat << EOF >./.pokus_profile
alias node="/C/Program\ Files/nodejs/node"
alias npm="/C/Program\ Files/nodejs/npm"
alias wireshark="/c/Program\ Files/wireshark/wireshark.exe"
alias nmap="/c/Program\ Files\ \(x86\)/Nmap/nmap.exe"
export PATH="\$PATH:/C/Program\ Files/nodejs/:/C/${PY3_FOLDER_TO_ADD_IN_PATH}:/c/Program\ Files/wireshark/:/c/Program\ Files\ \(x86\)/Nmap/"
EOF

touch ~/.profile
touch ~/.bash_profile
touch ~/.bashrc

# append profile addon
cat ./.pokus_profile | tee -a ~/.profile
cat ./.pokus_profile | tee -a ~/.bash_profile
cat ./.pokus_profile | tee -a ~/.bashrc

rm ./.pokus_profile

/C/Program\ Files/nodejs/npm i -g node-gyp
/C/Program\ Files/nodejs/npm i -D node-gyp
# For icmp npm package, on Winodows, Window Build Tools is required (see https://www.npmjs.com/package/icmp )
# (JBL I think NpCap won't hurt neither as Nmap and Wireshark)
/C/Program\ Files/nodejs/npm install -g windows-build-tools


exit 0

curl -LO https://visualstudio.microsoft.com/thank-you-downloading-visual-studio/?sku=BuildTools