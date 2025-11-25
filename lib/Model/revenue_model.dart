class RevenueModel {
  Today? _today;
  SelectedMonth? _selectedMonth;
  SelectedYear? _selectedYear;
  List<PaymentModes>? _paymentModes;
  int? _pendingTotalThisMonth;
  int? _pendingTotalThisYear;

  RevenueModel(
      {Today? today,
        SelectedMonth? selectedMonth,
        SelectedYear? selectedYear,
        List<PaymentModes>? paymentModes,
        int? pendingTotalThisMonth,
        int? pendingTotalThisYear}) {
    if (today != null) {
      this._today = today;
    }
    if (selectedMonth != null) {
      this._selectedMonth = selectedMonth;
    }
    if (selectedYear != null) {
      this._selectedYear = selectedYear;
    }
    if (paymentModes != null) {
      this._paymentModes = paymentModes;
    }
    if (pendingTotalThisMonth != null) {
      this._pendingTotalThisMonth = pendingTotalThisMonth;
    }
    if (pendingTotalThisYear != null) {
      this._pendingTotalThisYear = pendingTotalThisYear;
    }
  }

  Today? get today => _today;
  set today(Today? today) => _today = today;
  SelectedMonth? get selectedMonth => _selectedMonth;
  set selectedMonth(SelectedMonth? selectedMonth) =>
      _selectedMonth = selectedMonth;
  SelectedYear? get selectedYear => _selectedYear;
  set selectedYear(SelectedYear? selectedYear) => _selectedYear = selectedYear;
  List<PaymentModes>? get paymentModes => _paymentModes;
  set paymentModes(List<PaymentModes>? paymentModes) =>
      _paymentModes = paymentModes;
  int? get pendingTotalThisMonth => _pendingTotalThisMonth;
  set pendingTotalThisMonth(int? pendingTotalThisMonth) =>
      _pendingTotalThisMonth = pendingTotalThisMonth;
  int? get pendingTotalThisYear => _pendingTotalThisYear;
  set pendingTotalThisYear(int? pendingTotalThisYear) =>
      _pendingTotalThisYear = pendingTotalThisYear;

  RevenueModel.fromJson(Map<String, dynamic> json) {
    _today = json['today'] != null ? new Today.fromJson(json['today']) : null;
    _selectedMonth = json['selected_month'] != null
        ? new SelectedMonth.fromJson(json['selected_month'])
        : null;
    _selectedYear = json['selected_year'] != null
        ? new SelectedYear.fromJson(json['selected_year'])
        : null;
    if (json['payment_modes'] != null) {
      _paymentModes = <PaymentModes>[];
      json['payment_modes'].forEach((v) {
        _paymentModes!.add(new PaymentModes.fromJson(v));
      });
    }
    _pendingTotalThisMonth = json['pending_total_this_month'];
    _pendingTotalThisYear = json['pending_total_this_year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this._today != null) {
      data['today'] = this._today!.toJson();
    }
    if (this._selectedMonth != null) {
      data['selected_month'] = this._selectedMonth!.toJson();
    }
    if (this._selectedYear != null) {
      data['selected_year'] = this._selectedYear!.toJson();
    }
    if (this._paymentModes != null) {
      data['payment_modes'] =
          this._paymentModes!.map((v) => v.toJson()).toList();
    }
    data['pending_total_this_month'] = this._pendingTotalThisMonth;
    data['pending_total_this_year'] = this._pendingTotalThisYear;
    return data;
  }
}

class Today {
  int? _patients;
  int? _totalAmount;
  int? _totalCollection;
  int? _totalDue;
  List<Details>? _details;

  Today(
      {int? patients,
        int? totalAmount,
        int? totalCollection,
        int? totalDue,
        List<Details>? details}) {
    if (patients != null) {
      this._patients = patients;
    }
    if (totalAmount != null) {
      this._totalAmount = totalAmount;
    }
    if (totalCollection != null) {
      this._totalCollection = totalCollection;
    }
    if (totalDue != null) {
      this._totalDue = totalDue;
    }
    if (details != null) {
      this._details = details;
    }
  }

  int? get patients => _patients;
  set patients(int? patients) => _patients = patients;
  int? get totalAmount => _totalAmount;
  set totalAmount(int? totalAmount) => _totalAmount = totalAmount;
  int? get totalCollection => _totalCollection;
  set totalCollection(int? totalCollection) =>
      _totalCollection = totalCollection;
  int? get totalDue => _totalDue;
  set totalDue(int? totalDue) => _totalDue = totalDue;
  List<Details>? get details => _details;
  set details(List<Details>? details) => _details = details;

