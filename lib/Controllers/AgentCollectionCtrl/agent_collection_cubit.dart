import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/agent_collection_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../Service/urls.dart';

part 'agent_collection_state.dart';

class AgentCollectionCubit extends Cubit<AgentCollectionState> {
  AgentCollectionCubit() : super(AgentCollectionInitialState());


  getAgentCollection({String? date,String? month,String? year,String? agent})async{

    date!.isNotEmpty ? date : "0";
    month!.isNotEmpty ? month : "0";
    year != null ? year : "0";
    agent != null ? agent : "0";

    emit(AgentCollectionLoadingState());

    try{
      final uri = Uri.parse("${Urls.AgentCollection}date=${date}&month=${month}&year=${year}&agent=${agent}");
      final response = await http.get(uri);

      if(response.statusCode == 200){
        Map<String,dynamic> mapData = jsonDecode(response.body);
        AgentCollectionModel agentCollectionModel = AgentCollectionModel.fromJson(mapData);
        emit(AgentCollectionLoadedState(agentCollectionModel: agentCollectionModel));
      }else{
        emit(AgentCollectionErrorState(errorMsg: response.body));
      }
    }on SocketException catch(e){
      emit(AgentCollectionErrorState(errorMsg: e.message.toString()));
    }catch(e){
      emit(AgentCollectionErrorState(errorMsg: e.toString()));
    }

  }

}
