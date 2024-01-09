<?php
    require_once("koneksi.php"); // memanggil file koneksi

    //jalankan jika 3 nilai parameter tersedia
    if(isset($_GET['title']) && isset($_GET['desc']) && isset($_GET['deadline']) && isset($_GET['status']) && isset($_GET['id'])) {
        $uid = $_GET['id'];
        $title = $_GET['title'];
        $desc = $_GET['desc'];
        $status = $_GET['status'];
        $dl = $_GET['deadline']; 
        $timestamp = date("Y-m-d h:i:s"); //current datetime

        $sql = "UPDATE tbl_todos SET todo_title='".$title."', todo_desc='".$desc."', todo_status=".$status.", todo_deadline='".$dl."' WHERE todo_id=".$uid;

        //eksekusi query
        if(mysqli_query($conn, $sql)) {
            $response = array('status' => 201, 'message' => 'Data berhasil diupdate');
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
