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


export POKUS_SPIT_FILE_DEFAULT='./.vbox.vm.ipv4.spit'
export POKUS_SPIT_FILE=${POKUS_SPIT_FILE:-"${POKUS_SPIT_FILE_DEFAULT}"}


export PATH="${PATH}:/c/jibl_vbox/install"
vboxmanage --version


${SCRIPTS_RELATIVE_PATH}.pokus.env.sh
# ./packer_virtualbox./.npm.scripts/ops/utils/windows/

unset POKUS_PACKER_HOST_IPADDR_WIFI
unset POKUS_PACKER_HOST_ISOLATED_LAN_IPADDR

source ${SCRIPTS_RELATIVE_PATH}.pokus.env

echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo " [$0] - POKUS_PACKER_HOST_IPADDR_WIFI=[${POKUS_PACKER_HOST_IPADDR_WIFI}]"
echo " [$0] - POKUS_PACKER_HOST_ISOLATED_LAN_IPADDR=[${POKUS_PACKER_HOST_ISOLATED_LAN_IPADDR}]"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"

# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- #
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- #
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- #
# 
# I will talk about those machines:
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- #
# 
# - "the VirtualBox Host", will denote a hardware machine, on which : 
#   + a TP Link USB Wifi Network Adapter is plugged (i get intenet connection through this link)
#   + VirtualBox is installed
#   + Microsoft Windows 10+ (pro edition)
# 
# --
# 
# On "the VirtualBox Host", I installed Chocolateyr, Hashicorp Packer
# 
# --
# Here is the networking scenario happening during the Packer build process, on windows
# --
# 0./ Packer starts the build,
# - 
# 1./ Packer creates the virutalbox vm, and launches the GNU/Linux installation process
#       The VBox VM is created by Packer with 2 network interfaces : 
#          + A first network interface, linked to the TP Link USB Wifi Network Adapater which will be set a primary network interface during the GNU/Linux installation process
#          + A second network interface, linked to an Ethernet Network ADapter, which is physically linked to a router through copper cable (cat 5 / RJ 45 plugs). When GNU/Linux installation process is completed, this net interface ill not be up. It will only be brought up later for misc use.
#          (+ see in the packer build definition JSON file the "VBoxManage modifyvm" commands to create those network interfaces)
# -  
# 2./ The virutalbox vm, during the linux intallation process, brings up a network interface : that network interface is used during the installation process
# - 
# 3./ the network interface which is used during the installation process, broadcasts its MAC ADRESS through ARP, to obtain an IP address from the Wifi router to which the TP Link USB wifi adapter
# - 
# 4./ the TP Link USB wifi adapter receives the MAC ADDRESS, forwards it to the Wifi Router, the Wifi Router answers to the TP Link USB Wifi Network ADapter, by assigning an IP Address to the Virtual VM Network interface (the VM ins in inux intallation process, and brought up a network interface for the needs of the installation process)
# -
# 5./ At that point, the VirtualBox Host (a hardware) :
#         + has got in its ARP Table, the MAC Address of the primary network interface of the VM (linked to the TP Link USB Wifi Network Adapter)
#         + i can get the MAC Address of the primary network interface of the VM, using " vboxmanage showvminfo --details ${NAME_OF_THE_VM}"
#         + i can get the IP Address assigned to the MAC Address of the primary network interface of the VM, from the ARP Table of the VirtualBOx Host, using "apr -a" command
#         + BUT: 
#                 = at that point we have the IP Address assigned to the network interface that was brought up during GNU/Linux installation process
#                 = when GNU/Linux installation process has completed, and the VM starts for the first time, the primary network interface will get a new, different IP Address
# 
# 6./ Now, when GNU/Linux installation process has completed, to get the IP Address to ssh into my VirtualBOx VM, here is what i can do : 
# 
#    + I have these facts : 
#     - In the arp cache, the IP Address assigned to the MAC Address of the priamry network interface in the VBox VM, is an IP Address that is not used anymore : this was the IP Address of the primary network interface during the installation process (e.g. in an anaconda process), but now that the VM booted on its fresh debian OS, the IP Address is different
#     - Now, I can at that stage, grab that IP Address, even if i cannot use it to ssh into the VBox VM: this IP Address has the network mask included
#     - So i will grab the network mask from that IP Address, and ping "the neighboorhood IP Addresses" of that IP Address
#     - 
#    + to get the IP Address to ssh into my VirtualBOx VM, here is what i can do : 
#     - I clear ARP Cache
#     - After a few seconds ARP table gets new entries, starting with the IP Address of the wifi router, the IP Address of the TP Link USB Wifi NEtwork Adapter, etc..
#     - but we still have no entry in ARP Table for the primary network interface of the VBox VM
#     - to get the  entry in ARP Table for the primary network interface of the VBox VM : we need to perfom at least one network operation which requires making an IP protocol opration between the VBox VM primary network interface, and the VirtualBox Host (Hardware machine)
#     - we need to perfom at least one network operation using IP protocol between the VBox VM primary network interface, and the VirtualBox Host (Hardware machine) : a 'ping' command would be enough.
# 
# ------- ------- ------- ------- ------- ------- ------- ------- -------
# ------- ------- ------- ------- ------- ------- ------- ------- -------
# ------- ------- ------- ------- ------- ------- ------- ------- -------
# ------- ------- ------- ------- ------- ------- ------- ------- -------
# ------- ------- ------- ------- ------- ------- ------- ------- -------
# ------- ------- ------- ------- ------- ------- ------- ------- -------
# ------- ------- ------- ------- ------- ------- ------- ------- -------
# ------- ------- ------- ------- ------- ------- ------- ------- -------
# ------- ------- ------- ------- ------- ------- ------- ------- -------
# ------- ------- ------- ------- ------- ------- ------- ------- -------
#
# Below smaple output i get right after 
# GNU/Linux installation has completed inside VirtualBox VM :
# -------
#  (Note that at this stage, Packer is hanging, 
#  trying in loop, to ssh into the VM)
# -------
# 
# 
# Utilisateur@Utilisateur-PC MINGW64 ~
# $ ./packer_virtualbox/.npm.scripts/ops/utils/windows/get-vbox-vm-ipaddr.sh
#   >>> -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- <<<
#   >>> -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- <<<
#   >>> -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- <<<
#   >>> -+- -+-  AFTER FORMATING MAC ADDRESS :
#   >>> -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- <<<
#   >>> -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- <<<
#   >>> -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- <<<
#   -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
#   -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
#   -+- VM_MAC_ADDRESS=[080027197345]
#   -+- FMT_VM_MAC_ADDRESS=[08-00-27-19-73-45]
#   -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
#   -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
#   -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
#   -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
#   -+- VM_IP_ADDR=[192.168.164.1]
#   -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
#   -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
#   -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
#   -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
#   -+- COMP1=[192]
#   -+- COMP2=[168]
#   -+- COMP3=[164]
#   -+- COMP4=[1]
#   -+- ASSIGNED_LOCAL_IP_ADDRESS=[192.168.164.11]
#   -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
#   -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+-
# 
# Utilisateur@Utilisateur-PC MINGW64 ~
# $ arp -a
# 
# Interface▒: 192.168.56.1 --- 0x7
#   Adresse Internet      Adresse physique      Type
#   224.0.0.22            01-00-5e-00-00-16     statique
#   224.0.0.251           01-00-5e-00-00-fb     statique
#   224.0.0.252           01-00-5e-00-00-fc     statique
#   239.255.255.250       01-00-5e-7f-ff-fa     statique
# 
# Interface▒: 192.168.164.236 --- 0x8
#   Adresse Internet      Adresse physique      Type
#   192.168.164.1         08-00-27-19-73-45     dynamique
#   192.168.164.55        08-00-27-4a-1d-a0     dynamique
#   192.168.164.105       06-a1-d6-1f-23-48     dynamique
#   224.0.0.22            01-00-5e-00-00-16     statique
#   224.0.0.251           01-00-5e-00-00-fb     statique
#   224.0.0.252           01-00-5e-00-00-fc     statique
#   239.255.255.250       01-00-5e-7f-ff-fa     statique
# 
# Interface▒: 192.168.1.101 --- 0x12
#   Adresse Internet      Adresse physique      Type
#   192.168.1.1           e4-c3-2a-3e-fe-b1     dynamique
#   224.0.0.22            01-00-5e-00-00-16     statique
#   224.0.0.251           01-00-5e-00-00-fb     statique
#   224.0.0.252           01-00-5e-00-00-fc     statique
#   239.255.255.250       01-00-5e-7f-ff-fa     statique
# 
# Utilisateur@Utilisateur-PC MINGW64 ~
# $ ipconfig -all
# 
# Configuration IP de Windows
# 
#    Nom de l'h▒te . . . . . . . . . . : Utilisateur-PC
#    Suffixe DNS principal . . . . . . :
#    Type de noeud. . . . . . . . . .  : Hybride
#    Routage IP activ▒ . . . . . . . . : Non
#    Proxy WINS activ▒ . . . . . . . . : Non
# 
# Carte Ethernet Connexion au r▒seau local :
# 
#    Suffixe DNS propre ▒ la connexion. . . :
#    Description. . . . . . . . . . . . . . : Intel(R) Ethernet Connection I217-LM
#    Adresse physique . . . . . . . . . . . : B8-CA-3A-A9-D0-1E
#    DHCP activ▒. . . . . . . . . . . . . . : Oui
#    Configuration automatique activ▒e. . . : Oui
#    Adresse IPv6 de liaison locale. . . . .: fe80::89bd:6e5b:663c:996e%18(pr▒f▒r▒)
#    Adresse IPv4. . . . . . . . . . . . . .: 192.168.1.101(pr▒f▒r▒)
#    Masque de sous-r▒seau. . . .▒. . . . . : 255.255.255.0
#    Bail obtenu. . . . . . . . .▒. . . . . : samedi 25 juin 2022 01:04:59
#    Bail expirant. . . . . . . . .▒. . . . : mardi 28 juin 2022 09:56:04
#    Passerelle par d▒faut. . . .▒. . . . . : 192.168.1.1
#    Serveur DHCP . . . . . . . . . . . . . : 192.168.1.1
#    IAID DHCPv6 . . . . . . . . . . . : 246991418
#    DUID de client DHCPv6. . . . . . . . : 00-01-00-01-27-E5-38-BE-B8-CA-3A-A9-D0-1E
#    Serveurs DNS. . .  . . . . . . . . . . : 192.168.1.1
#    NetBIOS sur Tcpip. . . . . . . . . . . : Activ▒
# 
# Carte Ethernet VirtualBox Host-Only Network :
# 
#    Suffixe DNS propre ▒ la connexion. . . :
#    Description. . . . . . . . . . . . . . : VirtualBox Host-Only Ethernet Adapter
#    Adresse physique . . . . . . . . . . . : 0A-00-27-00-00-07
#    DHCP activ▒. . . . . . . . . . . . . . : Non
#    Configuration automatique activ▒e. . . : Oui
#    Adresse IPv6 de liaison locale. . . . .: fe80::c108:df5b:6131:c223%7(pr▒f▒r▒)
#    Adresse IPv4. . . . . . . . . . . . . .: 192.168.56.1(pr▒f▒r▒)
#    Masque de sous-r▒seau. . . .▒. . . . . : 255.255.255.0
#    Passerelle par d▒faut. . . .▒. . . . . :
#    IAID DHCPv6 . . . . . . . . . . . : 185204775
#    DUID de client DHCPv6. . . . . . . . : 00-01-00-01-27-E5-38-BE-B8-CA-3A-A9-D0-1E
#    Serveurs DNS. . .  . . . . . . . . . . : fec0:0:0:ffff::1%1
#                                        fec0:0:0:ffff::2%1
#                                        fec0:0:0:ffff::3%1
#    NetBIOS sur Tcpip. . . . . . . . . . . : Activ▒
# 
# Carte r▒seau sans fil Connexion au r▒seau local* 1▒:
# 
#    Statut du m▒dia. . . . . . . . . . . . : M▒dia d▒connect▒
#    Suffixe DNS propre ▒ la connexion. . . :
#    Description. . . . . . . . . . . . . . : Microsoft Wi-Fi Direct Virtual Adapter
#    Adresse physique . . . . . . . . . . . : B6-B0-24-D5-03-8C
#    DHCP activ▒. . . . . . . . . . . . . . : Oui
#    Configuration automatique activ▒e. . . : Oui
# 
# Carte r▒seau sans fil Connexion au r▒seau local* 2▒:
# 
#    Statut du m▒dia. . . . . . . . . . . . : M▒dia d▒connect▒
#    Suffixe DNS propre ▒ la connexion. . . :
#    Description. . . . . . . . . . . . . . : Microsoft Wi-Fi Direct Virtual Adapter #2
#    Adresse physique . . . . . . . . . . . : B4-B0-24-D5-03-8C
#    DHCP activ▒. . . . . . . . . . . . . . : Oui
#    Configuration automatique activ▒e. . . : Oui
# 
# Carte r▒seau sans fil Wi-Fi▒:
# 
#    Suffixe DNS propre ▒ la connexion. . . :
#    Description. . . . . . . . . . . . . . : TP-Link Wireless USB Adapter
#    Adresse physique . . . . . . . . . . . : B4-B0-24-D5-03-8C
#    DHCP activ▒. . . . . . . . . . . . . . : Oui
#    Configuration automatique activ▒e. . . : Oui
#    Adresse IPv6. . . . . . . . . . .▒. . .: 2a01:cb11:8053:73c4:8864:b964:d738:a3a8(pr▒f▒r▒)
#    Adresse IPv6 temporaire . . . . . . . .: 2a01:cb11:8053:73c4:90fb:847f:9348:5e4e(pr▒f▒r▒)
#    Adresse IPv6 de liaison locale. . . . .: fe80::8864:b964:d738:a3a8%8(pr▒f▒r▒)
#    Adresse IPv4. . . . . . . . . . . . . .: 192.168.164.236(pr▒f▒r▒)
#    Masque de sous-r▒seau. . . .▒. . . . . : 255.255.255.0
#    Bail obtenu. . . . . . . . .▒. . . . . : lundi 27 juin 2022 10:08:20
#    Bail expirant. . . . . . . . .▒. . . . : lundi 27 juin 2022 13:08:15
#    Passerelle par d▒faut. . . .▒. . . . . : fe80::4a1:d6ff:fe1f:2348%8
#                                        192.168.164.105
#    Serveur DHCP . . . . . . . . . . . . . : 192.168.164.105
#    IAID DHCPv6 . . . . . . . . . . . : 280277028
#    DUID de client DHCPv6. . . . . . . . : 00-01-00-01-27-E5-38-BE-B8-CA-3A-A9-D0-1E
#    Serveurs DNS. . .  . . . . . . . . . . : 192.168.164.105
#    NetBIOS sur Tcpip. . . . . . . . . . . : Activ▒
# 
# Utilisateur@Utilisateur-PC MINGW64 ~
# $ ping 192.168.56.1
# 
# Envoi d'une requ▒te 'Ping'  192.168.56.1 avec 32 octets de donn▒es▒:
# R▒ponse de 192.168.56.1▒: octets=32 temps<1ms TTL=128
# R▒ponse de 192.168.56.1▒: octets=32 temps<1ms TTL=128
# R▒ponse de 192.168.56.1▒: octets=32 temps<1ms TTL=128
# R▒ponse de 192.168.56.1▒: octets=32 temps<1ms TTL=128
# 
# Statistiques Ping pour 192.168.56.1:
#     Paquets▒: envoy▒s = 4, re▒us = 4, perdus = 0 (perte 0%),
# Dur▒e approximative des boucles en millisecondes :
#     Minimum = 0ms, Maximum = 0ms, Moyenne = 0ms
# 
# Utilisateur@Utilisateur-PC MINGW64 ~
# 



