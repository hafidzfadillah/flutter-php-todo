<?php
    require_once("koneksi.php"); //memanggil file koneksi

    $sql = null; //menginisialisasi query kosong

    //cek apakah ada hit ke api dengan param "show"
    if(isset($_GET['id'])) {
        $param = $_GET['id']; //ambil data pada param "show"

        $sql = "DELETE FROM tbl_todos WHERE todo_id=".$param;

        $result = $conn->query($sql); //eksekusi query

        //eksekusi query
        if(mysqli_query($conn, $sql)) {
            $response = array('status' => 201, 'message' => 'Data berhasil dihapus');
            echo json_encode($response);
        } else {
            $response = array('status' => 400, 'message' => "Terjadi kesalahan: ".mysqli_error($conn));
            echo json_encode($response);
        }

        mysqli_close($conn); // tutup koneksi
    } else {
        //jika parameter tidak lengkap
        $response = array('status' => 500, 'message' => 'Parameter tidak cukup');
        echo json_encode($response);
    }
?>

