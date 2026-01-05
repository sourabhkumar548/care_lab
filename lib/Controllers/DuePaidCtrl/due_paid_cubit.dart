import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/due_collection_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../Service/urls.dart';

part 'due_paid_state.dart';

class DuePaidCubit extends Cubit<DuePaidState> {
  DuePaidCubit() : super(DuePaidInitialState());

  getDueCollection({required String date})async {

    emit(DuePaidLoadingState());

    try{

      final response = await http.get(Uri.parse("${Urls.GetDueCollection}$date"));
      if(response.statusCode == 200){
        Map<String,dynamic> mapData = jsonDecode(response.body);
        DueCollectionModel dueCollectionModel = DueCollectionModel.fromJson(mapData);
        emit(DuePaidLoadedState(dueCollectionModel: dueCollectionModel));
      }else{
        emit(DuePaidErrorState(errorMsg: "Due Collection not found"));
      }

    }on SocketException catch(e){
      emit(DuePaidErrorState(errorMsg: e.message));
    }catch(e){
      emit(DuePaidErrorState(errorMsg: e.toString()));
    }

  }

}
