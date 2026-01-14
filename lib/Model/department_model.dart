class DepartmentModel {
  bool? _status;
  Filters? _filters;
  List<Summary>? _summary;
  List<DateWiseData>? _dateWiseData;

  DepartmentModel(
      {bool? status,
        Filters? filters,
        List<Summary>? summary,
        List<DateWiseData>? dateWiseData}) {
    if (status != null) {
      this._status = status;
    }
    if (filters != null) {
      this._filters = filters;
    }
    if (summary != null) {
      this._summary = summary;
    }
    if (dateWiseData != null) {
      this._dateWiseData = dateWiseData;
    }
  }

  bool? get status => _status;
  set status(bool? status) => _status = status;
  Filters? get filters => _filters;
  set filters(Filters? filters) => _filters = filters;
  List<Summary>? get summary => _summary;
  set summary(List<Summary>? summary) => _summary = summary;
  List<DateWiseData>? get dateWiseData => _dateWiseData;
  set dateWiseData(List<DateWiseData>? dateWiseData) =>
      _dateWiseData = dateWiseData;

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _filters =
    json['filters'] != null ? new Filters.fromJson(json['filters']) : null;
    if (json['summary'] != null) {
      _summary = <Summary>[];
      json['summary'].forEach((v) {
        _summary!.add(new Summary.fromJson(v));
      });
    }
    if (json['date_wise_data'] != null) {
      _dateWiseData = <DateWiseData>[];
      json['date_wise_data'].forEach((v) {
        _dateWiseData!.add(new DateWiseData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    if (this._filters != null) {
      data['filters'] = this._filters!.toJson();
    }
    if (this._summary != null) {
      data['summary'] = this._summary!.map((v) => v.toJson()).toList();
    }
    if (this._dateWiseData != null) {
      data['date_wise_data'] =
          this._dateWiseData!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Filters {
  String? _startDate;
  String? _endDate;
  String? _department;

  Filters({String? startDate, String? endDate, String? department}) {
    if (startDate != null) {
      this._startDate = startDate;
    }
    if (endDate != null) {
      this._endDate = endDate;
    }
    if (department != null) {
      this._department = department;
    }
  }

  String? get startDate => _startDate;
  set startDate(String? startDate) => _startDate = startDate;
  String? get endDate => _endDate;
  set endDate(String? endDate) => _endDate = endDate;
  String? get department => _department;
  set department(String? department) => _department = department;

  Filters.fromJson(Map<String, dynamic> json) {
    _startDate = json['start_date'];
    _endDate = json['end_date'];
    _department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['start_date'] = this._startDate;
    data['end_date'] = this._endDate;
    data['department'] = this._department;
    return data;
  }
}

class Summary {
  String? _testName;
  int? _count;
  String? _department;

  Summary({String? testName, int? count, String? department}) {
    if (testName != null) {
      this._testName = testName;
    }
    if (count != null) {
      this._count = count;
    }
    if (department != null) {
      this._department = department;
    }
  }

  String? get testName => _testName;
  set testName(String? testName) => _testName = testName;
  int? get count => _count;
  set count(int? count) => _count = count;
  String? get department => _department;
  set department(String? department) => _department = department;

  Summary.fromJson(Map<String, dynamic> json) {
    _testName = json['test_name'];
    _count = json['count'];
    _department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['test_name'] = this._testName;
    data['count'] = this._count;
    data['department'] = this._department;
    return data;
  }
}

class DateWiseData {
  String? _date;
  List<Tests>? _tests;

  DateWiseData({String? date, List<Tests>? tests}) {
    if (date != null) {
      this._date = date;
    }
    if (tests != null) {
      this._tests = tests;
    }
  }

  String? get date => _date;
  set date(String? date) => _date = date;
  List<Tests>? get tests => _tests;
  set tests(List<Tests>? tests) => _tests = tests;

  DateWiseData.fromJson(Map<String, dynamic> json) {
    _date = json['date'];
    if (json['tests'] != null) {
      _tests = <Tests>[];
      json['tests'].forEach((v) {
        _tests!.add(new Tests.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this._date;
    if (this._tests != null) {
      data['tests'] = this._tests!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Tests {
  String? _testName;
  int? _count;
  String? _department;

  Tests({String? testName, int? count, String? department}) {
    if (testName != null) {
      this._testName = testName;
    }
    if (count != null) {
      this._count = count;
    }
    if (department != null) {
      this._department = department;
    }
  }

  String? get testName => _testName;
  set testName(String? testName) => _testName = testName;
  int? get count => _count;
  set count(int? count) => _count = count;
  String? get department => _department;
  set department(String? department) => _department = department;

  Tests.fromJson(Map<String, dynamic> json) {
    _testName = json['test_name'];
    _count = json['count'];
    _department = json['department'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['test_name'] = this._testName;
    data['count'] = this._count;
    data['department'] = this._department;
    return data;
  }
}