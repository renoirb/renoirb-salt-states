<?php

/**
 * Incomplete. See mysql.php
 */

$mustache = new Mustache();
$some_number = 2;
$data = array(
  'name' => 'Mustache',
  'some_number' => $some_number,
  'bool_test_sample' => is_numeric($some_number)
);
echo $mustache->render(<<<EOF
This is {{name}}{{#bool_test_sample}}, and "{{some_number}}" should be "2"{{/bool_test_sample}}
EOF
, $data, []);
