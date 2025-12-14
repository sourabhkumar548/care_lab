import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/case_model.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'single_case_state.dart';

class SingleCaseCubit extends Cubit<SingleCaseState> {
  SingleCaseCubit() : super(SingleCaseInitialState());

  getSingleCase({required String caseno})async{

    emit(SingleCaseLoadingState());

    try{

      final response = await http.get(Uri.parse("${Urls.GetSingleCase}$caseno"));

      if(response.statusCode == 200){

        Map<String,dynamic> mapData = jsonDecode(response.body);
        CaseModel caseModel = CaseModel.fromJson(mapData);
        emit(SingleCaseLoadedState(caseModel: caseModel));

      }else{
        emit(SingleCaseErrorState(errorMsg: "Case Not Found"));
      }

    }on SocketException catch(e){
      emit(SingleCaseErrorState(errorMsg: e.message));
    }catch(e){
      emit(SingleCaseErrorState(errorMsg: e.toString()));
    }

  }
}
