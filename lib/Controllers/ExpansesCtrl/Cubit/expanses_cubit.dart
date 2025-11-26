import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/expanses_model.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
part 'expanses_state.dart';

class ExpansesCubit extends Cubit<ExpansesState> {
  ExpansesCubit() : super(ExpansesInitialState());

  SaveExpanses({
    required String name,
    required String amount,
    required String type,
    required String date,
    required String narration,
    required String paytype})async{

    GetStorage userBox = GetStorage();
    String User = userBox.read("newUser") ?? "";

    emit(ExpansesLoadingState());
    try{

      final response = await http.get(Uri.parse("${Urls.SaveExpanses}/$name/$amount/$type/$date/$User/$narration/$paytype"));
      if(response.statusCode == 200 ){
        emit(ExpansesLoadedState(successMsg: "Expanses Save Successfully"));
      }else{
        emit(ExpansesErrorState(errorMsg: "Something Went Wrong"));
      }

    }on SocketException catch(e){
      emit(ExpansesErrorState(errorMsg: e.message.toString()));
    }catch(e){
      emit(ExpansesErrorState(errorMsg: e.toString()));
    }

  }

  getExpanses({required String user})async{

    emit(ExpansesLoadingState());

    try{

      final response = await http.get(Uri.parse("${Urls.GetExpanses}/$user"));
      if(response.statusCode == 200 ){
        Map<String, dynamic> data = jsonDecode(response.body);
        ExpansesModel expansesModel = ExpansesModel.fromJson(data);
        emit(ExpansesGetState(expansesModel: expansesModel));
      }else{
        emit(ExpansesErrorState(errorMsg: "Expanses Not Found"));
      }

    }on SocketException catch(e){
      emit(ExpansesErrorState(errorMsg: e.message.toString()));
    }catch(e){
      emit(ExpansesErrorState(errorMsg: e.toString()));
    }

  }

}