clearWindowsARPCache () {
  netsh interface IP delete arpcache
  echo "# --- "
  echo "#  Just Cleared Windows ARP Cache."
  echo "#  Waiting 7 sec. that the ARP Cache repopulates..."
  echo "# --- "
  sleep 7s

  arp -a
  echo "# --- "
  echo "# --- "
}

# --- 
# pings all IP addresses in same /24 network
# as the Wifi Network Adapter IP : POKUS_PACKER_HOST_IPADDR_WIFI
pingIpAddressIn24NetWork () {
  export NEIGHBORHOOD_IP_ADDRESS=${POKUS_PACKER_HOST_IPADDR_WIFI}
  

  export COMP1=$(echo "${NEIGHBORHOOD_IP_ADDRESS}" | awk -F '.' '{print $1}')
  export COMP2=$(echo "${NEIGHBORHOOD_IP_ADDRESS}" | awk -F '.' '{print $2}')
  export COMP3=$(echo "${NEIGHBORHOOD_IP_ADDRESS}" | awk -F '.' '{print $3}')
  export COMP4=$(echo "${NEIGHBORHOOD_IP_ADDRESS}" | awk -F '.' '{print $4}')
  
  echo "# --- "
  echo "#  PING Right side of neighboorhood"
  echo "# --- "

  # --- 
  #  PING all [x.y.z.2 / x.y.z.253] 
  # --- 
  for ITERATION in {2..253}
  do
    unset NEIGHBOR_IP_ADDRESS
    export NEIGHBOR_IP_ADDRESS="${COMP1}.${COMP2}.${COMP3}.${ITERATION}"
    echo "# ----"
    echo "#  ping -n 2 ${NEIGHBOR_IP_ADDRESS} "
    echo "# ----"
    ping -n 2 ${NEIGHBOR_IP_ADDRESS}
  done

}


