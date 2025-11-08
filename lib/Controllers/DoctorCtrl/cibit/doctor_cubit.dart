import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/doctor_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Service/urls.dart';

part 'doctor_state.dart';

class DoctorCubit extends Cubit<DoctorState> {
  DoctorCubit() : super(DoctorInitialState());


  GetDoctor()async{

    emit(DoctorLoadingState());

    try{

      final response = await http.get(Uri.parse(Urls.GetDoctorListUrl));
      if(response.statusCode == 200){

        Map<String,dynamic> mapData = json.decode(response.body);
        DoctorModel doctorModel = DoctorModel.fromJson(mapData);
        emit(DoctorLoadedState(doctorModel: doctorModel));

      }else{
        emit(DoctorErrorState(errorMsg: "Failed to load rate list. Status code: ${response.statusCode}"));
      }

    }on SocketException catch(e){
      emit(DoctorErrorState(errorMsg: e.toString()));
    }catch(e){
      emit(DoctorErrorState(errorMsg: e.toString()));
    }

  }

}
