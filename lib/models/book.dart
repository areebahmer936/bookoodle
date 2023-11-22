class Book {
  Book({
    required this.bookName,
    required this.bookAuthor,
    required this.bookPictureUrl,
    required this.bookGenre,
    required this.uid,
  });
  late final String bookName;
  late final String bookAuthor;
  late final String bookPictureUrl;
  late final String uid;
  late final List<String> bookGenre;

  Book.fromJson(Map<String, dynamic> json) {
    bookName = json['bookName'];
    bookAuthor = json['bookAuthor'];
    bookPictureUrl = json['bookPictureUrl'];
    uid = json['uid'];
    bookGenre = List.castFrom<dynamic, String>(json['bookGenre']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['bookName'] = bookName;
    _data['bookAuthor'] = bookAuthor;
    _data['bookPictureUrl'] = bookPictureUrl;
    _data['uid'] = uid;
    _data['bookGenre'] = bookGenre;
    return _data;
  }
}
