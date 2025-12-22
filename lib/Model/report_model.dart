class ReportModel {
  bool? _error;
  String? _status;
  List<Report>? _report;

  ReportModel({bool? error, String? status, List<Report>? report}) {
    if (error != null) {
      this._error = error;
    }
    if (status != null) {
      this._status = status;
    }
    if (report != null) {
      this._report = report;
    }
  }

  bool? get error => _error;
  set error(bool? error) => _error = error;
  String? get status => _status;
  set status(String? status) => _status = status;
  List<Report>? get report => _report;
  set report(List<Report>? report) => _report = report;

  ReportModel.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
    _status = json['status'];
    if (json['Report'] != null) {
      _report = <Report>[];
      json['Report'].forEach((v) {
        _report!.add(new Report.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    data['status'] = this._status;
    if (this._report != null) {
      data['Report'] = this._report!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Report {
  String? _caseNo;
  String? _patientName;
  String? _testName;
  String? _caseDate;
  String? _testFile;
  String? _mobile;

  Report(
      {String? caseNo,
        String? patientName,
        String? testName,
        String? caseDate,
        String? testFile,
        String? mobile}) {
    if (caseNo != null) {
      this._caseNo = caseNo;
    }
    if (patientName != null) {
      this._patientName = patientName;
    }
    if (testName != null) {
      this._testName = testName;
    }
    if (caseDate != null) {
      this._caseDate = caseDate;
    }
    if (testFile != null) {
      this._testFile = testFile;
    }
    if (mobile != null) {
      this._mobile = mobile;
    }
  }

  String? get caseNo => _caseNo;
  set caseNo(String? caseNo) => _caseNo = caseNo;
  String? get patientName => _patientName;
  set patientName(String? patientName) => _patientName = patientName;
  String? get testName => _testName;
  set testName(String? testName) => _testName = testName;
  String? get caseDate => _caseDate;
  set caseDate(String? caseDate) => _caseDate = caseDate;
  String? get testFile => _testFile;
  set testFile(String? testFile) => _testFile = testFile;
  String? get mobile => _mobile;
  set mobile(String? mobile) => _mobile = mobile;

  Report.fromJson(Map<String, dynamic> json) {
    _caseNo = json['case_no'];
    _patientName = json['patient_name'];
    _testName = json['test_name'];
    _caseDate = json['case_date'];
    _testFile = json['test_file'];
    _mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_no'] = this._caseNo;
    data['patient_name'] = this._patientName;
    data['test_name'] = this._testName;
    data['case_date'] = this._caseDate;
    data['test_file'] = this._testFile;
    data['mobile'] = this._mobile;
    return data;
  }
}
