import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/department_model.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'department_state.dart';

class DepartmentCubit extends Cubit<DepartmentState> {
  DepartmentCubit() : super(DepartmentInitialState());

  getDepartmentWiseData({required String startDate,required String endDate,String? Department})async{

    emit(DepartmentLoadingState());

    try{

      Uri url;

      if(Department == "None"){
        url = Uri.parse("${Urls.departmentWiseCollection}start_date=${startDate}&end_date=${endDate}");
      }else{
        url = Uri.parse("${Urls.departmentWiseCollection}start_date=${startDate}&end_date=${endDate}&department=${Department}");
      }

      final response = await http.get(url);
      if(response.statusCode == 200){
        Map<String,dynamic> data = jsonDecode(response.body);
        DepartmentModel departmentModel = DepartmentModel.fromJson(data);
        emit(DepartmentLoadedState(departmentModel: departmentModel));
      }else{
        emit(DepartmentErrorState(errorMsg: "Data not found"));
      }

    }on SocketException catch(e){
      emit(DepartmentErrorState(errorMsg: e.message.toString()));
    }catch(e){
      emit(DepartmentErrorState(errorMsg: e.toString()));
    }

  }

}
