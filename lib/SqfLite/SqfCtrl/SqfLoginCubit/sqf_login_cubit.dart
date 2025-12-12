import 'package:bloc/bloc.dart';
import 'package:care_lab_software/SqfLite/SqfModels/sqf_login_model.dart';
import 'package:meta/meta.dart';

import '../../SqfDB/db_helper.dart';
import '../../SqfDB/user_db.dart';

part 'sqf_login_state.dart';

class SqfLoginCubit extends Cubit<SqfLoginState> {
  final UserDb db;
  SqfLoginCubit(this.db) : super(SqfLoginInitialState());

  Login({required String username,required String password})async{

    emit(SqfLoginLoadingState());

    try{
      final user = await db.login(username, password);

      if(user != null){
        emit(SqfLoginLoadedState(sqfUserModel: user!));
      }else{
        emit(SqfLoginErrorState(errorMsg: "Wrong username or password"));
      }

    }catch(e){
      emit(SqfLoginErrorState(errorMsg: "No user found"));
    }

  }

  insertUser({required SQFUserModel user})async{

    emit(SqfLoginLoadingState());
    try{
      final data = await db.insertUser(user);
      if(data > 0){
        emit(SqfLoginAddLoadedState(successMsg: "Staff Inserted Successfully"));
      }else{
        emit(SqfLoginErrorState(errorMsg: "Data Not Insert"));
      }
    }catch(e){
      emit(SqfLoginErrorState(errorMsg: "Error : $e"));
    }

  }

  getUser()async{

    emit(SqfLoginLoadingState());
    try{
      final data = await db.getUsers();
      if(data.isNotEmpty){
        emit(SqfLoginDataLoadedState(sqfUserModel: data));
      }else{
        emit(SqfLoginErrorState(errorMsg: "Staff Not Found"));
      }
    }catch(e){
      emit(SqfLoginErrorState(errorMsg: "Error : $e"));
    }

  }

  deleteUser({required int id})async{
    emit(SqfLoginLoadingState());
    try{
      final data = await db.deleteUser(id);
      if(data > 0){
        emit(SqfLoginAddLoadedState(successMsg: "Staff Remove Successfully"));
      }else{
        emit(SqfLoginErrorState(errorMsg: "Staff Not Removed"));
      }
    }catch(e){
      emit(SqfLoginErrorState(errorMsg: "Error : $e"));
    }
  }


}