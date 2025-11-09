import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/revenue_model.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'revenue_state.dart';

class RevenueCubit extends Cubit<RevenueState> {
  RevenueCubit() : super(RevenueInitialState());


  getRevenueDetail({String? get_today,String? get_month,String? get_year})async{

    DateTime now = DateTime.now();

    String today = get_today!.isNotEmpty ? get_today : "${now.day}-${now.month}-${now.year}";
    String month = get_month!.isNotEmpty ? get_month : now.month.toString();   // returns 1-12
    String year = get_year!.isNotEmpty ? get_year : now.year.toString();

    emit(RevenueLoadingState());

    try{
      final response = await http.get(Uri.parse("${Urls.GetRevenue}today=${today.toString()}&month=${month.toString()}&year=${year.toString()}"));
      if(response.statusCode == 200){

        Map<String,dynamic> mapData = jsonDecode(response.body);
        RevenueModel revenueModel = RevenueModel.fromJson(mapData);
        emit(RevenueLoadedState(revenueModel: revenueModel));
      }else{
        emit(RevenueErrorState(errorMsg: "Data not found"));
      }


    }on SocketException catch(e){
      emit(RevenueErrorState(errorMsg: e.message.toString()));
    }catch(e){
      emit(RevenueErrorState(errorMsg: e.toString()));
    }

  }


}
