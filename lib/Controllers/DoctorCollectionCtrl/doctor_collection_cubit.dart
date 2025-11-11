import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/doctor_collection_model.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'doctor_collection_state.dart';

class DoctorCollectionCubit extends Cubit<DoctorCollectionState> {
  DoctorCollectionCubit() : super(DoctorCollectionInitialState());

  getDoctorCollection({String? date,String? month,String? year,String? doctor})async{

    date!.isNotEmpty ? date : "0";
    month!.isNotEmpty ? month : "0";
    year != null ? year : "0";
    doctor != null ? doctor : "0";

    
    emit(DoctorCollectionLoadingState());
    
    try{
      
      final uri = Uri.parse("${Urls.DoctorCollection}date=${date}&month=${month}&year=${year}&doctor=${doctor}");
      final response = await http.get(uri);

      if(response.statusCode == 200){
        Map<String,dynamic> mapData = jsonDecode(response.body);
        DoctorCollectionModel doctorCollectionModel = DoctorCollectionModel.fromJson(mapData);
        emit(DoctorCollectionLoadedState(doctorCollectionModel: doctorCollectionModel));
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


