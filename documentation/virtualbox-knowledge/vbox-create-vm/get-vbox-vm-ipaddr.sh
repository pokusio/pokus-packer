#!/bin/bash


# ---
# In git bash on windows 
# --
# Should work fine on most GNU/Linux Distribs
# --
# 
export PATH="${PATH}:/c/jibl_vbox/install"
vboxmanage --version

# --- 
export VBOX_VM_NAME=${VBOX_VM_NAME:-"packer-virtualbox-iso-1656194566"}
export NETWORK_INT_SELECTOR="Intel(R) Ethernet Connection I217-LM"
export NETWORK_INT_SELECTOR="TP-Link Wireless USB Adapter"

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


export COMP1=$(echo ${VM_IP_ADDR} | awk  -F '.' '{print $0}')
export COMP2=$(echo ${VM_IP_ADDR} | awk  -F '.' '{print $1}')
export COMP3=$(echo ${VM_IP_ADDR} | awk  -F '.' '{print $2}')
export COMP4=$(echo ${VM_IP_ADDR} | awk  -F '.' '{print $3}')

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

exit 0

arp -s 157.55.85.212   ${FMT_VM_MAC_ADDRESS}


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
