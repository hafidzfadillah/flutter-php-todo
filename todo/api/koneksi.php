<?php
    $servername = "localhost"; //nama host
    $username = "root"; //username database
    $password = ""; //password user root
    $database = "db_todos"; //nama database

    //melakukan koneksi terhadap database
    $conn = new mysqli($servername, $username, $password, $database);

    // jika terjadi error saat koneksi, hentikan proses dan tampilkan error
    if($conn->connect_error) {
        die("Koneksi gagal: ".$conn->connect_error);
    }
?>