pingIpAddressNeighbors () {
  export NEIGHBORHOOD_IP_ADDRESS=$1
  if [ "x${NEIGHBORHOOD_IP_ADDRESS}" == "x" ]; then 
    # echo " [pingIpAddressNeighbors ()] >> ERROR: "
    # echo "you must provide one argument an IP v4 Address"
    # exit 56
    echo "# --- "
    echo "#  [$0]-[pingIpAddressNeighbors ()]"
    echo "#  NEIGHBORHOOD_IP_ADDRESS is not set, so defaulting to "
    echo "# --- POKUS_PACKER_HOST_IPADDR_WIFI=[${POKUS_PACKER_HOST_IPADDR_WIFI}]"
    export NEIGHBORHOOD_IP_ADDRESS=${POKUS_PACKER_HOST_IPADDR_WIFI}

    echo "#  NEIGHBORHOOD_IP_ADDRESS is not set, so pinging "
    echo "#  all IPv4 address in POKUS_PACKER_HOST_IPADDR_WIFI=[${POKUS_PACKER_HOST_IPADDR_WIFI}]"
    export NEIGHBORHOOD_IP_ADDRESS=${POKUS_PACKER_HOST_IPADDR_WIFI}
    pingIpAddressIn24NetWork
  else 
    export COMP1=$(echo "${NEIGHBORHOOD_IP_ADDRESS}" | awk -F '.' '{print $1}')
    export COMP2=$(echo "${NEIGHBORHOOD_IP_ADDRESS}" | awk -F '.' '{print $2}')
    export COMP3=$(echo "${NEIGHBORHOOD_IP_ADDRESS}" | awk -F '.' '{print $3}')
    export COMP4=$(echo "${NEIGHBORHOOD_IP_ADDRESS}" | awk -F '.' '{print $4}')
    
    echo "# --- "
    echo "#  PING Right side of neighboorhood"
    echo "# --- "

    # --- 
    #  PING Right side of neighboorhood
    # --- 
    for ITERATION in {1..17}
    do
      # unset COMP4_INCR
      # unset NEIGHBOR_IP_ADDRESS
      # --
      # break the loop before we reach 255 (254 actually), on right neighboor of "${COMP1}.${COMP2}.${COMP3}.${COMP4}"
      if [ ${COMP4} -ge 254 ]; then
        break;
      fi;
      export COMP4_INCR=$(( ${COMP4} + ${ITERATION} ))
      export NEIGHBOR_IP_ADDRESS="${COMP1}.${COMP2}.${COMP3}.${COMP4_INCR}"
      echo "# ----"
      echo "#  ping -n 4 ${NEIGHBOR_IP_ADDRESS} "
      echo "# ----"
      ping -n 4 ${NEIGHBOR_IP_ADDRESS}
    done

    echo "# --- "
    echo "#  PING Left side of neighboorhood"
    echo "# --- "

    # --- 
    #  PING Left side of neighboorhood
    # --- 
    for ITERATION in {1..17}
    do
      # unset COMP4_INCR
      # unset NEIGHBOR_IP_ADDRESS
      # --
      # break the loop before we reach zero, on left neighboor of "${COMP1}.${COMP2}.${COMP3}.${COMP4}"
      if [ ${COMP4} -le $(( ${ITERATION} + 1 )) ]; then
        break;
      fi;

      export COMP4_INCR=$(( ${COMP4} - ${ITERATION} ))
      export NEIGHBOR_IP_ADDRESS="${COMP1}.${COMP2}.${COMP3}.${COMP4_INCR}"
      echo "# ----"
      echo "#  ping -n 4 ${NEIGHBOR_IP_ADDRESS} "
      echo "# ----"
      ping -n 4 ${NEIGHBOR_IP_ADDRESS}
    done
  fi;
}




