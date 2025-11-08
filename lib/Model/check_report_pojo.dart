class CheckReportPojo {
  bool? _status;
  String? _message;
  String? _path;

  CheckReportPojo({bool? status, String? message, String? path}) {
    if (status != null) {
      this._status = status;
    }
    if (message != null) {
      this._message = message;
    }
    if (path != null) {
      this._path = path;
    }
  }

  bool? get status => _status;
  set status(bool? status) => _status = status;
  String? get message => _message;
  set message(String? message) => _message = message;
  String? get path => _path;
  set path(String? path) => _path = path;

  CheckReportPojo.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _message = json['message'];
    _path = json['path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['message'] = this._message;
    data['path'] = this._path;
    return data;
  }
}
