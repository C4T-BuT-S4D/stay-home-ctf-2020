<?php
    include_once "funcs.php";

    $url = parse_url($_GET['q']);

    if(in_array($url['path'], ['/send/', '/send']))
        include_once "send.php";

    if(in_array($url['path'], ['/recv/', '/recv']))
        include_once "recv.php";
