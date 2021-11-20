import 'dart:convert';

GetData getDataFromJson(String str) => GetData.fromJson(json.decode(str));

String getDataToJson(GetData data) => json.encode(data.toJson());

class GetData {
  GetData({
    required this.users,
  });
  late final Users users;

  GetData.fromJson(Map<String, dynamic> json) {
    users = Users.fromJson(json['users']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['users'] = users.toJson();
    return _data;
  }
}

class Users {
  Users({
    required this.id,
    required this.username,
    required this.Fullname,
    required this.status,
    required this.token,
  });
  late final String id;
  late final String username;
  late final String Fullname;
  late final List<Status> status;
  late final String token;

  Users.fromJson(Map<String, dynamic> json) {
    id = json['_id'];
    username = json['username'];
    Fullname = json['Fullname'];
    status = List.from(json['status']).map((e) => Status.fromJson(e)).toList();
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['_id'] = id;
    _data['username'] = username;
    _data['Fullname'] = Fullname;
    _data['status'] = status.map((e) => e.toJson()).toList();
    _data['token'] = token;
    return _data;
  }
}

class Status {
  Status({
    required this.name,
    required this.st,
  });
  late final String name;
  late final int st;

  Status.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    st = json['st'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['st'] = st;
    return _data;
  }
}
