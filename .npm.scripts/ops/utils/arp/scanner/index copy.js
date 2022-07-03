const { Worker } = require('worker_threads')
const ping = require('./ping');
ping('192.168.1.101')
ping('192.168.1.102')

/**
 * Resources on Multi-Threading and NodeJs : 
 *   https://medium.com/@ocdkerosine/parallel-processing-with-multithreaded-node-js-1237ff101719
 *   https://www.npmjs.com/package/paralleljs => let's try this one ?
 */
const Parallel = require('paralleljs');

/**
 * First thread
 */
const p = new Parallel('forwards');
 
// Spawn a remote job (we'll see more on how to use then later)
function handleSpawn (data) {
    ping('192.168.98.77')
    ping('192.168.98.78')
    console.log(data);
    return data;
}
p.spawn(handleSpawn.bind(this)).then(data => {
    console.log(data) 
});

/**
 * Second thread
 */

const counter0 = 20
let thoseIpAddressesOrHosts0 = [ 
    `192.168.98.${counter0}`,
    `192.168.98.${counter0 + 1}`,
    `192.168.98.${counter0 + 2}`,
    `192.168.98.${counter0 + 3}`,
    `192.168.98.${counter0 + 4}`,
    `192.168.98.${counter0 + 5}`,
    `192.168.98.${counter0 + 6}`,
    `192.168.98.${counter0 + 7}`,
    `192.168.98.${counter0 + 8}`,
    `192.168.98.${counter0 + 9}`,
    `192.168.98.${counter0 + 11}`,
    `192.168.98.${counter0 + 12}`,
    `192.168.98.${counter0 + 13}`,
    `192.168.98.${counter0 + 14}`,
    `192.168.98.${counter0 + 15}`,
    `192.168.98.${counter0 + 16}`,
    `192.168.98.${counter0 + 17}`,
    `192.168.98.${counter0 + 18}`,
    `192.168.98.${counter0 + 19}`
]
const p2 = new Parallel(thoseIpAddressesOrHosts0);
// Spawn a remote job (we'll see more on how to use then later)
p2.spawn(thoseIpAddressesOrHosts => {
    // data = data.reverse();
    console.log(` # + --- + --- + --- + --- + --- + --- + --- + # `); 
    console.log(` # + --- + --- + Process 2 + --- + --- + # `); 
    console.log(` # + --- + --- + --- + --- + --- + --- + --- + # `); 
    console.log(` # + --- data :  `); 
    console.log(thoseIpAddressesOrHosts); 
    console.log(` # + --- + --- + --- + --- + --- + --- + --- + # `); 
    for ( i = 0 ; i < thoseIpAddressesOrHosts.length ; i++) {
        ping(thoseIpAddressesOrHosts[i])
    }
    return thoseIpAddressesOrHosts;
}).then(thoseIpAddressesOrHosts => {
    console.log(thoseIpAddressesOrHosts) 
});
