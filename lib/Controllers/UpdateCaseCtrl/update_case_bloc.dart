import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'update_case_event.dart';
part 'update_case_state.dart';

class UpdateCaseBloc extends Bloc<UpdateCaseEvent, UpdateCaseState> {
  UpdateCaseBloc() : super(UpdateCaseInitialState()) {
    on<CaseUpdateEvent>((event, emit)async {

      emit(UpdateCaseLoadingState());

      try{

        final response = await http.put(Uri.parse("${Urls.UpdateCase}${event.case_no}"),body: jsonEncode({
          "case_date":event.case_date,
          "time":event.time,
          "date":event.date,
          "case_no":event.case_no,
          "slip_no":event.slip_no,
          "received_by":event.received_by,
          "patient_name":event.patient_name,
          "year":event.year,
          "month":event.month,
          "gender":event.gender,
          "mobile":event.mobile,
          "child_male":event.child_male,
          "child_female":event.child_female,
          "address":event.address,
          "agent":event.agent,
          "doctor":event.doctor,
          "test_name":event.test_name,
          "test_rate":event.test_rate,
          "total_amount":event.total_amount,
          "discount":event.discount,
          "after_discount":event.after_discount,
          "advance":event.advance,
          "balance":event.balance,
          "paid_amount":event.paid_amount,
          "pay_status":event.pay_status,
          "pay_mode":event.pay_mode,
          "discount_type":event.discount_type,
          "test_date":event.test_date,
          "test_file":event.test_file,
          "narration":event.narration,
          "name_title":event.name_title,
        }),headers: {
          "Content-Type" : "application/json"
        });
        if(response.statusCode == 200){
          emit(UpdateCaseLoadedState(successMsg: "Case updated successfully"));
        }else{
          emit(UpdateCaseErrorState(errorMsg: response.body));
        }

      }on SocketException catch(e){
        emit(UpdateCaseErrorState(errorMsg: e.message));
      }catch(e){
        emit(UpdateCaseErrorState(errorMsg: e.toString()));
      }

    });
  }
}
