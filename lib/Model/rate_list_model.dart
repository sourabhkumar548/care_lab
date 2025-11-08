class RateListModel {
  String? _error;
  String? _status;
  List<RateList>? _rateList;
  Meta? _meta;

  RateListModel(
      {String? error, String? status, List<RateList>? rateList, Meta? meta}) {
    if (error != null) {
      this._error = error;
    }
    if (status != null) {
      this._status = status;
    }
    if (rateList != null) {
      this._rateList = rateList;
    }
    if (meta != null) {
      this._meta = meta;
    }
  }

  String? get error => _error;
  set error(String? error) => _error = error;
  String? get status => _status;
  set status(String? status) => _status = status;
  List<RateList>? get rateList => _rateList;
  set rateList(List<RateList>? rateList) => _rateList = rateList;
  Meta? get meta => _meta;
  set meta(Meta? meta) => _meta = meta;

  RateListModel.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
    _status = json['status'];
    if (json['RateList'] != null) {
      _rateList = <RateList>[];
      json['RateList'].forEach((v) {
        _rateList!.add(new RateList.fromJson(v));
      });
    }
    _meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    data['status'] = this._status;
    if (this._rateList != null) {
      data['RateList'] = this._rateList!.map((v) => v.toJson()).toList();
    }
    if (this._meta != null) {
      data['meta'] = this._meta!.toJson();
    }
    return data;
  }
}

class RateList {
  int? _id;
  String? _testName;
  String? _rate;
  String? _deliveryAfter;
  String? _department;
  String? _testFile;
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  RateList(
      {int? id,
        String? testName,
        String? rate,
        String? deliveryAfter,
        String? department,
        String? testFile,
        String? status,
        String? createdAt,
        String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (testName != null) {
      this._testName = testName;
    }
    if (rate != null) {
      this._rate = rate;
    }
    if (deliveryAfter != null) {
      this._deliveryAfter = deliveryAfter;
    }
    if (department != null) {
      this._department = department;
    }
    if (testFile != null) {
      this._testFile = testFile;
    }
    if (status != null) {
      this._status = status;
    }
    if (createdAt != null) {
      this._createdAt = createdAt;
    }
    if (updatedAt != null) {
      this._updatedAt = updatedAt;
    }
  }

  int? get id => _id;
  set id(int? id) => _id = id;
  String? get testName => _testName;
  set testName(String? testName) => _testName = testName;
  String? get rate => _rate;
  set rate(String? rate) => _rate = rate;
  String? get deliveryAfter => _deliveryAfter;
  set deliveryAfter(String? deliveryAfter) => _deliveryAfter = deliveryAfter;
  String? get department => _department;
  set department(String? department) => _department = department;
  String? get testFile => _testFile;
  set testFile(String? testFile) => _testFile = testFile;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  RateList.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _testName = json['test_name'];
    _rate = json['rate'];
    _deliveryAfter = json['delivery_after'];
    _department = json['department'];
    _testFile = json['test_file'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['test_name'] = this._testName;
    data['rate'] = this._rate;
    data['delivery_after'] = this._deliveryAfter;
    data['department'] = this._department;
    data['test_file'] = this._testFile;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}

class Meta {
  int? _currentPage;
  int? _lastPage;
  int? _perPage;
  int? _total;

  Meta({int? currentPage, int? lastPage, int? perPage, int? total}) {
    if (currentPage != null) {
      this._currentPage = currentPage;
    }
    if (lastPage != null) {
      this._lastPage = lastPage;
    }
    if (perPage != null) {
      this._perPage = perPage;
    }
    if (total != null) {
      this._total = total;
    }
  }

  int? get currentPage => _currentPage;
  set currentPage(int? currentPage) => _currentPage = currentPage;
  int? get lastPage => _lastPage;
  set lastPage(int? lastPage) => _lastPage = lastPage;
  int? get perPage => _perPage;
  set perPage(int? perPage) => _perPage = perPage;
  int? get total => _total;
  set total(int? total) => _total = total;

  Meta.fromJson(Map<String, dynamic> json) {
    _currentPage = json['current_page'];
    _lastPage = json['last_page'];
    _perPage = json['per_page'];
    _total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['current_page'] = this._currentPage;
    data['last_page'] = this._lastPage;
    data['per_page'] = this._perPage;
    data['total'] = this._total;
    return data;
  }
}
