import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/between_date_model.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'between_date_state.dart';

class BetweenDateCubit extends Cubit<BetweenDateState> {
  BetweenDateCubit() : super(BetweenDateInitialState());

  getBetweenDate({required String startDate,required String endDate})async{

    emit(BetweenDateLoadingState());

    try{
      final response = await http.get(Uri.parse("${Urls.BetweenDateCollection}start_date=$startDate&end_date=$endDate"));
      if(response.statusCode == 200){
        Map<String,dynamic> data = jsonDecode(response.body);
        BetweenDateModel betweenDatesModel = BetweenDateModel.fromJson(data);
        emit(BetweenDateLoadedState(betweenDatesModel: betweenDatesModel));

      }else{
        emit(BetweenDateErrorState(errorMsg: "Data not found"));
      }
    }on SocketException catch(e){
      emit(BetweenDateErrorState(errorMsg: e.message.toString()));
    }catch(e){
      emit(BetweenDateErrorState(errorMsg: e.toString()));
    }

  }

}
