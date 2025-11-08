import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Model/case_number_model.dart';
import '../../../Service/urls.dart';

part 'case_number_state.dart';

class CaseNumberCubit extends Cubit<CaseNumberState> {
  CaseNumberCubit() : super(CaseNumberInitialState());

  getCaseNumber()async{

    emit(CaseNumberLoadingState());

    try{

      final response = await http.get(Uri.parse("${Urls.CaseNumberUrl}"));
      Map<String,dynamic> mapData = jsonDecode(response.body);
      CaseNumberModel caseNumberModel = CaseNumberModel.fromJson(mapData);
      if(caseNumberModel.caseNumber!.isNotEmpty){
        emit(CaseNumberLoadedState(CaseNumber: caseNumberModel.caseNumber!));
      }else{
        emit(CaseNumberErrorState(errorMsg: "Case Number Not Found"));
      }

    }on SocketException catch(e){
      emit(CaseNumberErrorState(errorMsg: e.message));
    }catch(e){
      emit(CaseNumberErrorState(errorMsg: "Case Number Not Found"));
    }

  }

}
