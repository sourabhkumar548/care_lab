import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Service/urls.dart';

part 'delete_doctor_state.dart';

class DeleteDoctorCubit extends Cubit<DeleteDoctorState> {
  DeleteDoctorCubit() : super(DeleteDoctorInitialState());

  void deleteDoctor(int id)async{
    emit(DeleteDoctorLoadingState());
    try{

      final response = await http.get(Uri.parse("${Urls.deleteDoctor}${id.toString()}"));
      if(response.statusCode == 200){
        emit(DeleteDoctorLoadedState(message: "Doctor delete successfully."));
      }else{
        emit(DeleteDoctorErrorState(errorMsg: "Doctor not delete"));
      }

    }on SocketException catch(e){
      emit(DeleteDoctorErrorState(errorMsg: "Network Error"));
    }catch(e){
      emit(DeleteDoctorErrorState(errorMsg: e.toString()));
    }
  }

}
