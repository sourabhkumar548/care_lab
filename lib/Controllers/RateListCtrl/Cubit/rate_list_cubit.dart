import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Model/rate_list_model.dart';
import '../../../Service/urls.dart';

part 'rate_list_state.dart';

class RateListCubit extends Cubit<RateListState> {
  RateListCubit() : super(RateListInitialState());

  GetRateList()async{

    emit(RateListLoadingState());

    try{

      final response = await http.get(Uri.parse(Urls.GetRateListUrl));
      if(response.statusCode == 200){

        Map<String,dynamic> mapData = json.decode(response.body);
        RateListModel rateListModel = RateListModel.fromJson(mapData);
        emit(RateListLoadedState(rateListModel: rateListModel));

      }else{
        emit(RateListErrorState(errorMsg: "Failed to load rate list. Status code: ${response.statusCode}"));
      }

    }on SocketException catch(e){
      emit(RateListErrorState(errorMsg: e.toString()));
    }catch(e){
      emit(RateListErrorState(errorMsg: e.toString()));
    }


  }

}
