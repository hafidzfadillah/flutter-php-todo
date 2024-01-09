import 'dart:convert';

class ModelUser {
    String userId;
    String userUid;
    String userEmail;
    String userNama;
    String userImg;

    ModelUser({
        required this.userId,
        required this.userUid,
        required this.userEmail,
        required this.userNama,
        required this.userImg,
    });

    factory ModelUser.fromRawJson(String str) => ModelUser.fromJson(json.decode(str));

    String toRawJson() => json.encode(toJson());

    factory ModelUser.fromJson(Map<String, dynamic> json) => ModelUser(
        userId: json["user_id"],
        userUid: json["user_uid"],
        userEmail: json["user_email"],
        userNama: json["user_nama"],
        userImg: json["user_img"],
    );

    Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_uid": userUid,
        "user_email": userEmail,
        "user_nama": userNama,
        "user_img": userImg,
    };
}
