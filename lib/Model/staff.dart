class StaffModel {
  String? _error;
  String? _message;
  List<Staff>? _staff;

  StaffModel({String? error, String? message, List<Staff>? staff}) {
    if (error != null) {
      this._error = error;
    }
    if (message != null) {
      this._message = message;
    }
    if (staff != null) {
      this._staff = staff;
    }
  }

  String? get error => _error;
  set error(String? error) => _error = error;
  String? get message => _message;
  set message(String? message) => _message = message;
  List<Staff>? get staff => _staff;
  set staff(List<Staff>? staff) => _staff = staff;

  StaffModel.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
    _message = json['message'];
    if (json['Staff'] != null) {
      _staff = <Staff>[];
      json['Staff'].forEach((v) {
        _staff!.add(new Staff.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    data['message'] = this._message;
    if (this._staff != null) {
      data['Staff'] = this._staff!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Staff {
  int? _id;
  String? _staffName;
  String? _username;
  String? _password;
  String? _staffType;
  String? _mobile;
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  Staff(
      {int? id,
        String? staffName,
        String? username,
        String? password,
        String? staffType,
        String? mobile,
        String? status,
        String? createdAt,
        String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (staffName != null) {
      this._staffName = staffName;
    }
    if (username != null) {
      this._username = username;
    }
    if (password != null) {
      this._password = password;
    }
    if (staffType != null) {
      this._staffType = staffType;
    }
    if (mobile != null) {
      this._mobile = mobile;
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
  String? get staffName => _staffName;
  set staffName(String? staffName) => _staffName = staffName;
  String? get username => _username;
  set username(String? username) => _username = username;
  String? get password => _password;
  set password(String? password) => _password = password;
  String? get staffType => _staffType;
  set staffType(String? staffType) => _staffType = staffType;
  String? get mobile => _mobile;
  set mobile(String? mobile) => _mobile = mobile;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  Staff.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _staffName = json['staff_name'];
    _username = json['username'];
    _password = json['password'];
    _staffType = json['staff_type'];
    _mobile = json['mobile'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['staff_name'] = this._staffName;
    data['username'] = this._username;
    data['password'] = this._password;
    data['staff_type'] = this._staffType;
    data['mobile'] = this._mobile;
    data['status'] = this._status;
    data['created_at'] = this._createdAt;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
