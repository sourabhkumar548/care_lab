class DoctorModel {
  String? _error;
  String? _status;
  List<Doctor>? _doctor;
  Meta? _meta;

  DoctorModel(
      {String? error, String? status, List<Doctor>? doctor, Meta? meta}) {
    if (error != null) {
      this._error = error;
    }
    if (status != null) {
      this._status = status;
    }
    if (doctor != null) {
      this._doctor = doctor;
    }
    if (meta != null) {
      this._meta = meta;
    }
  }

  String? get error => _error;
  set error(String? error) => _error = error;
  String? get status => _status;
  set status(String? status) => _status = status;
  List<Doctor>? get doctor => _doctor;
  set doctor(List<Doctor>? doctor) => _doctor = doctor;
  Meta? get meta => _meta;
  set meta(Meta? meta) => _meta = meta;

  DoctorModel.fromJson(Map<String, dynamic> json) {
    _error = json['error'];
    _status = json['status'];
    if (json['Doctor'] != null) {
      _doctor = <Doctor>[];
      json['Doctor'].forEach((v) {
        _doctor!.add(new Doctor.fromJson(v));
      });
    }
    _meta = json['meta'] != null ? new Meta.fromJson(json['meta']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['error'] = this._error;
    data['status'] = this._status;
    if (this._doctor != null) {
      data['Doctor'] = this._doctor!.map((v) => v.toJson()).toList();
    }
    if (this._meta != null) {
      data['meta'] = this._meta!.toJson();
    }
    return data;
  }
}

class Doctor {
  int? _id;
  String? _doctorName;
  String? _post;
  Null? _mobile;
  String? _status;
  String? _createdAt;
  String? _updatedAt;

  Doctor(
      {int? id,
        String? doctorName,
        String? post,
        Null? mobile,
        String? status,
        String? createdAt,
        String? updatedAt}) {
    if (id != null) {
      this._id = id;
    }
    if (doctorName != null) {
      this._doctorName = doctorName;
    }
    if (post != null) {
      this._post = post;
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
  String? get doctorName => _doctorName;
  set doctorName(String? doctorName) => _doctorName = doctorName;
  String? get post => _post;
  set post(String? post) => _post = post;
  Null? get mobile => _mobile;
  set mobile(Null? mobile) => _mobile = mobile;
  String? get status => _status;
  set status(String? status) => _status = status;
  String? get createdAt => _createdAt;
  set createdAt(String? createdAt) => _createdAt = createdAt;
  String? get updatedAt => _updatedAt;
  set updatedAt(String? updatedAt) => _updatedAt = updatedAt;

  Doctor.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _doctorName = json['doctor_name'];
    _post = json['post'];
    _mobile = json['mobile'];
    _status = json['status'];
    _createdAt = json['created_at'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['doctor_name'] = this._doctorName;
    data['post'] = this._post;
    data['mobile'] = this._mobile;
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
