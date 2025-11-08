import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/payment_history_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Model/case_list_model.dart';
import '../../../Service/urls.dart';

part 'payment_history_state.dart';

class PaymentHistoryCubit extends Cubit<PaymentHistoryState> {
  PaymentHistoryCubit() : super(PaymentHistoryInitialState());


  GetHistory({required String case_no})async{

    emit(PaymentHistoryLoadingState());

    try{
      final response = await http.get(Uri.parse("${Urls.PaymentHistoryUrl}/$case_no"));
      Map<String,dynamic> mapData = jsonDecode(response.body);
      PaymentHistoryModel paymentHistoryModel = PaymentHistoryModel.fromJson(mapData);
      if(paymentHistoryModel.caseList!.isNotEmpty){
        emit(PaymentHistoryLoadedState(paymentHistoryModel: paymentHistoryModel));
      }else{
        emit(PaymentHistoryErrorState(errorMsg: "Case List Not Found"));
      }

    }on SocketException catch(e){
      emit(PaymentHistoryErrorState(errorMsg: e.message));
    }catch(e){
      emit(PaymentHistoryErrorState(errorMsg: "Case List Not Found"));
    }

  }

}
