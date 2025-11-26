class ExpansesModel {
  String? _error;
  String? _message;
  List<Expanses>? _expanses;

  ExpansesModel({String? error, String? message, List<Expanses>? expanses}) {
    if (error != null) {
      this._error = error;
    }
    if (message != null) {
      this._message = message;
    }
    if (expanses != null) {
      this._expanses = expanses;
    }
  }

  String? get error => _error;
  set error(String? error) => _error = error;
  String? get message => _message;
  set message(String? message) => _message = message;
  List<Expanses>? get expanses => _expanses;
  set expanses(List<Expanses>? expanses) => _expanses = expanses;

  ExpansesModel.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
    _message = json['message'];
    if (json['Expanses'] != null) {
      _expanses = <Expanses>[];
      json['Expanses'].forEach((v) {
        _expanses!.add(new Expanses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    data['message'] = this._message;
    if (this._expanses != null) {
      data['Expanses'] = this._expanses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Expanses {
  int? _id;
  String? _personName;
  String? _amount;
  String? _debitCredit;
  String? _date;
  String? _paidBy;
  String? _narration;
  String? _payType;
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  Expanses(
      {int? id,
        String? personName,
        String? amount,
        String? debitCredit,
        String? date,
        String? paidBy,
        String? narration,
        String? payType,
        String? status,
        String? createdAt,
        String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (personName != null) {
      this._personName = personName;
    }
    if (amount != null) {
      this._amount = amount;
    }
    if (debitCredit != null) {
      this._debitCredit = debitCredit;
    }
    if (date != null) {
      this._date = date;
    }
    if (paidBy != null) {
      this._paidBy = paidBy;
    }
    if (narration != null) {
      this._narration = narration;
    }
    if (payType != null) {
      this._payType = payType;
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
  String? get personName => _personName;
  set personName(String? personName) => _personName = personName;
  String? get amount => _amount;
  set amount(String? amount) => _amount = amount;
  String? get debitCredit => _debitCredit;
  set debitCredit(String? debitCredit) => _debitCredit = debitCredit;
  String? get date => _date;
  set date(String? date) => _date = date;
  String? get paidBy => _paidBy;
  set paidBy(String? paidBy) => _paidBy = paidBy;
  String? get narration => _narration;
  set narration(String? narration) => _narration = narration;
  String? get payType => _payType;
  set payType(String? payType) => _payType = payType;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  Expanses.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _personName = json['person_name'];
    _amount = json['amount'];
    _debitCredit = json['debit_credit'];
    _date = json['date'];
    _paidBy = json['paid_by'];
    _narration = json['narration'];
    _payType = json['pay_type'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['person_name'] = this._personName;
    data['amount'] = this._amount;
    data['debit_credit'] = this._debitCredit;
    data['date'] = this._date;
    data['paid_by'] = this._paidBy;
    data['narration'] = this._narration;
    data['pay_type'] = this._payType;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
