
const NEIGHBOORHOOD_CENTER = process.env.POKUS_NEIGHBOORHOOD_CENTER_IPADDR || '192.168.98.202'
let src_ip_addr = '10.105.50.100'
console.log(`process.env.TARGET_IP_ADDR_TO_PING   is ${process.env.TARGET_IP_ADDR_TO_PING}`)
let target_ip_addr_to_ping = process.env.TARGET_IP_ADDR_TO_PING || '192.168.98.157'

// this will be like sending a ping to a given IP address
// I need to run a lot of pings as quickly as possible, so in multithreading : https://medium.com/@mohllal/node-js-multithreading-a5cd74958a67
// ---


/**
 * Ok, this is great : 
 *   -> i now know how to send ARP 'who has' request, successfully received by my 'TP Link USB Wireless Network Adpater'
 *   -> this will be useful when i will play deep tests with MetalLb Kubernetes External LoadBalancer
 * ---
 * But what i want to do is "the same as sending a ping": 
 *   -> and that is th ICMP protocol, not ARP. 
 *   -> I thought of ARP because it is used by DHCP
 * ---
 * Ok, so here are infos i found about ICMP network programming in NodeJS : 
 * 
 * - Ping is the name of utility, which sends ICMP Echo requests to the known host and waits for the response. 
 * - https://blog.ipsumdomus.com/node-js-plain-icmp-ping-implementation-85ac0b319bc2
 * 
 * 
 * --
 * 
 * 
 * # For icmp npm package, on Winodows, Window Build Tools is required (see https://www.npmjs.com/package/icmp )
 * # (JBL I think NpCap won't hurt neither as Nmap and Wireshark)
 */


var icmp = require('icmp');
icmp.send(`${target_ip_addr_to_ping}`, "Hey, I'm sending a message!")
.then(obj => {
    console.log(`JBL : ICMP REQUEST SENT NO ERROR  `)
    /*
    if (obj.open) {
        console.log(`JBL I did receive the ICMP answer : `)
        console.log(JSON.stringify(obj, ' ', 4))
    } else {
        console.log(`JBL I did receive the ICMP answer : `)
        console.log(JSON.stringify(obj, ' ', 4))
    }
    */
    if (obj.open) {
        console.log(`JBL I successfully pinged [${obj.host}] `)
        console.log(`JBL I discovered [obj.host]=[${obj.host}], and is [obj.ip]=[${obj.ip}] `)
    } else {
        console.log(`JBL I failed to ping [${obj.host}] :  `)
        console.log(`JBL [${obj.host}] is probably not assigned in this network `)
    }
    console.log(`JBL ICMP Response code is : [${obj.code}] `)
    console.log(obj.open ? 'Done' : 'Failed')
})
.catch(err => {
    console.log(`JBL : ICMP REQUEST SENT WITH ERRORS!!! :  `)
    console.log(err)
});