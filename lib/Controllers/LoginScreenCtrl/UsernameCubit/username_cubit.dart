import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Model/username.dart';
import '../../../Service/urls.dart';

part 'username_state.dart';

class UsernameCubit extends Cubit<UsernameState> {
  UsernameCubit() : super(UsernameInitialState());

  getUsername()async{
    try{
      final response = await http.get(Uri.parse(Urls.UsernameUrl));
      if(response.statusCode == 200){
        Map<String,dynamic> mapData = jsonDecode(response.body);
        UsernameModel usernameModel = UsernameModel.fromJson(mapData);
        emit(UsernameLoadedState(usernameModel: usernameModel));
      }
      else{
        emit(UsernameErrorState(error: "Data not found..!"));
      }
    }
    on SocketException catch(e){
      emit(UsernameErrorState(error: "Server Error"));
    }
    catch(e){
      emit(UsernameErrorState(error: e.toString()));
    }
  }

}
