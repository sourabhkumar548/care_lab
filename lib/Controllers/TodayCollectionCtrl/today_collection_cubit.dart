import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/today_collection_model.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'today_collection_state.dart';

class TodayCollectionCubit extends Cubit<TodayCollectionState> {
  TodayCollectionCubit() : super(TodayCollectionInitialState());

  getCollection({required String date})async{

    emit(TodayCollectionLoadingState());

    try{

      final response = await http.get(Uri.parse("${Urls.GetTodayCollection}$date"));
      if(response.statusCode == 200){
        Map<String,dynamic> mapData = jsonDecode(response.body);
        TodayCollectionModel todayCollectionModel = TodayCollectionModel.fromJson(mapData);
        emit(TodayCollectionLoadedState(todayCollectionModel: todayCollectionModel));
      }else{
        emit(TodayCollectionErrorState(errorMsg: "Collection not found"));
      }

    }on SocketException catch(e){
      emit(TodayCollectionErrorState(errorMsg: e.message));
    }catch(e){
      emit(TodayCollectionErrorState(errorMsg: e.toString()));
    }

  }

}
