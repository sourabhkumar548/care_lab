import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../Helpers/uiHelper.dart';
import '../LoginBloc/login_bloc.dart';

class LoginCtrl{

  static Login({required String username, required String password,required BuildContext context}){

    if(username.isEmpty){
      UiHelper.showErrorToste(message: "Enter Username then try again",heading: "Username Required");
    }else if(password.isEmpty){
      UiHelper.showErrorToste(message: "Enter Password then try again",heading: "Password Required");
    }else if(username == "None"){
      UiHelper.showErrorToste(message: "Enter Correct Username",heading: "Wrong Username");
    }else{
      context.read<LoginBloc>().add(UserLoginEvent(username: username, password: password));
    }

  }

}