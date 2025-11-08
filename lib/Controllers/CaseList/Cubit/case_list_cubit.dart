import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Model/case_list_model.dart';
import '../../../Service/urls.dart';

part 'case_list_state.dart';

class CaseListCubit extends Cubit<CaseListState> {
  CaseListCubit() : super(CaseListInitialState());

  getCaseList({required String date,required String type})async{

    emit(CaseListLoadingState());

    try{

      final response = await http.get(Uri.parse("${Urls.CaseEntryListUrl}/$date/$type"));
      Map<String,dynamic> mapData = jsonDecode(response.body);
      CaseListModel caseListModel = CaseListModel.fromJson(mapData);
      if(caseListModel.caseList!.isNotEmpty){
        emit(CaseListLoadedState(caseListModel: caseListModel));
      }else{
        emit(CaseListErrorState(errorMsg: "Case List Not Found"));
      }

    }on SocketException catch(e){
      emit(CaseListErrorState(errorMsg: e.message));
    }catch(e){
      emit(CaseListErrorState(errorMsg: "Case List Not Found"));
    }

  }

}
