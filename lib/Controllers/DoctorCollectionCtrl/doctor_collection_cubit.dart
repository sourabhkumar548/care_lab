import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/doctor_collection_model.dart';
import 'package:care_lab_software/Model/sale_model.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'doctor_collection_state.dart';

class DoctorCollectionCubit extends Cubit<DoctorCollectionState> {
  DoctorCollectionCubit() : super(DoctorCollectionInitialState());

  getDoctorCollection({required String fromdate,required String todate,required String doctor})async{
    emit(DoctorCollectionLoadingState());
    
    try{
      final uri = Uri.parse("${Urls.DoctorCollection}doctor=$doctor&from_date=$fromdate&to_date=$todate&per_page=1000");
      final response = await http.get(uri);

      if(response.statusCode == 200){
        Map<String,dynamic> mapData = jsonDecode(response.body);
        SaleModel saleModel = SaleModel.fromJson(mapData);
        emit(DoctorCollectionLoadedState(saleModel: saleModel));
      }else{
        emit(DoctorCollectionErrorState(errorMsg: response.body));
      }
        
    }on SocketException catch(e){
      emit(DoctorCollectionErrorState(errorMsg: e.message.toString()));
    }catch(e){
      emit(DoctorCollectionErrorState(errorMsg: e.toString()));
    }
      
  }

}


