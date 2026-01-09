import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'add_doctor_state.dart';

class AddDoctorCubit extends Cubit<AddDoctorState> {
  AddDoctorCubit() : super(AddDoctorInitialState());

  addDoc({required String doctorName})async{
    emit(AddDoctorLoadingState());
    try{

      final response = await http.get(Uri.parse("${Urls.addDoctor}$doctorName"));
      if(response.statusCode == 200){
        emit(AddDoctorLoadedState(sussessMsg: "Doctor Added Successfully"));
      }else{
        emit(AddDoctorErrorState(errorMsg: "Doctor not added"));
      }

    }on SocketException catch(e){
      emit(AddDoctorErrorState(errorMsg: "Network Error"));
    }catch(e){
      emit(AddDoctorErrorState(errorMsg: e.toString()));
    }
  }

}
