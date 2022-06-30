var arp = require('arpjs');

const NEIGHBOORHOOD_CENTER = process.env.POKUS_NEIGHBOORHOOD_CENTER_IPADDR || '192.168.98.202'
let src_ip_addr = '10.105.50.100'

//
arp.send({
    'op': 'request',
    'src_ip': '10.105.50.100', // that 's the IPv4 Address of the sender machine net interface (the TP Link WIfi Network Adapter in my case)
    'dst_ip': '10.105.50.1', // That''s the IP Address of the VM creaated by Packer
    'src_mac': '8f:3f:20:33:54:44', /// that's the MAC address of the sender machine net interface (the TP Link WIfi Network Adapter in my case)
    'dst_mac': 'ff:ff:ff:ff:ff:ff' //this FFFFFFFFF adddress is the broadcast address, it shall never change, it just means send to everyone on same network (L2).
    })