class CaseNumberModel {
  String? _error;
  String? _status;
  String? _caseNumber;

  CaseNumberModel({String? error, String? status, String? caseNumber}) {
    if (error != null) {
      this._error = error;
    }
    if (status != null) {
      this._status = status;
    }
    if (caseNumber != null) {
      this._caseNumber = caseNumber;
    }
  }

  String? get error => _error;
  set error(String? error) => _error = error;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get caseNumber => _caseNumber;
  set caseNumber(String? caseNumber) => _caseNumber = caseNumber;

  CaseNumberModel.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
    _status = json['status'];
    _caseNumber = json['CaseNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    data['status'] = this._status;
    data['CaseNumber'] = this._caseNumber;
    return data;
  }
}
