import 'package:bloc/bloc.dart';
import 'package:care_lab_software/SqfLite/SqfDB/agent_db.dart';
import 'package:meta/meta.dart';

import '../../SqfModels/sqf_agent_list_model.dart';

part 'sqf_agent_state.dart';

class SqfAgentCubit extends Cubit<SqfAgentState> {
  AgentDb db;
  SqfAgentCubit(this.db) : super(SqfAgentInitialState());

  insertAgent({required SqfAgentListModel user})async{

    emit(SqfAgentLoadingState());
    try{
      final data = await db.insertAgent(user);
      if(data > 0){
        emit(SqfAgentLoadedState(successMsg: "Agent Inserted Successfully"));
      }else{
        emit(SqfAgentErrorState(errorMsg: "Agent Not Insert"));
      }
    }catch(e){
      emit(SqfAgentErrorState(errorMsg: "Error : $e"));
    }

  }

  getAgent()async{

    emit(SqfAgentLoadingState());
    try{
      final data = await db.getAgent();
      if(data.isNotEmpty){
        emit(SqfAgentDataLoadedState(sqfAgentListModel: data));
      }else{
        emit(SqfAgentErrorState(errorMsg: "Agent Not Found"));
      }
    }catch(e){
      emit(SqfAgentErrorState(errorMsg: "Error : $e"));
    }

  }

  deleteAgent({required int id})async{
    emit(SqfAgentLoadingState());
    try{
      final data = await db.deleteAgent(id);
      if(data > 0){
        emit(SqfAgentLoadedState(successMsg: "Agent Remove Successfully"));
      }else{
        emit(SqfAgentErrorState(errorMsg: "Agent Not Removed"));
      }
    }catch(e){
      emit(SqfAgentErrorState(errorMsg: "Error : $e"));
    }
  }



}
