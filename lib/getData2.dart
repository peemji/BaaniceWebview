// To parse this JSON data, do
//
//     final getData = getDataFromJson(jsonString);

import 'dart:convert';

GetData getDataFromJson(String str) => GetData.fromJson(json.decode(str));

String getDataToJson(GetData data) => json.encode(data.toJson());

class GetData {
  var status;

  GetData({
    required this.id,
    required this.username,
    required this.fullname,
    this.status,
    required this.token,
  });

  String id;
  String username;
  String fullname;
  //List<Status> status;
  String token;

  factory GetData.fromJson(Map<String, dynamic> json) => GetData(
        id: json["_id"] == null ? null : json["_id"],
        username: json["username"] == null ? null : json["username"],
        fullname: json["Fullname"] == null ? null : json["Fullname"],
        //status: json["status"] == null ? null : List<Status>.from(json["status"].map((x) => Status.fromJson(x))),
        token: json["token"] == null ? null : json["token"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id == null ? null : id,
        "username": username == null ? null : username,
        "Fullname": fullname == null ? null : fullname,
        //"status": status == null ? null : List<dynamic>.from(status.map((x) => x.toJson())),
        "token": token == null ? null : token,
      };
}
