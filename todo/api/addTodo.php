<?php
    require_once("koneksi.php"); // memanggil file koneksi

    //jalankan jika 3 nilai parameter tersedia
    if(isset($_GET['title']) && isset($_GET['desc']) && isset($_GET['deadline']) && isset($_GET['uid'])) {
        $uid = $_GET['uid'];
        $title = $_GET['title'];
        $desc = $_GET['desc'];
        $dl = $_GET['deadline']; 
        // $deadline = DateTime::createFromFormat('U',$dl);
        $timestamp = date("Y-m-d h:i:s"); //current datetime

        //query tambah data
        $sql = "INSERT INTO tbl_todos (todo_id, todo_title, todo_desc, todo_status, todo_deadline, user_uid, timestamp) VALUES (NULL, '$title', '$desc', '0', '".$dl."', '$uid', '$timestamp')";

        //eksekusi query
        if(mysqli_query($conn, $sql)) {
            $response = array('status' => 201, 'message' => 'Data berhasil disimpan');
            echo json_encode($response);
        } else {
            $response = array('status' => 400, 'message' => "Terjadi kesalahan: ".mysqli_error($conn));
            echo json_encode($response);
        }

        mysqli_close($conn); // tutup koneksi
    } else {
        $response = array('status' => 500, 'message' => 'Parameter tidak cukup');
            echo json_encode($response);
    }
?>
