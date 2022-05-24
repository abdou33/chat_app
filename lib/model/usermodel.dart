class UserModel {
  String? uid;
  String? username;

  UserModel({this.uid, this.username});

  //data from the server
  factory UserModel.fromMap(map) {
    return UserModel(
      uid: map['uid'],
      username: map['username'],
    );
  }

  //send data to server

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'username': username,
    };
  }
}
