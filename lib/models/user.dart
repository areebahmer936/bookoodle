class UserModel {
  UserModel(
      {required this.uid,
      required this.email,
      required this.fName,
      required this.lName,
      required this.favGenres,
      required this.configured});
  late final String uid;
  late final String email;
  late final String fName;
  late final String lName;
  late final bool configured;
  late final List<String> favGenres;

  UserModel.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    email = json['email'];
    fName = json['fName'];
    lName = json['lName'];
    configured = json['configured'];
    favGenres = List.castFrom<dynamic, String>(json['favGenres']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['uid'] = uid;
    _data['email'] = email;
    _data['fName'] = fName;
    _data['lName'] = lName;
    _data['configured'] = configured;
    _data['favGenres'] = favGenres;
    return _data;
  }
}
