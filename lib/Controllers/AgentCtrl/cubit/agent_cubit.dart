import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/agent_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Service/urls.dart';

part 'agent_state.dart';

class AgentCubit extends Cubit<AgentState> {
  AgentCubit() : super(AgentInitialState());


  GetAgent()async{

    emit(AgentLoadingState());

    try{

      final response = await http.get(Uri.parse(Urls.GetAgentListUrl));
      if(response.statusCode == 200){

        Map<String,dynamic> mapData = json.decode(response.body);
        AgentModel agentModel = AgentModel.fromJson(mapData);
        emit(AgentLoadedState(agentModel: agentModel));

      }else{
        emit(AgentErrorState(errorMsg: "Failed to load agent list. Status code: ${response.statusCode}"));
      }

    }on SocketException catch(e){
      emit(AgentErrorState(errorMsg: e.toString()));
    }catch(e){
      emit(AgentErrorState(errorMsg: e.toString()));
    }

  }

}