resolveVBoxVMIpv4Address () {


# --- 
export VBOX_VM_NAME_DEFAULT=$(vboxmanage list vms | grep 'packer-virtualbox' | awk '{print $1}' | awk -F '"' '{print $2}')
export VBOX_VM_NAME=${VBOX_VM_NAME:-"${VBOX_VM_NAME_DEFAULT}"}
# export NETWORK_INT_SELECTOR=${NETWORK_INT_SELECTOR:-"Intel(R) Ethernet Connection I217-LM"}
export NETWORK_INT_SELECTOR=${NETWORK_INT_SELECTOR:-"TP-Link Wireless USB Adapter"}

# vboxmanage showvminfo ${VBOX_VM_NAME} | grep Ethernet | awk -F 'MAC:' '{print $2}' | awk -F ',' '{print $1}' | awk '{print $1}'

export VM_MAC_ADDRESS=$(VBoxManage showvminfo ${VBOX_VM_NAME} | grep "${NETWORK_INT_SELECTOR}" | awk -F 'MAC:' '{print $2}' | awk -F ',' '{print $1}' | awk '{print $1}')


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
  export FMT_VM_MAC_ADDRESS=$(echo "${FMT_VM_MAC_ADDRESS}" | tr '[:upper:]' '[:lower:]')
  echo "# -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- #"
  echo "# -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- #"
  echo "# -+- -+- On iteration #[$i]"
  echo "# -+- -+-  The formated VM Mac Address is :"
  echo "    ${FMT_VM_MAC_ADDRESS}"
  echo "# -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- #"
  echo "# -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- #"
done

# -+-+-+-
# remove trailing hyphen
export FMT_VM_MAC_ADDRESS="${FMT_VM_MAC_ADDRESS:0:$((  ${#FMT_VM_MAC_ADDRESS} - 1))}"

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
export VM_IP_ADDR=$(arp -a | grep ${FMT_VM_MAC_ADDRESS} | awk '{print $1}')
echo "  -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- "
echo "  -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- "
echo "  -+- VM_IP_ADDR=[${VM_IP_ADDR}]"
echo "  -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- "
echo "  -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- "

if [ -f ${POKUS_SPIT_FILE} ]; then
  rm ${POKUS_SPIT_FILE}
fi;
echo "${VM_IP_ADDR}" > ${POKUS_SPIT_FILE}
# -- 


}

