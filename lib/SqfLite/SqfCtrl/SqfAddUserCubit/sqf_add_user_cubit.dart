import 'package:bloc/bloc.dart';
import 'package:care_lab_software/SqfLite/SqfDB/db_helper.dart';
import 'package:care_lab_software/SqfLite/SqfDB/user_db.dart';
import 'package:care_lab_software/SqfLite/SqfModels/sqf_login_model.dart';
import 'package:meta/meta.dart';

part 'sqf_add_user_state.dart';

class SqfAddUserCubit extends Cubit<SqfAddUserState> {
  UserDb db;
  SqfAddUserCubit(this.db) : super(SqfAddUserInitialState());

  AddUser({required SQFUserModel userModel})async{

    emit(SqfAddUserLoadingState());

    try{
      final user = await db.insertUser(userModel);

      if(user > 0){
        emit(SqfAddUserLoadedState(successMsg: "Success"));
      }else{
        emit(SqfAddUserErrorState(errorMsg: "Failed"));
      }

    }catch(e){
      emit(SqfAddUserErrorState(errorMsg: "No user found"));
    }

  }

}
