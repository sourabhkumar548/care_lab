class SqfCaseEntryModel {
  String case_date;
  String time;
  String date;
  String case_no;
  String slip_no;
  String received_by;
  String patient_name;
  String year;
  String month;
  String gender;
  String mobile;
  String child_male;
  String child_female;
  String address;
  String agent;
  String doctor;
  String test_name;
  String test_rate;
  String total_amount;
  String discount;
  String after_discount;
  String advance;
  String balance;
  String paid_amount;
  String pay_status;
  String pay_mode;
  String discount_type;
  String test_date;
  String test_file;
  String narration;
  String name_title;
  String mon;
  String yer;

  SqfCaseEntryModel({
    required this.case_date,
    required this.time,
    required this.date,
    required this.case_no,
    required this.slip_no,
    required this.received_by,
    required this.patient_name,
    required this.year,
    required this.month,
    required this.gender,
    required this.mobile,
    required this.child_male,
    required this.child_female,
    required this.address,
    required this.agent,
    required this.doctor,
    required this.test_name,
    required this.test_rate,
    required this.total_amount,
    required this.discount,
    required this.after_discount,
    required this.advance,
    required this.balance,
    required this.paid_amount,
    required this.pay_status,
    required this.pay_mode,
    required this.discount_type,
    required this.test_date,
    required this.test_file,
    required this.narration,
    required this.name_title,
    required this.mon,
    required this.yer,
  });

  factory SqfCaseEntryModel.fromMap(Map<String, dynamic> map) {
    return SqfCaseEntryModel(
        case_date: map['case_date'],
        time: map['time'],
        date: map['date'],
        case_no: map['case_no'],
        slip_no: map['slip_no'],
        received_by: map['received_by'],
        patient_name: map['patient_name'],
        year: map['year'],
        month: map['month'],
        gender: map['gender'],
        mobile: map['mobile'],
        child_male: map['child_male'],
        child_female: map['child_female'],
        address: map['address'],
        agent: map['agent'],
        doctor: map['doctor'],
        test_name: map['test_name'],
        test_rate: map['test_rate'],
        total_amount: map['total_amount'],
        discount: map['discount'],
        after_discount: map['after_discount'],
        advance: map['advance'],
        balance: map['balance'],
        paid_amount: map['paid_amount'],
        pay_status: map['pay_status'],
        pay_mode: map['pay_mode'],
        discount_type: map['discount_type'],
        test_date: map['test_date'],
        test_file: map['test_file'],
        narration: map['narration'],
        name_title: map['name_title'],
        mon: map['mon'],
        yer: map['yer'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'case_date': case_date,
      'time': time,
      'date': date,
      'case_no': case_no,
      'slip_no': slip_no,
      'received_by': received_by,
      'patient_name': patient_name,
      'year': year,
      'month': month,
      'gender': gender,
      'mobile': mobile,
      'child_male': child_male,
      'child_female': child_female,
      'address': address,
      'agent': agent,
      'doctor': doctor,
      'test_name': test_name,
      'test_rate': test_rate,
      'total_amount': total_amount,
      'discount': discount,
      'after_discount': after_discount,
      'advance': advance,
      'balance': balance,
      'paid_amount': paid_amount,
      'pay_status': pay_status,
      'pay_mode': pay_mode,
      'discount_type': discount_type,
      'test_date': test_date,
      'test_file': test_file,
      'narration': narration,
      'name_title': name_title,
      'mon': mon,
      'yer': yer,
    };
  }

}