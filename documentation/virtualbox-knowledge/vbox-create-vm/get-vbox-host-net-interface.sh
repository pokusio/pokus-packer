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



export POKUS_SPIT_FILE_DEFAULT='./.vbox.host.ipv4.spit'
export POKUS_SPIT_FILE=${POKUS_SPIT_FILE:-"${POKUS_SPIT_FILE_DEFAULT}"}


export PATH="${PATH}:/c/jibl_vbox/install"
vboxmanage --version


# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- #
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- #
# -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- #
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
# Below smaple output of the 'ipconfig -all' in git bash on windows 
# -------
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
# 



# ---
# We use 'ipconfig -all' (in git bash, equivalent of a 'ipconfig /all' in ms-dos)
# to grep the MAC ADDRESS and IPv4 Address of the
# network interface on the VirtualBox Host machine (a hardware machine)
# ---
# First, we need to grep the configuration of the given Network Interface
# So we need a way ot distinguish network interfaces displayed by an 'ipconfig -a' command : 
# 
# - To distinguish / discriminate network interfces, we will use what
#   we call a "SELECTOR" 
# - a "SELECTOR" is a string, the value of any dsiplayed property of the Network Interface
# - the "SELECTOR" value you will choose, will be used to "grep" the ipconfig output
# - The only "SELECTOR" you can use for now, is related to the "Description" property
# 
# 
# -------
# How to use this script
# --
# 1./ execute a first time the 'ipconfig -all' command on your machine

export NETWORK_INTERFACE_SELECTOR_DESC_DEFAULT='TP-Link Wireless USB Adapter'
export NETWORK_INTERFACE_SELECTOR_DESC=${NETWORK_INTERFACE_SELECTOR_DESC:-"${NETWORK_INTERFACE_SELECTOR_DESC_DEFAULT}"}

# ipconfig -all | grep -aB3 -A17 "${NETWORK_INTERFACE_SELECTOR_DESC}" | 

export VBOX_HOST_NET_INT_IPV4_ADDR=$(ipconfig -all | grep -aB3 -A17 "${NETWORK_INTERFACE_SELECTOR_DESC}" | grep -a 'IPv4' | awk '{print $NF}' | awk -F '(' '{print $1}')
export VBOX_HOST_NET_INT_MAC_ADDR=$(ipconfig -all | grep -aB3 -A17 "${NETWORK_INTERFACE_SELECTOR_DESC}" | grep phy | awk '{print $NF}')


echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- Here are the Mac Address and "
echo "# --- --- IPv4 Address of the Virtual Box"
echo "# --- --- Host Machine (Hardware machine) #"
echo "# --- --- network interface configured for all VirtualBox VMs"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# - VBOX_HOST_NET_INT_IPV4_ADDR=[${VBOX_HOST_NET_INT_IPV4_ADDR}] -- - #"
echo "# - VBOX_HOST_NET_INT_MAC_ADDR=[${VBOX_HOST_NET_INT_MAC_ADDR}] -- - #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"

echo "${VBOX_HOST_NET_INT_IPV4_ADDR}" > ${POKUS_SPIT_FILE}

echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- ---  #"
echo "# --- --- The [${POKUS_SPIT_FILE}] has been generated, "
echo "# --- --- it contains the IPv4 address"
echo "# --- --- of the Virtual Box Host Machine (Hardware machine)"
echo "# --- --- network interface configured for all VirtualBox VMs"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"
echo "# --- --- --- --- --- --- --- --- --- --- --- --- --- --- #"

