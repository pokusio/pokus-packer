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
// const handleSpawn = (data) => {
function handleSpawn (data) {
    ping('192.168.98.77')
    ping('192.168.98.78')
    console.log(data);
    return data;
}
p.spawn(handleSpawn.bind(this)).then(data => {
    console.log(data) 
});
