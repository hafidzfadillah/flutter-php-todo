<?php
    require_once("koneksi.php"); // memanggil file koneksi

    //jalankan jika 3 nilai parameter tersedia
    if(isset($_GET['uid']) && isset($_GET['email']) && isset($_GET['nama']) && isset($_GET['img'])) {
        $uid = $_GET['uid'];
        $email = $_GET['email'];
        $nama = $_GET['nama'];
        $img = $_GET['img']; 
        $timestamp = date("Y-m-d h:i:s"); //current datetime

        // Check if data already exists in the database
        $checkSql = "SELECT * FROM tbl_users WHERE user_uid = '$uid'";
        $checkResult = $conn->query($checkSql);

        if ($checkResult->num_rows > 0) {
            $response = array('status' => 200, 'message' => 'Data already exists in the database');
            echo json_encode($response);
        } else {
            //query tambah data
            $sql = "INSERT INTO tbl_users (user_uid, user_nama, user_email, user_img, timestamp) VALUES ('$uid', '$nama', '$email', '$img', '$timestamp')";

            //eksekusi query
            if(mysqli_query($conn, $sql)) {
                $response = array('status' => 201, 'message' => 'Data berhasil disimpan');
                echo json_encode($response);
            } else {
                $response = array('status' => 400, 'message' => "Terjadi kesalahan: ".mysqli_error($conn));
                echo json_encode($response);
            }
        }

        mysqli_close($conn); // tutup koneksi
    } else {
        $response = array('status' => 500, 'message' => 'Parameter tidak cukup');
        echo json_encode($response);
    }
?>
