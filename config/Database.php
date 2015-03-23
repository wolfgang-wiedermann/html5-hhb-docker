<?php

function getDbConnection() {
    $db = mysqli_connect("localhost", "fibu", "fibu");
    mysqli_select_db($db, "fibu");
    return $db;
}

?>
