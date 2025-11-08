class UsernameModel {
  String? _error;
  String? _message;
  List<String>? _username;

  UsernameModel({String? error, String? message, List<String>? username}) {
    if (error != null) {
      this._error = error;
    }
    if (message != null) {
      this._message = message;
    }
    if (username != null) {
      this._username = username;
    }
  }

  String? get error => _error;
  set error(String? error) => _error = error;
  String? get message => _message;
  set message(String? message) => _message = message;
  List<String>? get username => _username;
  set username(List<String>? username) => _username = username;

  UsernameModel.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
    _message = json['message'];
    _username = json['Username'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    data['message'] = this._message;
    data['Username'] = this._username;
    return data;
  }
}
