// const { ping } = require('./iptools');
const ping = require('./ping');

/**
 * ---------------------------------
 * 'Worker' :
 * ---------------------------------
 * 
 * 
 * ---------------------------------
 * 
 **/

// workerData is used for fetching the data from the thread and parentPort is used for manipulating the thread
const { workerData, parentPort } = require('worker_threads');
// here workerData  is an array of ip adresses to ping 

// log some stuff
console.log(` [Pokus] - [Hey I'm Worker Three] HEre are the Ipaddresses and network hosts this worker is gonna ping (send an ICMP echo request) : [ workerData = [${workerData}] ] `);




/**
 * --------------------------------------------------------------
 *    Actual IMP work
 * --------------------------------------------------------------
 */


var level = require('level');    
var path = require('path');

/**
 * level DB use : https://www.yld.io/blog/node-js-databases-using-leveldb/
 * 
 * We might use level db batches to scann all IP addresses ina /24 (255  different IP addresses)
 * 
 * each worker will write to the database. The database is a singleton, should id not be handed over to worker as theyr are instantiated ?
 * Will the Level DB Singleton be thread-safe ?
 */
var db = require('./db');



/**
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 * 
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 */


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
 * another npm package to try : https://www.npmjs.com/package/net-ping
 * 
 * Note that i certainly could send ICMP packets using 'cap'
 */


var icmp = require('icmp');

for ( i = 0 ; i < workerData.length ; i++ ) {
    ping(workerData[i]);
}

/**
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 *   Finishing worker
 */

// The postMessage() method is used for posting the given message in the console by taking the filename as fetched by workerData
parentPort.postMessage({ ipaddressesAndHosts: workerData, status: 'Scanned'});

