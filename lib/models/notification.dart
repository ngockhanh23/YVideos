class NotificationUser{
  String _id;
  String _userID;
  String _userNotification;
  int _type;
  bool _status;
  String _content;
  String _videoID;
  DateTime _dateNotification;

  NotificationUser(this._id, this._userID,this._userNotification, this._type, this._status, this._content,
      this._videoID, this._dateNotification);

  DateTime get dateNotification => _dateNotification;

  set dateNotification(DateTime value) {
    _dateNotification = value;
  }


  String get userNotification => _userNotification;

  set userNotification(String value) {
    _userNotification = value;
  }

  String get videoID => _videoID;

  set videoUrl(String value) {
    _videoID = value;
  }

  String get content => _content;

  set content(String value) {
    _content = value;
  }

  int get type => _type;

  set type(int value) {
    _type = value;
  }


  bool get status => _status;

  set status(bool value) {
    _status = value;
  }

  String get userID => _userID;

  set user(String value) {
    _userID = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}