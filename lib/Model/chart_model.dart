class ChartModel {
  String? _year;
  List<Monthly>? _monthly;

  ChartModel({String? year, List<Monthly>? monthly}) {
    if (year != null) {
      this._year = year;
    }
    if (monthly != null) {
      this._monthly = monthly;
    }
  }

  String? get year => _year;
  set year(String? year) => _year = year;
  List<Monthly>? get monthly => _monthly;
  set monthly(List<Monthly>? monthly) => _monthly = monthly;

  ChartModel.fromJson(Map<String, dynamic> json) {
    _year = json['year'];
    if (json['monthly'] != null) {
      _monthly = <Monthly>[];
      json['monthly'].forEach((v) {
        _monthly!.add(new Monthly.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this._year;
    if (this._monthly != null) {
      data['monthly'] = this._monthly!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Monthly {
  int? _month;
  int? _patients;
  int? _collection;

  Monthly({int? month, int? patients, int? collection}) {
    if (month != null) {
      this._month = month;
    }
    if (patients != null) {
      this._patients = patients;
    }
    if (collection != null) {
      this._collection = collection;
    }
  }

  int? get month => _month;
  set month(int? month) => _month = month;
  int? get patients => _patients;
  set patients(int? patients) => _patients = patients;
  int? get collection => _collection;
  set collection(int? collection) => _collection = collection;

  Monthly.fromJson(Map<String, dynamic> json) {
    _month = json['month'];
    _patients = json['patients'];
    _collection = json['collection'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this._month;
    data['patients'] = this._patients;
    data['collection'] = this._collection;
    return data;
  }
}
