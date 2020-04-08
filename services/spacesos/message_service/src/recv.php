<?php
    $user = $_GET['user'];

    chdir("/tmp/messages");
    echo file_get_contents(path_normalize($user)) ?? "";
