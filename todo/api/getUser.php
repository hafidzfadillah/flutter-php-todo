<?php
    require_once("koneksi.php"); //memanggil file koneksi

    $sql = "SELECT * FROM tbl_users";

        $result = $conn->query($sql); //eksekusi query
        $response = array('status' => 200, 'data' => array()); // buat array kosong

        //jika data ditemukan
        if($result->num_rows >0 ){
            

            //looping memasukkan data ke $response
            while ($row = $result->fetch_assoc()) {
                $response['data'][] = $row;
            }

            //encode array ke bentuk json
            echo json_encode($response);
        } else {
            //jika tidak ada data ditemukan
            echo "Tidak ada data ditemukan";
        }

        $conn->close(); // tutup koneksi
?>

