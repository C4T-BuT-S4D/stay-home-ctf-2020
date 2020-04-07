<?php
    $user = $_POST['user'];
    $message = $_POST['message'];

    if(!$user)
        die("no user");

    if(!$message)
        die("no message");

    chdir("/tmp/messages");
    $file = fopen(path_normalize($user), "a+");
    fwrite($file, $message . "\n");
    fclose($file);

    echo "ok";
