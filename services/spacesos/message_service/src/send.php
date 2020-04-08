<?php
    $url = parse_url($_GET['q'])['path'];

    $user = substr($url, strlen('/send/'));

    $message = file_get_contents("php://input");

    if(!$user)
        die("no user");

    if(!$message)
        die("no message");

    chdir("/tmp/messages");
    $file = fopen(path_normalize($user), "a+");
    fwrite($file, $message . "\n");
    fclose($file);

    echo "<$user: ok>";