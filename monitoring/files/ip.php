<?php

header('Content-Type: text/plain');
header('Cache-Control: private');

die((isset($_SERVER['HTTP_X_FORWARDED_FOR']))?$_SERVER['HTTP_X_FORWARDED_FOR']:$_SERVER['REMOTE_ADDR']);
