class DueCollectionModel {
  bool? _status;
  String? _message;
  String? _inputDate;
  String? _createdDate;
  int? _totalDueCollection;
  int? _dueInCash;
  int? _dueInOnline;
  int? _patientCount;
  List<PatientList>? _patientList;

  DueCollectionModel(
      {bool? status,
        String? message,
        String? inputDate,
        String? createdDate,
        int? totalDueCollection,
        int? dueInCash,
        int? dueInOnline,
        int? patientCount,
        List<PatientList>? patientList}) {
    if (status != null) {
      this._status = status;
    }
    if (message != null) {
      this._message = message;
    }
    if (inputDate != null) {
      this._inputDate = inputDate;
    }
    if (createdDate != null) {
      this._createdDate = createdDate;
    }
    if (totalDueCollection != null) {
      this._totalDueCollection = totalDueCollection;
    }
    if (dueInCash != null) {
      this._dueInCash = dueInCash;
    }
    if (dueInOnline != null) {
      this._dueInOnline = dueInOnline;
    }
    if (patientCount != null) {
      this._patientCount = patientCount;
    }
    if (patientList != null) {
      this._patientList = patientList;
    }
  }

  bool? get status => _status;
  set status(bool? status) => _status = status;
  String? get message => _message;
  set message(String? message) => _message = message;
  String? get inputDate => _inputDate;
  set inputDate(String? inputDate) => _inputDate = inputDate;
  String? get createdDate => _createdDate;
  set createdDate(String? createdDate) => _createdDate = createdDate;
  int? get totalDueCollection => _totalDueCollection;
  set totalDueCollection(int? totalDueCollection) =>
      _totalDueCollection = totalDueCollection;
  int? get dueInCash => _dueInCash;
  set dueInCash(int? dueInCash) => _dueInCash = dueInCash;
  int? get dueInOnline => _dueInOnline;
  set dueInOnline(int? dueInOnline) => _dueInOnline = dueInOnline;
  int? get patientCount => _patientCount;
  set patientCount(int? patientCount) => _patientCount = patientCount;
  List<PatientList>? get patientList => _patientList;
  set patientList(List<PatientList>? patientList) => _patientList = patientList;

  DueCollectionModel.fromJson(Map<String, dynamic> json) {
    _status = json['status'];
    _message = json['message'];
    _inputDate = json['input_date'];
    _createdDate = json['created_date'];
    _totalDueCollection = json['total_due_collection'];
    _dueInCash = json['due_in_cash'];
    _dueInOnline = json['due_in_online'];
    _patientCount = json['patient_count'];
    if (json['patient_list'] != null) {
      _patientList = <PatientList>[];
      json['patient_list'].forEach((v) {
        _patientList!.add(new PatientList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this._status;
    data['message'] = this._message;
    data['input_date'] = this._inputDate;
    data['created_date'] = this._createdDate;
    data['total_due_collection'] = this._totalDueCollection;
    data['due_in_cash'] = this._dueInCash;
    data['due_in_online'] = this._dueInOnline;
    data['patient_count'] = this._patientCount;
    if (this._patientList != null) {
      data['patient_list'] = this._patientList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PatientList {
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

  PatientList(
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

  PatientList.fromJson(Map<String, dynamic> json) {
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
