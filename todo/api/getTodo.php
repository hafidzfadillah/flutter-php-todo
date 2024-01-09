<?php
    require_once("koneksi.php"); //memanggil file koneksi

    $sql = null; //menginisialisasi query kosong

    //cek apakah ada hit ke api dengan param "show"
    if(isset($_GET['uid'])) {
        $param = $_GET['uid']; //ambil data pada param "show"

        $sql = "SELECT * FROM tbl_todos WHERE user_uid='".$param."'";

        $result = $conn->query($sql); //eksekusi query
        $response = array('status' => 200, 'data' => array()); // buat array kosong

        //jika data ditemukan
        if($result->num_rows >0){
            

            //looping memasukkan data ke $response
            while ($row = $result->fetch_assoc()) {
                $response['data'][] = $row;
            }

            //encode array ke bentuk json
            echo json_encode($response);
        } else {
            //jika tidak ada data ditemukan
            echo json_encode($response);
        }

        $conn->close(); // tutup koneksi
    } else {
        //jika parameter tidak lengkap
        $response = array('status' => 500, 'message' => 'Parameter tidak cukup');
        echo json_encode($response);
    }
?>

