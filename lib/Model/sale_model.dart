class SaleModel {
  bool? _success;
  String? _message;
  List<Data>? _data;
  Pagination? _pagination;
  Totals? _totals;

  SaleModel(
      {bool? success,
        String? message,
        List<Data>? data,
        Pagination? pagination,
        Totals? totals}) {
    if (success != null) {
      this._success = success;
    }
    if (message != null) {
      this._message = message;
    }
    if (data != null) {
      this._data = data;
    }
    if (pagination != null) {
      this._pagination = pagination;
    }
    if (totals != null) {
      this._totals = totals;
    }
  }

  bool? get success => _success;
  set success(bool? success) => _success = success;
  String? get message => _message;
  set message(String? message) => _message = message;
  List<Data>? get data => _data;
  set data(List<Data>? data) => _data = data;
  Pagination? get pagination => _pagination;
  set pagination(Pagination? pagination) => _pagination = pagination;
  Totals? get totals => _totals;
  set totals(Totals? totals) => _totals = totals;

  SaleModel.fromJson(Map<String, dynamic> json) {
    _success = json['success'];
    _message = json['message'];
    if (json['data'] != null) {
      _data = <Data>[];
      json['data'].forEach((v) {
        _data!.add(new Data.fromJson(v));
      });
    }
    _pagination = json['pagination'] != null
        ? new Pagination.fromJson(json['pagination'])
        : null;
    _totals =
    json['totals'] != null ? new Totals.fromJson(json['totals']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this._success;
    data['message'] = this._message;
    if (this._data != null) {
      data['data'] = this._data!.map((v) => v.toJson()).toList();
    }
    if (this._pagination != null) {
      data['pagination'] = this._pagination!.toJson();
    }
    if (this._totals != null) {
      data['totals'] = this._totals!.toJson();
    }
    return data;
  }
}

class Data {
  int? _id;
  String? _caseDate;
  String? _time;
  String? _date;
  String? _caseNo;
  String? _slipNo;
  String? _receivedBy;
  String? _patientName;
  String? _year;
  String? _month;
  String? _gender;
  String? _mobile;
  String? _childMale;
  String? _childFemale;
  String? _address;
  String? _agent;
  String? _doctor;
  String? _testName;
  String? _testRate;
  String? _totalAmount;
  String? _discount;
  String? _afterDiscount;
  String? _advance;
  String? _balance;
  String? _paidAmount;
  String? _payStatus;
  String? _payMode;
  String? _discountType;
  String? _testDate;
  String? _testFile;
  String? _narration;
  String? _nameTitle;
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  Data(
      {int? id,
        String? caseDate,
        String? time,
        String? date,
        String? caseNo,
        String? slipNo,
        String? receivedBy,
        String? patientName,
        String? year,
        String? month,
        String? gender,
        String? mobile,
        String? childMale,
        String? childFemale,
        String? address,
        String? agent,
        String? doctor,
        String? testName,
        String? testRate,
        String? totalAmount,
        String? discount,
        String? afterDiscount,
        String? advance,
        String? balance,
        String? paidAmount,
        String? payStatus,
        String? payMode,
        String? discountType,
        String? testDate,
        String? testFile,
        String? narration,
        String? nameTitle,
        String? status,
        String? createdAt,
        String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (caseDate != null) {
      this._caseDate = caseDate;
    }
    if (time != null) {
      this._time = time;
    }
    if (date != null) {
      this._date = date;
    }
    if (caseNo != null) {
      this._caseNo = caseNo;
    }
    if (slipNo != null) {
      this._slipNo = slipNo;
    }
    if (receivedBy != null) {
      this._receivedBy = receivedBy;
    }
    if (patientName != null) {
      this._patientName = patientName;
    }
    if (year != null) {
      this._year = year;
    }
    if (month != null) {
      this._month = month;
    }
    if (gender != null) {
      this._gender = gender;
    }
    if (mobile != null) {
      this._mobile = mobile;
    }
    if (childMale != null) {
      this._childMale = childMale;
    }
    if (childFemale != null) {
      this._childFemale = childFemale;
    }
    if (address != null) {
      this._address = address;
    }
    if (agent != null) {
      this._agent = agent;
    }
    if (doctor != null) {
      this._doctor = doctor;
    }
    if (testName != null) {
      this._testName = testName;
    }
    if (testRate != null) {
      this._testRate = testRate;
    }
    if (totalAmount != null) {
      this._totalAmount = totalAmount;
    }
    if (discount != null) {
      this._discount = discount;
    }
    if (afterDiscount != null) {
      this._afterDiscount = afterDiscount;
    }
    if (advance != null) {
      this._advance = advance;
    }
    if (balance != null) {
      this._balance = balance;
    }
    if (paidAmount != null) {
      this._paidAmount = paidAmount;
    }
    if (payStatus != null) {
      this._payStatus = payStatus;
    }
    if (payMode != null) {
      this._payMode = payMode;
    }
    if (discountType != null) {
      this._discountType = discountType;
    }
    if (testDate != null) {
      this._testDate = testDate;
    }
    if (testFile != null) {
      this._testFile = testFile;
    }
    if (narration != null) {
      this._narration = narration;
    }
    if (nameTitle != null) {
      this._nameTitle = nameTitle;
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
  String? get caseDate => _caseDate;
  set caseDate(String? caseDate) => _caseDate = caseDate;
  String? get time => _time;
  set time(String? time) => _time = time;
  String? get date => _date;
  set date(String? date) => _date = date;
  String? get caseNo => _caseNo;
  set caseNo(String? caseNo) => _caseNo = caseNo;
  String? get slipNo => _slipNo;
  set slipNo(String? slipNo) => _slipNo = slipNo;
  String? get receivedBy => _receivedBy;
  set receivedBy(String? receivedBy) => _receivedBy = receivedBy;
  String? get patientName => _patientName;
  set patientName(String? patientName) => _patientName = patientName;
  String? get year => _year;
  set year(String? year) => _year = year;
  String? get month => _month;
  set month(String? month) => _month = month;
  String? get gender => _gender;
  set gender(String? gender) => _gender = gender;
  String? get mobile => _mobile;
  set mobile(String? mobile) => _mobile = mobile;
  String? get childMale => _childMale;
  set childMale(String? childMale) => _childMale = childMale;
  String? get childFemale => _childFemale;
  set childFemale(String? childFemale) => _childFemale = childFemale;
  String? get address => _address;
  set address(String? address) => _address = address;
  String? get agent => _agent;
  set agent(String? agent) => _agent = agent;
  String? get doctor => _doctor;
  set doctor(String? doctor) => _doctor = doctor;
  String? get testName => _testName;
  set testName(String? testName) => _testName = testName;
  String? get testRate => _testRate;
  set testRate(String? testRate) => _testRate = testRate;
  String? get totalAmount => _totalAmount;
  set totalAmount(String? totalAmount) => _totalAmount = totalAmount;
  String? get discount => _discount;
  set discount(String? discount) => _discount = discount;
  String? get afterDiscount => _afterDiscount;
  set afterDiscount(String? afterDiscount) => _afterDiscount = afterDiscount;
  String? get advance => _advance;
  set advance(String? advance) => _advance = advance;
  String? get balance => _balance;
  set balance(String? balance) => _balance = balance;
  String? get paidAmount => _paidAmount;
  set paidAmount(String? paidAmount) => _paidAmount = paidAmount;
  String? get payStatus => _payStatus;
  set payStatus(String? payStatus) => _payStatus = payStatus;
  String? get payMode => _payMode;
  set payMode(String? payMode) => _payMode = payMode;
  String? get discountType => _discountType;
  set discountType(String? discountType) => _discountType = discountType;
  String? get testDate => _testDate;
  set testDate(String? testDate) => _testDate = testDate;
  String? get testFile => _testFile;
  set testFile(String? testFile) => _testFile = testFile;
  String? get narration => _narration;
  set narration(String? narration) => _narration = narration;
  String? get nameTitle => _nameTitle;
  set nameTitle(String? nameTitle) => _nameTitle = nameTitle;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  Data.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _caseDate = json['case_date'];
    _time = json['time'];
    _date = json['date'];
    _caseNo = json['case_no'];
    _slipNo = json['slip_no'];
    _receivedBy = json['received_by'];
    _patientName = json['patient_name'];
    _year = json['year'];
    _month = json['month'];
    _gender = json['gender'];
    _mobile = json['mobile'];
    _childMale = json['child_male'];
    _childFemale = json['child_female'];
    _address = json['address'];
    _agent = json['agent'];
    _doctor = json['doctor'];
    _testName = json['test_name'];
    _testRate = json['test_rate'];
    _totalAmount = json['total_amount'];
    _discount = json['discount'];
    _afterDiscount = json['after_discount'];
    _advance = json['advance'];
    _balance = json['balance'];
    _paidAmount = json['paid_amount'];
    _payStatus = json['pay_status'];
    _payMode = json['pay_mode'];
    _discountType = json['discount_type'];
    _testDate = json['test_date'];
    _testFile = json['test_file'];
    _narration = json['narration'];
    _nameTitle = json['name_title'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['case_date'] = this._caseDate;
    data['time'] = this._time;
    data['date'] = this._date;
    data['case_no'] = this._caseNo;
    data['slip_no'] = this._slipNo;
    data['received_by'] = this._receivedBy;
    data['patient_name'] = this._patientName;
    data['year'] = this._year;
    data['month'] = this._month;
    data['gender'] = this._gender;
    data['mobile'] = this._mobile;
    data['child_male'] = this._childMale;
    data['child_female'] = this._childFemale;
    data['address'] = this._address;
    data['agent'] = this._agent;
    data['doctor'] = this._doctor;
    data['test_name'] = this._testName;
    data['test_rate'] = this._testRate;
    data['total_amount'] = this._totalAmount;
    data['discount'] = this._discount;
    data['after_discount'] = this._afterDiscount;
    data['advance'] = this._advance;
    data['balance'] = this._balance;
    data['paid_amount'] = this._paidAmount;
    data['pay_status'] = this._payStatus;
    data['pay_mode'] = this._payMode;
    data['discount_type'] = this._discountType;
    data['test_date'] = this._testDate;
    data['test_file'] = this._testFile;
    data['narration'] = this._narration;
    data['name_title'] = this._nameTitle;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}

class Pagination {
  int? _total;
  String? _perPage;
  int? _currentPage;
  int? _lastPage;
  int? _from;
  int? _to;

  Pagination(
      {int? total,
        String? perPage,
        int? currentPage,
        int? lastPage,
        int? from,
        int? to}) {
    if (total != null) {
      this._total = total;
    }
    if (perPage != null) {
      this._perPage = perPage;
    }
    if (currentPage != null) {
      this._currentPage = currentPage;
    }
    if (lastPage != null) {
      this._lastPage = lastPage;
    }
    if (from != null) {
      this._from = from;
    }
    if (to != null) {
      this._to = to;
    }
  }

  int? get total => _total;
  set total(int? total) => _total = total;
  String? get perPage => _perPage;
  set perPage(String? perPage) => _perPage = perPage;
  int? get currentPage => _currentPage;
  set currentPage(int? currentPage) => _currentPage = currentPage;
  int? get lastPage => _lastPage;
  set lastPage(int? lastPage) => _lastPage = lastPage;
  int? get from => _from;
  set from(int? from) => _from = from;
  int? get to => _to;
  set to(int? to) => _to = to;

  Pagination.fromJson(Map<String, dynamic> json) {
    _total = json['total'];
    _perPage = json['per_page'];
    _currentPage = json['current_page'];
    _lastPage = json['last_page'];
    _from = json['from'];
    _to = json['to'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total'] = this._total;
    data['per_page'] = this._perPage;
    data['current_page'] = this._currentPage;
    data['last_page'] = this._lastPage;
    data['from'] = this._from;
    data['to'] = this._to;
    return data;
  }
}

class Totals {
  String? _totalAmount;
  String? _totalDiscount;
  String? _totalAfterDiscount;
  String? _totalPaid;
  String? _totalDue;

  Totals(
      {String? totalAmount,
        String? totalDiscount,
        String? totalAfterDiscount,
        String? totalPaid,
        String? totalDue}) {
    if (totalAmount != null) {
      this._totalAmount = totalAmount;
    }
    if (totalDiscount != null) {
      this._totalDiscount = totalDiscount;
    }
    if (totalAfterDiscount != null) {
      this._totalAfterDiscount = totalAfterDiscount;
    }
    if (totalPaid != null) {
      this._totalPaid = totalPaid;
    }
    if (totalDue != null) {
      this._totalDue = totalDue;
    }
  }

  String? get totalAmount => _totalAmount;
  set totalAmount(String? totalAmount) => _totalAmount = totalAmount;
  String? get totalDiscount => _totalDiscount;
  set totalDiscount(String? totalDiscount) => _totalDiscount = totalDiscount;
  String? get totalAfterDiscount => _totalAfterDiscount;
  set totalAfterDiscount(String? totalAfterDiscount) =>
      _totalAfterDiscount = totalAfterDiscount;
  String? get totalPaid => _totalPaid;
  set totalPaid(String? totalPaid) => _totalPaid = totalPaid;
  String? get totalDue => _totalDue;
  set totalDue(String? totalDue) => _totalDue = totalDue;

  Totals.fromJson(Map<String, dynamic> json) {
    _totalAmount = json['total_amount'];
    _totalDiscount = json['total_discount'];
    _totalAfterDiscount = json['total_after_discount'];
    _totalPaid = json['total_paid'];
    _totalDue = json['total_due'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['total_amount'] = this._totalAmount;
    data['total_discount'] = this._totalDiscount;
    data['total_after_discount'] = this._totalAfterDiscount;
    data['total_paid'] = this._totalPaid;
    data['total_due'] = this._totalDue;
    return data;
  }
}
