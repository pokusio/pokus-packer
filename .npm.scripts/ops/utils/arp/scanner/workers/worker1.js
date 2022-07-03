/**
 * ---------------------------------
 * 'Worker1' :
 * ---------------------------------
 * 
 * 
 * ---------------------------------
 * 
 **/

// workerData is used for fetching the data from the thread and parentPort is used for manipulating the thread
const { workerData, parentPort } = require('worker_threads');
// here workerData  is an array of ip adresses to ping 
// const { ping } = require('./iptools');
const ping = require('./../ping');

// log some stuff
console.log(` [Pokus] - [Hey I'm Worker [Worker1]] HEre are the Ipaddresses and network hosts this worker is gonna ping (send an ICMP echo request) : [ workerData = [${workerData}] ] `);




/**
 * --------------------------------------------------------------
 *    Actual ICMP work
 * --------------------------------------------------------------
 */

// The postMessage() method is used for posting the given message in the console by taking the filename as fetched by workerData
parentPort.postMessage({ ipaddressesAndHosts: workerData, status: 'Scanned'});
