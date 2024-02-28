
class ReplyComment {
  String _id;
  int _numberOfLikes;
  String _commentContent;
  DateTime _dateComment;
  Map _user;
  String _idComment;

  ReplyComment(this._id, this._numberOfLikes, this._commentContent,
      this._dateComment, this._user, this._idComment);


  String get id => _id;

  set id(String value) {
    _id = value;
  }
  int get numberOfLikes => _numberOfLikes;

  set numberOfLikes(int value) {
    _numberOfLikes = value;
  }

  String get commentContent => _commentContent;

  set commentContent(String value) {
    _commentContent = value;
  }

  DateTime get dateComment => _dateComment;

  set dateComment(DateTime value) {
    _dateComment = value;
  }

  Map get user => _user;

  set user(Map value) {
    _user = value;
  }

  String get idComment => _idComment;

  set idComment(String value) {
    _idComment = value;
  }
}
