// var arp = require('arpjs');
var arp = require('cap');

const NEIGHBOORHOOD_CENTER = process.env.POKUS_NEIGHBOORHOOD_CENTER_IPADDR || '192.168.98.202'
let src_ip_addr = '10.105.50.100'

// this will be like sending a ping to a given IP address
// I need to run a lot of pings as quickly as possible, so in multithreading : https://medium.com/@mohllal/node-js-multithreading-a5cd74958a67
// ---


/*
arp.send({
    'op': 'request',
    'src_ip': '10.105.50.100', // that 's the IPv4 Address of the sender machine net interface (the TP Link WIfi Network Adapter in my case)
    'dst_ip': '10.105.50.1', // That''s the IP Address of the VM creaated by Packer
    'src_mac': '8f:3f:20:33:54:44', /// that's the MAC address of the sender machine net interface (the TP Link WIfi Network Adapter in my case)
    'dst_mac': 'ff:ff:ff:ff:ff:ff' //this FFFFFFFFF adddress is the broadcast address, it shall never change, it just means send to everyone on same network (L2).
    })

*/

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


// with cap 

var Cap = require('cap').Cap;
var c = new Cap();
var device = Cap.findDevice('192.168.1.200'); /// that's the target IP i want to ping
var filter = 'arp';
var bufSize = 10 * 1024 * 1024;
var buffer = Buffer.alloc(65535);

var linkType = c.open(device, filter, bufSize, buffer);


// To use this example, change Source Mac, Sender Hardware Address (MAC) and Target Protocol address
var buffer = Buffer.from([
    // ETHERNET
    0xff, 0xff, 0xff, 0xff, 0xff,0xff,                  // 0    = Destination MAC (broadcast address like any ARP Request)
    0x84, 0x8F, 0x69, 0xB7, 0x3D, 0x92,                 // 6    = Source MAC (that's what i change as MAC Addresss of PAker Windows Host on TP Link USB Wifi Network Adpater)
    0x08, 0x06,                                         // 12   = EtherType = ARP
    // ARP
    0x00, 0x01,                                         // 14/0   = Hardware Type = Ethernet (or wifi)
    0x08, 0x00,                                         // 16/2   = Protocol type = ipv4 (request ipv4 route info)
    0x06, 0x04,                                         // 18/4   = Hardware Addr Len (Ether/MAC = 6), Protocol Addr Len (ipv4 = 4)
    0x00, 0x01,                                         // 20/6   = Operation (ARP, who-has)
    0x84, 0x8f, 0x69, 0xb7, 0x3d, 0x92,                 // 22/8   = Sender Hardware Addr (MAC) (that's what i change as MAC Addresss of PAker Windows Host on TP Link USB Wifi Network Adpater)
    0xc0, 0xa8, 0x01, 0xc8,                             // 28/14  = Sender Protocol address (ipv4)
    0x00, 0x00, 0x00, 0x00, 0x00, 0x00,                 // 32/18  = Target Hardware Address (Blank/nulls for who-has) (JBL: i leave this as is i think it should not be changed)
    0xc0, 0xa8, 0x01, 0xc9                              // 38/24  = Target Protocol address (ipv4)
]);

try {
  // send will not work if pcap_sendpacket is not supported by underlying `device`
  c.send(buffer, buffer.length);
} catch (e) {
  console.log("Error sending packet:", e);
}

// TCPDUMP.  Note: Some values are changed by the network stack when the broadcast arp message is received.
//12:28:33.230319 ARP, Ethernet (len 6), IPv4 (len 4), Request who-has 192.168.1.200 tell 192.168.1.199, length 46
//0x0000:  ffff ffff ffff 848f 69b7 3d92 0806 0001  ........i.=.....
//0x0010:  0800 0604 0001 848f 69b7 3d92 c0a8 01c7  ........i.=.....
//0x0020:  0000 0000 0000 c0a8 01c8 0000 0000 0000  ................
//0x0030:  0000 0000 0000 0000 0000 0000            ............
//12:28:33.230336 ARP, Ethernet (len 6), IPv4 (len 4), Reply 192.168.1.200 is-at 74:ea:3a:a3:e6:69, length 28
//0x0000:  848f 69b7 3d92 74ea 3aa3 e669 0806 0001  ..i.=.t.:..i....
//0x0010:  0800 0604 0002 74ea 3aa3 e669 c0a8 01c8  ......t.:..i....
//0x0020:  848f 69b7 3d92 c0a8 01c7                 ..i.=.....
