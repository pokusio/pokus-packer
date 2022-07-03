const { Worker } = require('worker_threads')
const ping = require('./ping');

ping('192.168.1.101')
ping('192.168.1.102')

/**
 * Resources on Multi-Threading and NodeJs : https://medium.com/@ocdkerosine/parallel-processing-with-multithreaded-node-js-1237ff101719
 */


// function runWorkerFirst() runs the worker thread and returns a Promise
const runWorkerFirst = (workerData) => {
    return new Promise((resolve, reject) => {
        const worker = new Worker('./.npm.scripts/ops/utils/arp/scanner/worker.js', { workerData });
        worker.on('message', resolve);
        worker.on('error', reject);
        worker.on('exit', code => {
            if (code !== 0) reject(new Error(`'worker one' Worker Thread stopped with exit code ${code}`));
        });
    });
}

// function runWorkerTwo() runs the worker thread and returns a Promise
const runWorkerTwo = (workerData) => {
    return new Promise((resolve, reject) => {
        const worker = new Worker('./.npm.scripts/ops/utils/arp/scanner/workerPal.js', { workerData });
        worker.on('message', resolve);
        worker.on('error', reject);
        worker.on('exit', code => {
            if (code !== 0) reject(new Error(`'worker two' Worker Thread stopped with exit code ${code}`));
        });
    });
}


// function runWorkerThree() runs the worker thread and returns a Promise
const runWorkerThree = (workerData) => {
    return new Promise((resolve, reject) => {
        const worker = new Worker('./.npm.scripts/ops/utils/arp/scanner/workerThree.js', { workerData });
        worker.on('message', resolve);
        worker.on('error', reject);
        worker.on('exit', code => {
            if (code !== 0) reject(new Error(`'worker two' Worker Thread stopped with exit code ${code}`));
        });
    });
}
// function launchWorkerFirst() is used for calling the function runWorkerFirst() and giving the value for workerData
const launchWorkerFirst = async () => {
    const result = await runWorkerFirst('Tunde Ednut');
    console.log(result);
}

// function run() is used for calling the function launchWorkerTwo() and giving the value for workerData
const launchWorkerTwo = async () => {
    const result = await runWorkerTwo('Lars Ulrich');
    console.log(result);
}

// example thoseIpAddressesOrHosts = [ `192.168.98.${counter}`, `192.168.98.${counter + 1}`, `192.168.98.${counter + 2}` ]
const launchWorkerOn = async (thoseIpAddressesOrHosts) => {
    const result = await runWorkerThree({ ipaddresses_or_hosts: `${thoseIpAddressesOrHosts}`});
    console.log(result);
}
/*
launchWorkerFirst().catch(err => console.error(err));
launchWorkerTwo().catch(err => console.error(err));
 */






/**
 * 
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * 
 * Definition of all 12 Workers each eating 20 pings
 * 
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * 
 */


const runWorker1 = (workerData) => {
    return new Promise((resolve, reject) => {
        const worker = new Worker('./.npm.scripts/ops/utils/arp/scanner/workers/worker1.js', { workerData });
        worker.on('message', resolve);
        worker.on('error', reject);
        worker.on('exit', code => {
            if (code !== 0) reject(new Error(`'worker 1' Worker Thread stopped with exit code ${code}`));
        });
    });
}

const launchWorker1 = async (thoseIpAddressesOrHosts) => {
    const result = await runWorker1({ ipaddresses_or_hosts: `${thoseIpAddressesOrHosts}`});
    console.log(result);
}

const runWorker2 = (workerData) => {
    return new Promise((resolve, reject) => {
        const worker = new Worker('./.npm.scripts/ops/utils/arp/scanner/workers/worker2.js', { workerData });
        worker.on('message', resolve);
        worker.on('error', reject);
        worker.on('exit', code => {
            if (code !== 0) reject(new Error(`'worker 2' Worker Thread stopped with exit code ${code}`));
        });
    });
}

const launchWorker2 = async (thoseIpAddressesOrHosts) => {
    const result = await runWorker2({ ipaddresses_or_hosts: `${thoseIpAddressesOrHosts}`});
    console.log(result);
}
/**
 * 
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * 
 * 
 * 
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 * 
 */

const counter = 20
let thoseIpAddressesOrHosts = [ 
    `192.168.98.${counter}`,
    `192.168.98.${counter + 1}`,
    `192.168.98.${counter + 2}`,
    `192.168.98.${counter + 3}`,
    `192.168.98.${counter + 4}`,
    `192.168.98.${counter + 5}`,
    `192.168.98.${counter + 6}`,
    `192.168.98.${counter + 7}`,
    `192.168.98.${counter + 8}`,
    `192.168.98.${counter + 9}`,
    `192.168.98.${counter + 11}`,
    `192.168.98.${counter + 12}`,
    `192.168.98.${counter + 13}`,
    `192.168.98.${counter + 14}`,
    `192.168.98.${counter + 15}`,
    `192.168.98.${counter + 16}`,
    `192.168.98.${counter + 17}`,
    `192.168.98.${counter + 18}`,
    `192.168.98.${counter + 19}`
]

launchWorker1(thoseIpAddressesOrHosts).catch(err => console.error(err));


const counter2 = 60
let thoseIpAddressesOrHosts2 = [ 
    `192.168.98.${counter2}`,
    `192.168.98.${counter2 + 1}`,
    `192.168.98.${counter2 + 2}`,
    `192.168.98.${counter2 + 3}`,
    `192.168.98.${counter2 + 4}`,
    `192.168.98.${counter2 + 5}`,
    `192.168.98.${counter2 + 6}`,
    `192.168.98.${counter2 + 7}`,
    `192.168.98.${counter2 + 8}`,
    `192.168.98.${counter2 + 9}`,
    `192.168.98.${counter2 + 11}`,
    `192.168.98.${counter2 + 12}`,
    `192.168.98.${counter2 + 13}`,
    `192.168.98.${counter2 + 14}`,
    `192.168.98.${counter2 + 15}`,
    `192.168.98.${counter2 + 16}`,
    `192.168.98.${counter2 + 17}`,
    `192.168.98.${counter2 + 18}`,
    `192.168.98.${counter2 + 19}`
]

launchWorker2(thoseIpAddressesOrHosts2).catch(err => console.error(err));
/*
*/

/*
for ( counter = 0; counter < 253; counter+20) {
    let thoseIpAddressesOrHosts = [ 
        `192.168.98.${counter}`,
        `192.168.98.${counter + 1}`,
        `192.168.98.${counter + 2}`,
        `192.168.98.${counter + 3}`,
        `192.168.98.${counter + 4}`,
        `192.168.98.${counter + 5}`,
        `192.168.98.${counter + 6}`,
        `192.168.98.${counter + 7}`,
        `192.168.98.${counter + 8}`,
        `192.168.98.${counter + 9}`,
        `192.168.98.${counter + 11}`,
        `192.168.98.${counter + 12}`,
        `192.168.98.${counter + 13}`,
        `192.168.98.${counter + 14}`,
        `192.168.98.${counter + 15}`,
        `192.168.98.${counter + 16}`,
        `192.168.98.${counter + 17}`,
        `192.168.98.${counter + 18}`,
        `192.168.98.${counter + 19}`
    ]

    launchWorkerOn(thoseIpAddressesOrHosts).catch(err => console.error(err));
}
*/