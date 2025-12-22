import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'test_data_state.dart';

class TestDataCubit extends Cubit<TestDataState> {
  TestDataCubit() : super(TestDataInitialState());

  updateTestData({required String id,required String name,required String rate,required String time,required String department})async{

    emit(TestDataLoadingState());

    try{

      final response = await http.get(Uri.parse("${Urls.updateTestData}$id/$name/$rate/$time/$department"));

      if(response.statusCode == 200 ){
        emit(TestDataLoadedState(successMsg: "Test updated successfully"));
      }else{
        emit(TestDataErrorState(errorMsg: "Test not updated.Try again!!"));
      }

    }on SocketException catch(e){
      emit(TestDataErrorState(errorMsg: e.message));
    }catch(e){
      emit(TestDataErrorState(errorMsg: e.toString()));
    }

  }

}
