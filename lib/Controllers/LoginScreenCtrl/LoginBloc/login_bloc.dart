import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Service/urls.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitialState()) {
    on<UserLoginEvent>((event, emit) async{

      emit(LoginLoadingState());

      try{
        final response = await http.post(Uri.parse(Urls.LoginUrl),body: jsonEncode({
          "username":event.username,
          "password":event.password
        }),headers: {
          "Content-Type":"application/json"
        });
        if(response.statusCode == 200){
          emit(LoginLoadedState(Successmsg: "Successfully Login"));
        }
        else{
          emit(LoginErrorState(error: "Wrong password...!"));
        }
      }
      on SocketException catch(e){
        emit(LoginErrorState(error: "Server Error...!"));
      }
      catch(e){
        emit(LoginErrorState(error: e.toString()));
      }

    });
  }
}
