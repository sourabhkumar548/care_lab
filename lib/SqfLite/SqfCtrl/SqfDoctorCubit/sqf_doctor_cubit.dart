import 'package:bloc/bloc.dart';
import 'package:care_lab_software/SqfLite/SqfDB/doctor_db.dart';
import 'package:care_lab_software/SqfLite/SqfModels/doctor_list_model.dart';
import 'package:get/get.dart';
import 'package:meta/meta.dart';

part 'sqf_doctor_state.dart';

class SqfDoctorCubit extends Cubit<SqfDoctorState> {
  DoctorDb db;
  SqfDoctorCubit(this.db) : super(SqfDoctorInitialState());

  InsertDoctor({required SqfDoctorListModel user})async{

    emit(SqfDoctorLoadingState());
    try{
      final data = await db.insertDoctor(user);
      if(data > 0){
        emit(SqfDoctorLoadedState(successMsg: "Doctor Inserted Successfully"));
      }else{
        emit(SqfDoctorErrorState(errorMsg: "Data Not Insert"));
      }
    }catch(e){
      emit(SqfDoctorErrorState(errorMsg: "Error : $e"));
    }

  }

  GetDoctor()async{

    emit(SqfDoctorLoadingState());
    try{
      final data = await db.getDoctor();
      if(data.isNotEmpty){
        emit(SqfDoctorDataLoadedState(sqfDoctorListModel: data));
      }else{
        emit(SqfDoctorErrorState(errorMsg: "Doctor Not Found"));
      }
    }catch(e){
      emit(SqfDoctorErrorState(errorMsg: "Error : $e"));
    }

  }

  deleteDoctor({required int id})async{
    emit(SqfDoctorLoadingState());
    try{
      final data = await db.deleteDoctor(id);
      if(data > 0){
        emit(SqfDoctorLoadedState(successMsg: "Doctor Remove Successfully"));
      }else{
        emit(SqfDoctorErrorState(errorMsg: "Doctor Not Removed"));
      }
    }catch(e){
      emit(SqfDoctorErrorState(errorMsg: "Error : $e"));
    }
  }

}
