import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/check_report_pojo.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'check_report_state.dart';

class CheckReportCubit extends Cubit<CheckReportState> {
  CheckReportCubit() : super(CheckReportInitialState());


  checkReport({required String file})async{

    emit(CheckReportLoadingState());

    try{

      final response = await http.get(Uri.parse("${Urls.CheckReportUrl}${file}"));

      if(response.statusCode == 200){
        Map<String,dynamic> mapData = jsonDecode(response.body);
        CheckReportPojo checkReportPojo = CheckReportPojo.fromJson(mapData);
        emit(CheckReportLoadedState(checkReportPojo: checkReportPojo));
      }else{
        emit(CheckReportErrorState(errorMsg: response.body.toString()));
      }

    }on SocketException catch(e){
      emit(CheckReportErrorState(errorMsg: e.message.toString()));
    }catch(e){
      emit(CheckReportErrorState(errorMsg: e.toString()));
    }

  }

}
