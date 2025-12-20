class CaseEntryModel {
  bool? _error;
  String? _status;
  String? _message;
  String? _caseNo;

  CaseEntryModel(
      {bool? error, String? status, String? message, String? caseNo}) {
    if (error != null) {
      this._error = error;
    }
    if (status != null) {
      this._status = status;
    }
    if (message != null) {
      this._message = message;
    }
    if (caseNo != null) {
      this._caseNo = caseNo;
    }
  }

  bool? get error => _error;
  set error(bool? error) => _error = error;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get message => _message;
  set message(String? message) => _message = message;
  String? get caseNo => _caseNo;
  set caseNo(String? caseNo) => _caseNo = caseNo;

  CaseEntryModel.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
    _status = json['status'];
    _message = json['message'];
    _caseNo = json['caseNo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    data['status'] = this._status;
    data['message'] = this._message;
    data['caseNo'] = this._caseNo;
    return data;
  }
}
