var level = require('level');    
var path = require('path');

/**
 * A singleton module that exports a LevelDB database.
 */

// --

/**
 * ---------------------------------
 * 'dbPath' :
 * ---------------------------------
 * 
 *   This path is the path of the directory where LevelDB will store its files. 
 *   This directory should be fully dedicated to LevelDB, and may not exist at the beginning.
 * 
 * ---------------------------------
 * 
 **/
var dbPath = process.env.POKUS_SCANNER_DB_PATH || path.join(__dirname, 'mydb');    
var db = level(dbPath);

// --

module.exports = db;

