import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'delete_rate_list_state.dart';

class DeleteRateListCubit extends Cubit<DeleteRateListState> {
  DeleteRateListCubit() : super(DeleteRateListInitialState());


  DeleteRateList({required String id})async{

    emit(DeleteRateListLoadingState());

    try{

      final response = await http.get(Uri.parse("${Urls.DeleteRateList}$id"));
      if(response.statusCode == 200){
        emit(DeleteRateListLoadedState(successMsg: "Rate List Delete Successfully"));
      }else{
        emit(DeleteRateListErrorState(errorMsg: "Rate List Not Deleted"));
      }
      
    }on SocketException catch(e){
      emit(DeleteRateListErrorState(errorMsg: e.message));
    }catch(e){
      emit(DeleteRateListErrorState(errorMsg: e.toString()));
    }

  }

}
