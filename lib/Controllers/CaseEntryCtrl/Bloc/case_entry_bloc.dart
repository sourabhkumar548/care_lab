import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Service/urls.dart';

part 'case_entry_event.dart';
part 'case_entry_state.dart';

class CaseEntryBloc extends Bloc<CaseEntryEvent, CaseEntryState> {
  CaseEntryBloc() : super(CaseEntryInitialState()) {
    on<AddCaseEntryEvent>((event, emit) async{
      emit(CaseEntryLoadingState());
      try{

        final response = await http.post(Uri.parse(Urls.CaseEntryUrl),body: jsonEncode({
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
          final Map<String, dynamic> data = jsonDecode(response.body);
          final String caseNo = data['caseNo'];
          emit(CaseEntryLoadedState(successMessage: response.body,CaseNo: caseNo));
        }else if(response.statusCode == 500){
          emit(CaseEntryErrorState(errorMessage: response.body));
        }else{
          emit(CaseEntryErrorState(errorMessage: response.body));
        }

      }on SocketException catch(e){
        emit(CaseEntryErrorState(errorMessage: e.message));
      }catch(e){
        emit(CaseEntryErrorState(errorMessage: e.toString()));
      }
    });
  }
}
