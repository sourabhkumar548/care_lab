import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/staff.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Service/urls.dart';

part 'staff_state.dart';

class StaffCubit extends Cubit<StaffState> {
  StaffCubit() : super(StaffInitialState());

  GetStaff()async{

    emit(StaffLoadingState());

    try{

      final response = await http.get(Uri.parse(Urls.GetStaffListUrl));
      if(response.statusCode == 200){

        Map<String,dynamic> mapData = json.decode(response.body);
        StaffModel staffModel = StaffModel.fromJson(mapData);
        emit(StaffLoadedState(staff: staffModel));

      }else{
        emit(StaffErrorState(errorMsg: "Failed to load staff list. Status code: ${response.statusCode}"));
      }

    }on SocketException catch(e){
      emit(StaffErrorState(errorMsg: e.toString()));
    }catch(e){
      emit(StaffErrorState(errorMsg: e.toString()));
    }

  }

}
