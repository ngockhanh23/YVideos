class NotificationUser{
  String _id;
  Map _user;
  int _type;
  bool _status;
  String _content;
  String _videoID;
  DateTime _dateNotification;

  NotificationUser(this._id, this._user, this._type, this._status, this._content,
      this._videoID, this._dateNotification);

  DateTime get dateNotification => _dateNotification;

  set dateNotification(DateTime value) {
    _dateNotification = value;
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

  Map get user => _user;

  set user(Map value) {
    _user = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}