# ---
# Resolve the Ip Address a first time, to gety the IP4 Address used 
# during the GNU/Linux Instalation from ARP tables
# ---
# We will then use that IP Address, to discover the
# new IPv4 Address of the primary network interface in 
# the fresh GNU / Linux installation, in the VBox VM 
# ---
# By "discover new IPv4 Address of [...] the VBox VM", i mean :
# pinging a bunch of IP Addresses, in the same '*/24' network IP adresses range than 
# the IPv4 Address used during the GNU/Linux Installation process.
# ---

resolveVBoxVMIpv4Address
echo ''
export WRONG_IP_ADDRESS=$(cat ${POKUS_SPIT_FILE})
echo ''
echo "# --- # --- #"
echo "  WRONG_IP_ADDRESS=[${WRONG_IP_ADDRESS}]"
echo "# --- # --- #"
echo ''
sleep 2s

clearWindowsARPCache

pingIpAddressNeighbors ${WRONG_IP_ADDRESS}

sleep 2s


resolveVBoxVMIpv4Address
echo ''
echo ''
export RIGHT_IP_ADDRESS=$(cat ${POKUS_SPIT_FILE})
echo "# --- # --- #"
echo "  RIGHT_IP_ADDRESS=[${RIGHT_IP_ADDRESS}]"
echo "# --- # --- #"


