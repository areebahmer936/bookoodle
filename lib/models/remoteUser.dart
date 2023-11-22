class RemoteUser {
  late String fName;
  late String uid;

  RemoteUser({required this.fName, required this.uid});

  RemoteUser.fromJson(Map<String, dynamic> json) {
    fName = json['fName'];
    uid = json['uid'];
  }
}
