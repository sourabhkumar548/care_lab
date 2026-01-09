import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'delete_agent_state.dart';

class DeleteAgentCubit extends Cubit<DeleteAgentState> {
  DeleteAgentCubit() : super(DeleteAgentInitialState());

  void deleteAgent(int id)async{
    emit(DeleteAgentLoadingState());
    try{

      final response = await http.get(Uri.parse("${Urls.deleteAgent}${id.toString()}"));
      if(response.statusCode == 200){
        emit(DeleteAgentLoadedState(message: "Agent delete successfully."));
      }else{
        emit(DeleteAgentErrorState(errorMsg: "Agent not delete"));
      }

    }on SocketException catch(e){
      emit(DeleteAgentErrorState(errorMsg: "Network Error"));
    }catch(e){
      emit(DeleteAgentErrorState(errorMsg: e.toString()));
    }
  }

}