  Today.fromJson(Map<String, dynamic> json) {
    _patients = json['patients'];
    _totalAmount = json['total_amount'];
    _totalCollection = json['total_collection'];
    _totalDue = json['total_due'];
    if (json['details'] != null) {
      _details = <Details>[];
      json['details'].forEach((v) {
        _details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['patients'] = this._patients;
    data['total_amount'] = this._totalAmount;
    data['total_collection'] = this._totalCollection;
    data['total_due'] = this._totalDue;
    if (this._details != null) {
      data['details'] = this._details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? _caseNo;
  String? _patientName;
  String? _mobile;
  String? _totalAmount;
  String? _discount;
  String? _afterDiscount;
  String? _advance;
  String? _balance;
  String? _paidAmount;
  String? _payStatus;
  String? _payMode;
  String? _discountType;

  Details(
      {String? caseNo,
        String? patientName,
        String? mobile,
        String? totalAmount,
        String? discount,
        String? afterDiscount,
        String? advance,
        String? balance,
        String? paidAmount,
        String? payStatus,
        String? payMode,
        String? discountType}) {
    if (patientName != null) {
      this._patientName = patientName;
    }if (caseNo != null) {
      this._caseNo = caseNo;
    }
    if (mobile != null) {
      this._mobile = mobile;
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
  }

  String? get caseNo => _caseNo;
  set caseNo(String? caseNo) => _caseNo = caseNo;

  String? get patientName => _patientName;
  set patientName(String? patientName) => _patientName = patientName;

  String? get mobile => _mobile;
  set mobile(String? mobile) => _mobile = mobile;

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

  Details.fromJson(Map<String, dynamic> json) {
    _patientName = json['patient_name'];
    _caseNo = json['case_no'];
    _mobile = json['mobile'];
    _totalAmount = json['total_amount'];
    _discount = json['discount'];
    _afterDiscount = json['after_discount'];
    _advance = json['advance'];
    _balance = json['balance'];
    _paidAmount = json['paid_amount'];
    _payStatus = json['pay_status'];
    _payMode = json['pay_mode'];
    _discountType = json['discount_type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['case_no'] = this._caseNo;
    data['patient_name'] = this._patientName;
    data['mobile'] = this._mobile;
    data['total_amount'] = this._totalAmount;
    data['discount'] = this._discount;
    data['after_discount'] = this._afterDiscount;
    data['advance'] = this._advance;
    data['balance'] = this._balance;
    data['paid_amount'] = this._paidAmount;
    data['pay_status'] = this._payStatus;
    data['pay_mode'] = this._payMode;
    data['discount_type'] = this._discountType;
    return data;
  }
}

class SelectedMonth {
  String? _month;
  String? _year;
  int? _patients;
  int? _revenue;

  SelectedMonth({String? month, String? year, int? patients, int? revenue}) {
    if (month != null) {
      this._month = month;
    }
    if (year != null) {
      this._year = year;
    }
    if (patients != null) {
      this._patients = patients;
    }
    if (revenue != null) {
      this._revenue = revenue;
    }
  }

  String? get month => _month;
  set month(String? month) => _month = month;
  String? get year => _year;
  set year(String? year) => _year = year;
  int? get patients => _patients;
  set patients(int? patients) => _patients = patients;
  int? get revenue => _revenue;
  set revenue(int? revenue) => _revenue = revenue;

  SelectedMonth.fromJson(Map<String, dynamic> json) {
    _month = json['month'];
    _year = json['year'];
    _patients = json['patients'];
    _revenue = json['revenue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['month'] = this._month;
    data['year'] = this._year;
    data['patients'] = this._patients;
    data['revenue'] = this._revenue;
    return data;
  }
}

class SelectedYear {
  String? _year;
  int? _patients;
  int? _revenue;

  SelectedYear({String? year, int? patients, int? revenue}) {
    if (year != null) {
      this._year = year;
    }
    if (patients != null) {
      this._patients = patients;
    }
    if (revenue != null) {
      this._revenue = revenue;
    }
  }

  String? get year => _year;
  set year(String? year) => _year = year;
  int? get patients => _patients;
  set patients(int? patients) => _patients = patients;
  int? get revenue => _revenue;
  set revenue(int? revenue) => _revenue = revenue;

  SelectedYear.fromJson(Map<String, dynamic> json) {
    _year = json['year'];
    _patients = json['patients'];
    _revenue = json['revenue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['year'] = this._year;
    data['patients'] = this._patients;
    data['revenue'] = this._revenue;
    return data;
  }
}

class PaymentModes {
  String? _payMode;
  int? _total;

  PaymentModes({String? payMode, int? total}) {
    if (payMode != null) {
      this._payMode = payMode;
    }
    if (total != null) {
      this._total = total;
    }
  }

  String? get payMode => _payMode;
  set payMode(String? payMode) => _payMode = payMode;
  int? get total => _total;
  set total(int? total) => _total = total;

  PaymentModes.fromJson(Map<String, dynamic> json) {
    _payMode = json['pay_mode'];
    _total = json['total'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pay_mode'] = this._payMode;
    data['total'] = this._total;
    return data;
  }
}
