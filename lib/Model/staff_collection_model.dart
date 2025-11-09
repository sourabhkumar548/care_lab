class StaffCollectionModel {
  String? _date;
  int? _totalCollection;
  List<Staff>? _staff;

  StaffCollectionModel(
      {String? date, int? totalCollection, List<Staff>? staff}) {
    if (date != null) {
      this._date = date;
    }
    if (totalCollection != null) {
      this._totalCollection = totalCollection;
    }
    if (staff != null) {
      this._staff = staff;
    }
  }

  String? get date => _date;
  set date(String? date) => _date = date;
  int? get totalCollection => _totalCollection;
  set totalCollection(int? totalCollection) =>
      _totalCollection = totalCollection;
  List<Staff>? get staff => _staff;
  set staff(List<Staff>? staff) => _staff = staff;

  StaffCollectionModel.fromJson(Map<String, dynamic> json) {
    _date = json['date'];
    _totalCollection = json['total_collection'];
    if (json['staff'] != null) {
      _staff = <Staff>[];
      json['staff'].forEach((v) {
        _staff!.add(new Staff.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this._date;
    data['total_collection'] = this._totalCollection;
    if (this._staff != null) {
      data['staff'] = this._staff!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Staff {
  String? _staff;
  int? _patientCount;
  int? _totalCollection;

  Staff({String? staff, int? patientCount, int? totalCollection}) {
    if (staff != null) {
      this._staff = staff;
    }
    if (patientCount != null) {
      this._patientCount = patientCount;
    }
    if (totalCollection != null) {
      this._totalCollection = totalCollection;
    }
  }

  String? get staff => _staff;
  set staff(String? staff) => _staff = staff;
  int? get patientCount => _patientCount;
  set patientCount(int? patientCount) => _patientCount = patientCount;
  int? get totalCollection => _totalCollection;
  set totalCollection(int? totalCollection) =>
      _totalCollection = totalCollection;

  Staff.fromJson(Map<String, dynamic> json) {
    _staff = json['staff'];
    _patientCount = json['patient_count'];
    _totalCollection = json['total_collection'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['staff'] = this._staff;
    data['patient_count'] = this._patientCount;
    data['total_collection'] = this._totalCollection;
    return data;
  }
}
