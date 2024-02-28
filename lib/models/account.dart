class Account {

  String _userID;
  String _userName;
  String _avatarUrl;
  String _email;

  String get avatarUrl => _avatarUrl;

  set avatarUrl(String value) {
    _avatarUrl = value;
  }

  String _password;

  Account( this._userID, this._userName,this._avatarUrl, this._email, this._password);
  Account.empty()
      :
        _userID = '',
        _userName = '',
        _avatarUrl = '',
        _email = '',
        _password = '';

  String get password => _password;

  set password(String value) {
    _password = value;
  }

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get userName => _userName;

  set userName(String value) {
    _userName = value;
  }


  String get userID => _userID;

  set userID(String value) {
    _userID = value;
  }
}