# ------
# -- Now let's configure etc hosts on windows so that SSH communicator successfully connects to the VM
# 
# export POKUS_CREATED_VM_IPADDR="192.168.98.12"
export WINDOWS_ETC_HOSTS_PATH=${WINDOWS_ETC_HOSTS_PATH:-"/c/Windows/System32/Drivers/etc/hosts"}
export POKUS_CREATED_VM_IPADDR=${POKUS_CREATED_VM_IPADDR:-"vm.pokusbox.io"}
# export POKUS_CREATED_VM_IPADDR="vm.pokusbox.io"


# -- backup before any modification of ~/.ssh/known_hosts
if [ -f ~/.ssh/known_hosts.bak.pokus ]; then
  echo "a previous [~/.ssh/known_hosts.bak.pokus]"
  echo "backup already existed, it prevails"
else 
  cp ~/.ssh/known_hosts ~/.ssh/known_hosts.bak.pokus
fi;


# ------
# --- Removing both hostname (POKUS_CREATED_VM_IPADDR) and IP addess of VM (RIGHT_IP_ADDRESS)
cat ~/.ssh/known_hosts | grep -v ${POKUS_CREATED_VM_IPADDR} | tee ~/.ssh/known_hosts
cat ~/.ssh/known_hosts | grep -v ${RIGHT_IP_ADDRESS} | tee ~/.ssh/known_hosts

