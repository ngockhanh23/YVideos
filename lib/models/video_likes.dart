class VideoLikesByUser{
  String _id;
  String _videoID;
  String _userID;

  VideoLikesByUser(this._id, this._videoID, this._userID);

  String get userID => _userID;

  set userID(String value) {
    _userID = value;
  }

  String get videoID => _videoID;

  set videoID(String value) {
    _videoID = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}