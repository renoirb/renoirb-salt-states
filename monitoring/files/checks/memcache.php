<?php

/**
 * Incomplete. See mysql.php
 * Also, make one check per Memcache extension (memcached, memcache)
 */

// create PECL memcached Object
$m = new Memcached();

// add a server, connection is established lazily as far as I know
$m->addServer( 'localhost', 11211 );

$tests[0] = ['val'=> 1, 'expected' => 1, 'desc' => 'Integer 1 should be intact'];
$tests[1] = ['val'=> 1, 'expected' => 1, 'desc' => 'Integer 1 incremented by 1'];
$tests[2] = ['val'=> 1, 'expected' => 0, 'desc' => 'Integer 1 decremented by 1'];
$tests[3] = ['val'=> 'I am a string', 'expected' => 'I am a string', 'desc' => 'A string should not be tampered'];
$tests[4] = ['val'=> ['a','b',1], 'expected' => ['a','b',1], 'desc' => 'An array should be the same back out'];
$tests[5] = ['val'=> 1.1, 'expected' => 1.1, 'desc' => 'Float 1.1 should be intact'];
$tests[6] = ['val'=> true, 'expected' => true, 'desc' => 'Boolean true should remain'];
$tests[7] = ['val'=> (object)array('key1' => 'value1'), 'expected' => (object)array('key1' => 'value1'), 'desc' => 'Object should be untouched'];

// set values, those are written into your server's memory using the memcached server
$m->set( 'integer', 1 );
$m->set( 'intIncrement', 1 );
$m->set( 'intDecrement', 1 );
$m->set( 'string', 'I am a string' );
$m->set( 'array', array( 'a', 'b', 'c' ) );

// increment
$m->increment( 'intIncrement' );

// decrement
$m->decrement( 'intDecrement' );

// get values again
echo 'Should be integer:'.PHP_EOL;
var_dump ( $m->get( 'integer' ) );
echo PHP_EOL.'Should be integer: '.PHP_EOL;
var_dump ( $m->get( 'intIncrement' ) );
echo PHP_EOL.'Should be integer: '.PHP_EOL;
var_dump ( $m->get( 'intDecrement' ) );
echo PHP_EOL.'Should be string: '.PHP_EOL;
var_dump ( $m->get( 'string' ) );
echo PHP_EOL.'Should be array: '.PHP_EOL;
var_dump ( $m->get( 'array' ) );

// delete values
$m->delete( 'integer' );
$m->delete( 'intIncrement' );
$m->delete( 'intDecrement' );
$m->delete( 'string' );
$m->delete( 'array' );

// close connection
$m->close();
