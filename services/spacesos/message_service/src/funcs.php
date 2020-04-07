<?php

function path_normalize($path){
    $root = ($path[0] === '/') ? '/' : '';

    $segments = preg_split('/\//', trim($path, '/'));
    $ret = array();
    foreach($segments as $segment){
        if ($segment == '.') {
            continue;
        }
        if ($segment == '..') {
            array_pop($ret);
        } else {
            array_push($ret, $segment);
        }
    }
    return $root . implode('/', $ret);
}

