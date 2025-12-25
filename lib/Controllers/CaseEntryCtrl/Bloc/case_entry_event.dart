part of 'case_entry_bloc.dart';

@immutable
sealed class CaseEntryEvent {}

class AddCaseEntryEvent extends CaseEntryEvent{

  String? type;
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

  AddCaseEntryEvent({
    this.type,
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
});

}