# ------
# --- Adding both hostname (POKUS_CREATED_VM_IPADDR) and IP addess of VM (RIGHT_IP_ADDRESS)

ssh-keyscan -H ${POKUS_CREATED_VM_IPADDR} | tee -a ~/.ssh/known_hosts
ssh-keyscan -H ${RIGHT_IP_ADDRESS} | tee -a ~/.ssh/known_hosts




# -- backup before any modification of ${WINDOWS_ETC_HOSTS_PATH}
if [ -f ${WINDOWS_ETC_HOSTS_PATH}.bak.pokus ]; then
  echo "a previous [${WINDOWS_ETC_HOSTS_PATH}.bak.pokus]"
  echo "backup already existed, it prevails"
else 
  cp ${WINDOWS_ETC_HOSTS_PATH} ${WINDOWS_ETC_HOSTS_PATH}.bak.pokus
fi;

# removing prvious entries
cat ${WINDOWS_ETC_HOSTS_PATH} | grep -v ${POKUS_CREATED_VM_IPADDR} | tee ${WINDOWS_ETC_HOSTS_PATH}
# resetting new entry
# echo "${RIGHT_IP_ADDRESS}      vm.pokusbox.io" | tee -a ${WINDOWS_ETC_HOSTS_PATH}
echo "${RIGHT_IP_ADDRESS}      ${POKUS_CREATED_VM_IPADDR}" | tee -a ${WINDOWS_ETC_HOSTS_PATH}

