class Comment{
  String _id;
  String _commentContent;
  int _numberOfLikes;
  DateTime _dateComment;

  String _userID;
  String _idVideo;

  Comment(this._id, this._commentContent, this._numberOfLikes,
      this._dateComment, this._userID, this._idVideo);

  String get idVideo => _idVideo;

  set idVideo(String value) {
    _idVideo = value;
  }


  DateTime get dateComment => _dateComment;

  set dateComment(DateTime value) {
    _dateComment = value;
  }

  int get numberOfLikes => _numberOfLikes;

  set numberOfLikes(int value) {
    _numberOfLikes = value;
  }

  String get commentContent => _commentContent;

  set commentContent(String value) {
    _commentContent = value;
  }


  String get userID => _userID;

  set userID(String value) {
    _userID = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}