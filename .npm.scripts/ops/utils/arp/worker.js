
/**
 * ---------------------------------
 * 'dbPath' :
 * ---------------------------------
 * 
 * 
 * ---------------------------------
 * 
 **/

// workerData is used for fetching the data from the thread and parentPort is used for manipulating the thread
const { workerData, parentPort } = require('worker_threads');

// log some stuff
console.log(`Write-up on how ${workerData} wants to chill with the big boys`);

// The postMessage() method is used for posting the given message in the console by taking the filename as fetched by workerData
parentPort.postMessage({ filename: workerData, status: 'Done'});
