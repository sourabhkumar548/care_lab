import 'package:bloc/bloc.dart';
import 'package:care_lab_software/SqfLite/SqfDB/test_list_db.dart';
import 'package:care_lab_software/SqfLite/SqfModels/sqf_test_list_model.dart';
import 'package:meta/meta.dart';

part 'sqf_add_test_state.dart';

class SqfAddTestCubit extends Cubit<SqfAddTestState> {

  TestListDb db;

  SqfAddTestCubit(this.db) : super(SqfAddTestInitialState());

  AddTestList({required SqfTestListModel sqftestlistModel})async{

    emit(SqfAddTestLoadingState());

    try{
      final user = await db.insertTestList(sqftestlistModel);

      if(user > 0){
        emit(SqfAddTestLoadedState(successMsg: "Success"));
      }else{
        emit(SqfAddTestErrorState(errorMsg: "Failed : $user"));
      }

    }catch(e){
      emit(SqfAddTestErrorState(errorMsg: "Error : $e"));
    }

  }

  getTestList()async{

    emit(SqfAddTestLoadingState());
    try{
      final data = await db.getTestList();
      if(data.isNotEmpty){
        emit(SqfAddTestShowLoadedState(sqfTestListModel: data));
      }else{
        emit(SqfAddTestErrorState(errorMsg: "Test List Not Found"));
      }
    }catch(e){
      emit(SqfAddTestErrorState(errorMsg: "Error : $e"));
    }

  }

  deleteTestList({required int id})async{
    emit(SqfAddTestLoadingState());
    try{
      final data = await db.deleteTestList(id);
      if(data > 0){
        emit(SqfAddTestLoadedState(successMsg: "Test Remove Successfully"));
      }else{
        emit(SqfAddTestErrorState(errorMsg: "Test Not Removed"));
      }
    }catch(e){
      emit(SqfAddTestErrorState(errorMsg: "Error : $e"));
    }
  }

}
