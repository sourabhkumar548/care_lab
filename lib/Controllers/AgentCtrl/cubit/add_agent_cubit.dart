import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Service/urls.dart';

part 'add_agent_state.dart';

class AddAgentCubit extends Cubit<AddAgentState> {
  AddAgentCubit() : super(AddAgentInitialState());

  addAgent({required String agentName})async{
    print("Call Cubit");
    emit(AddAgentLoadingState());
    try{

      final response = await http.get(Uri.parse("${Urls.addAgent}$agentName"));
      if(response.statusCode == 200){
        emit(AddAgentLoadedState(successMsg: "Agent Added Successfully"));
      }else{
        emit(AddAgentErrorState(errorMsg: "Agent not added"));
      }

    }on SocketException catch(e){
      emit(AddAgentErrorState(errorMsg: "Network Error"));
    }catch(e){
      emit(AddAgentErrorState(errorMsg: e.toString()));
    }
  }

}
