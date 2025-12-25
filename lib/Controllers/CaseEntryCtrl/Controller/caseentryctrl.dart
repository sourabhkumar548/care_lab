import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Helpers/case_entry_data.dart';
import '../../../Helpers/uiHelper.dart';
import '../Bloc/case_entry_bloc.dart';

class CaseEntryCtrl{

  static CaseEntry(
    {
      String? type,
      required BuildContext context,
      required String case_date,
      required String time,
      required String date,
      required String case_no,
      required String slip_no,
      required String received_by,
      required String patient_name,
      required String year,
      required String month,
      required String gender,
      required String mobile,
      required String child_male,
      required String child_female,
      required String address,
      required String agent,
      required String doctor,
      required String test_name,
      required String test_rate,
      required String total_amount,
      required String discount,
      required String after_discount,
      required String advance,
      required String balance,
      required String paid_amount,
      required String pay_status,
      required String pay_mode,
      required String discount_type,
      required String test_date,
      required String test_file,
      required String narration,
      required String name_title
    }
  ) {

      bool zero = false;

      if(CaseEnteryData.agentZero.contains(agent)){
        zero = true;
      }

      if (year.isEmpty) {
          year = "0";
      }
      if (month.isEmpty) {
          month = "0";
      }
      if (child_male.isEmpty) {
          child_male = "0";
      }
      if (child_female.isEmpty) {
          child_female = "0";
      }
      if (mobile.isEmpty) {
          mobile = "0";
      }
      if (narration.isEmpty) {
        narration = "None";
      }
      if (name_title.isEmpty) {
        name_title = "None";
      }
      if(case_no.isEmpty){
        case_no = "0001";
      }if(address.isEmpty){
        address = "Not Added";
      }

      if (patient_name.isEmpty) {
            UiHelper.showErrorToste(message: "Patient Name is Required",heading: "Required Field");
      } else if (test_name == "[]") {
          UiHelper.showErrorToste(message: "Select At Least One Test",heading: "Required Field");
      } else if (total_amount == "0" && zero == false) {
          UiHelper.showErrorToste(message: "Total Amount not Show",heading: "Required Field");
      } else {
          BlocProvider.of<CaseEntryBloc>(context).add(AddCaseEntryEvent(
              type: type,
              case_date: case_date,
              time: time,
              date: date,
              case_no: case_no,
              slip_no: slip_no,
              received_by: received_by,
              patient_name: patient_name,
              year: year,
              month: month,
              gender: gender,
              mobile: mobile,
              child_male: child_male,
              child_female: child_female,
              address: address,
              agent: agent,
              doctor: doctor,
              test_name: test_name,
              test_rate: test_rate,
              total_amount: total_amount,
              discount: discount,
              after_discount: after_discount,
              advance: advance,
              balance: balance,
              paid_amount: paid_amount,
              pay_status: pay_status,
              pay_mode: pay_mode,
              discount_type: discount_type,
              test_date: test_date,
              test_file: test_file,
              narration: narration,
              name_title: name_title
          ));
      }
  }
}