import 'package:bloc/bloc.dart';
import 'package:care_lab_software/SqfLite/SqfDB/case_entry_db.dart';
import 'package:care_lab_software/SqfLite/SqfModels/sqf_case_entry_model.dart';
import 'package:meta/meta.dart';

part 'sqf_case_entry_state.dart';

class SqfCaseEntryCubit extends Cubit<SqfCaseEntryState> {
  CaseEntryDb db;
  SqfCaseEntryCubit(this.db) : super(SqfCaseEntryInitialState());

  AddCaseEntry({required SqfCaseEntryModel userModel})async{

    emit(SqfCaseEntryLoadingState());

    try{
      final user = await db.insertCaseEntry(userModel);

      if(user > 0){
        emit(SqfCaseEntryLoadedState(successMsg: "Case Added Successful"));
      }else{
        emit(SqfCaseEntryErrorState(errorMsg: "Case not added"));
      }

    }catch(e){
      emit(SqfCaseEntryErrorState(errorMsg: "No user found"));
    }

  }

}
