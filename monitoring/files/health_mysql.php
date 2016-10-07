<?php

# Managed by Salt Stack. Do NOT edit Manually!

/**
 * MySQL <=> PHP health check over CLI or HTTP
 *
 * Use:
 * - Create a health check user in MySQL
 *
 *     CREATE USER 'health'@'%' IDENTIFIED BY 'health';
 *     GRANT SELECT on mysql.* TO 'health'@'%';
 *
 * - Run either from the CLI or using a Web Server
 **/

$username='health';
$password='health';
$database='mysql';

/** ============ DO NOT EDIT BELOW ============ **/

$is_http = (isset($_SERVER['HTTP_USER_AGENT'])) ? true : false;

if ($is_http) {
  header('Content-Type: text/plain');
  header('Cache-Control: private');
}

try {
  if (!ini_get('mysqli.default_socket')) {
    $message = 'mysqli.default_socket PHP ini setting is not set, we cannot use this health check';
    throw new Exception($message);
  }

  $mysqli = new mysqli(null, $username, $password, $database);
  if ($mysqli->connect_error) {
    $message = sprintf('Connect error %s: %s', $mysqli->connect_errno, $mysqli->connect_error);
    throw new Exception($message);
  }

  if ($mysqli->ping()) {
    if ($is_http) {
      header('HTTP/1.1 200 OK');
    }
    printf('OK!'.PHP_EOL);
  } else {
    $message = sprintf('Error: %s', $mysqli->error);
    throw new Exception($message);
  }

  $mysqli->close();
} catch(Exception $e) {
  if ($is_http) {
    header('HTTP/1.1 500 Internal Server Error');
  }
  $message = $e->getMessage();
  trigger_error($message);
  echo $message.PHP_EOL;
  exit(1);
}
