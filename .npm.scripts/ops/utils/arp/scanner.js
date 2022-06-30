var arp = require('arpjs');

const NEIGHBOORHOOD_CENTER = process.env.POKUS_NEIGHBOORHOOD_CENTER_IPADDR || '192.168.98.202'
let src_ip_addr = '10.105.50.100'

// this will be like sending a ping to a given IP address
// I need to run a lot of pings as quickly as possible, so in multithreading : https://medium.com/@mohllal/node-js-multithreading-a5cd74958a67
// ---
arp.send({
    'op': 'request',
    'src_ip': '10.105.50.100', // that 's the IPv4 Address of the sender machine net interface (the TP Link WIfi Network Adapter in my case)
    'dst_ip': '10.105.50.1', // That''s the IP Address of the VM creaated by Packer
    'src_mac': '8f:3f:20:33:54:44', /// that's the MAC address of the sender machine net interface (the TP Link WIfi Network Adapter in my case)
    'dst_mac': 'ff:ff:ff:ff:ff:ff' //this FFFFFFFFF adddress is the broadcast address, it shall never change, it just means send to everyone on same network (L2).
    })


/**
 * A few examples showing that other tools use the 
 * same technique (pinging all IP Addresses) to discover the IP Address assigned to a given MAC Address by a DHCP server : 
 * 
 * https://www.comparitech.com/net-admin/how-to-find-an-ip-address-using-a-mac-address/
 * 
 * 
 * Ok there seem to be problems using arpjs on Window, and that 
 *  -> https://github.com/mscdex/cap is better integrated to Windows, and 
 *  -> https://github.com/mscdex/cap allows sending ARP request, just as arpjs! (i tried installing npm i --save cap it works without error !)
 *  
 */