# export POKUS_CREATED_VM_IPADDR="vm.pokusbox.io"













































































exit 0

export COMP1=$(echo ${VM_IP_ADDR} | awk  -F '.' '{print $1}')
export COMP2=$(echo ${VM_IP_ADDR} | awk  -F '.' '{print $2}')
export COMP3=$(echo ${VM_IP_ADDR} | awk  -F '.' '{print $3}')
export COMP4=$(echo ${VM_IP_ADDR} | awk  -F '.' '{print $4}')

export COMP4_INCR=$(( ${COMP4} + 10 ))
export ASSIGNED_LOCAL_IP_ADDRESS="${COMP1}.${COMP2}.${COMP3}.${COMP4_INCR}"

echo "  -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- "
echo "  -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- "
echo "  -+- COMP1=[${COMP1}]"
echo "  -+- COMP2=[${COMP2}]"
echo "  -+- COMP3=[${COMP3}]"
echo "  -+- COMP4=[${COMP4}]"
echo "  -+- ASSIGNED_LOCAL_IP_ADDRESS=[${ASSIGNED_LOCAL_IP_ADDRESS}]"
echo "  -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- "
echo "  -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- -+- "



arp -s 192.168.164.29   ${FMT_VM_MAC_ADDRESS}
export FMT_VM_MAC_ADDRESS="08-00-27-21-5b-5b"
arp -s 192.168.164.29   ${FMT_VM_MAC_ADDRESS}


# An awesome idea after all! : 

# connect via ssh using mac address Instead of looking for the right ip address, just pick whatever address you like and set a static ip mapping.

sudo arp -s 192.168.1.200  00:35:cf:56:b2:2g temp && ssh root@192.168.1.200





















###################
###
###

$ arp

Affiche et modifie les tables de traduction d'adresses IP en adresses
physiques utilis▒es par le protocole de r▒solution d'adresses ARP.

ARP -s inet_addr eth_addr [if_addr]
ARP -d inet_addr [if_addr]
ARP -a [inet_addr] [-N if_addr] [-v]

  -a            Affiche les entr▒es ARP en cours en interrogeant les donn▒es
                en cours du protocole. Si inet_addr est sp▒cifi▒, seules les
                adresses IP et physiques de l'ordinateur sp▒cifi▒ sont
                affich▒es. Si plus d'une interface r▒seau utilise ARP, les
                entr▒es de chaque table ARP sont affich▒es.
  -g            Identique ▒ -a.
  -v            Affiche les entr▒es ARP en cours en mode verbeux. Toutes les
                entr▒es non valides ainsi que celles de l'interface de retour
                de bouclage sont affich▒es.
  inet_addr     Sp▒cifie un adresse Internet.
  -N if_addr    Affiche les entr▒es ARP de chaque interface r▒seau sp▒cifi▒e
                par if_addr.
  -d            Supprime l'h▒te sp▒cifi▒ par inet_addr. inet_addr peut
                contenir le caract▒re g▒n▒rique * pour supprimer tous
                les h▒tes.
  -s            Ajoute l'h▒te et associe l'adresse Internet inet_addr
                avec l'adresse physique eth_addr. L'adresse physique
                est donn▒e sous forme de 6 octets hexad▒cimaux s▒par▒s
                par des tirets. L'entr▒e est permanente.
  eth_addr      Sp▒cifie une adresse physique.
  if_addr       Sp▒cifie l'adresse Internet de l'interface dont la table
                de traduction d'adresses doit ▒tre modifi▒e.
                Si ce param▒tre n'est pas indiqu▒, la premi▒re interface
                applicable sera utilis▒e.
Exemples :
  > arp -s 157.55.85.212   00-aa-00-62-c6-09  .... Ajoute une entr▒e statique.
  > arp -a                                    .... Affiche la table ARP.
