<?php

/**
 * Incomplete. See mysql.php
 *
 * See https://paragonie.com/book/pecl-libsodium
 *     https://github.com/jedisct1/libsodium-php
 *     https://download.libsodium.org/doc/hashing/generic_hashing.html
 * Or use var_dump(!extension_loaded('libsodium'));
 */

$output = '';

try {
    $version = \Sodium\version_string();
    $output = sprintf('This is PHP LibSodium v%s', $version);
} catch(\Exception $e) {
    throw new \Exception('Sodium is NOT installed');
}

echo $output;
