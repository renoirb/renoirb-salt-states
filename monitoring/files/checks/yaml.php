<?php

/**
 * Incomplete. See mysql.php
 * See also https://github.com/php/pecl-file_formats-yaml
 */

$outcome = false;

if (extension_loaded('yaml')) {
    $outcome = true;
}

if ($outcome !== true)
    throw new \Exception('YAML PHP Extension is not installed');
