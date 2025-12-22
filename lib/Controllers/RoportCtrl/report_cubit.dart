import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/report_model.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'report_state.dart';

class ReportCubit extends Cubit<ReportState> {
  ReportCubit() : super(ReportInitialState());

  getAllReport()async{

    emit(ReportLoadingState());

    try{

      final response = await http.get(Uri.parse("${Urls.GetAllReport}"));
      if(response.statusCode == 200){

        Map<String,dynamic> mapData = jsonDecode(response.body);
        ReportModel reportModel = ReportModel.fromJson(mapData);
        emit(ReportLoadedState(reportModel: reportModel));

      }else{
        emit(ReportErrorState(errorMsg: "Report not found"));
      }

    }on SocketException catch(e){
      emit(ReportErrorState(errorMsg: e.message));
    }catch(e){
      emit(ReportErrorState(errorMsg: e.toString()));
    }

  }

}
