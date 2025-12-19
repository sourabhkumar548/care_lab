import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/agent_collection_model.dart';
import 'package:care_lab_software/Model/sale_model.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../Service/urls.dart';

part 'agent_collection_state.dart';

class AgentCollectionCubit extends Cubit<AgentCollectionState> {
  AgentCollectionCubit() : super(AgentCollectionInitialState());


  getAgentCollection({required String fromdate,required String todate,required String agent})async{

    emit(AgentCollectionLoadingState());

    try{
      final uri = Uri.parse("${Urls.AgentCollection}agent=$agent&from_date=$fromdate&to_date=$todate&per_page=1000");
      final response = await http.get(uri);

      if(response.statusCode == 200){
        Map<String,dynamic> mapData = jsonDecode(response.body);
        SaleModel saleModel = SaleModel.fromJson(mapData);
        emit(AgentCollectionLoadedState(saleModel: saleModel));
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
