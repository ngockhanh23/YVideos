class Video {
  String _id;
  String _videoUrl;
  String _contentVideo;

  DateTime _dateUpload;
  int _privacyViewer ;
  String _userID;

  Video(this._id, this._videoUrl, this._contentVideo,
      this._dateUpload,this._privacyViewer,this._userID);

  Video.empty()
      : _id = '',
        _videoUrl = '',
        _contentVideo = '',
        _dateUpload = DateTime.now(),
        _privacyViewer = 0,
        _userID = '';



  DateTime get dateUpload => _dateUpload;

  set dateUpload(DateTime value) {
    _dateUpload = value;
  }



  String get contentVideo => _contentVideo;

  set contentVideo(String value) {
    _contentVideo = value;
  }

  String get videoUrl => _videoUrl;

  set videoUrl(String value) {
    _videoUrl = value;
  }


  int get privacyViewer => _privacyViewer;

  set privacyViewer(int value) {
    _privacyViewer = value;
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