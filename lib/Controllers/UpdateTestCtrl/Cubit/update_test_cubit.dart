import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/Model/update_test_model.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

part 'update_test_state.dart';

class UpdateTestCubit extends Cubit<UpdateTestState> {
  UpdateTestCubit() : super(UpdateTestInitialState());

  getUpdateTest({required String id,required String fileName,required PlatformFile file})async{

    emit(UpdateTestLoadingState());

    try{

      var uri = Uri.parse("https://dzda.in/upload.php");
      var request = http.MultipartRequest("POST", uri);
      request.files.add(http.MultipartFile.fromBytes('file', file.bytes!,filename: file.name,));
      var response = await request.send();
      var respStr = await response.stream.bytesToString();

      var data = jsonDecode(respStr);
      String status = data['status'];

      if(status == 'success'){

        final response = await http.get(Uri.parse("${Urls.UpdateTest}/$id/$fileName"));

        if(response.statusCode == 200){

          Map<String,dynamic> mapData = json.decode(response.body);
          UpdateTestModel updateTestModel = UpdateTestModel.fromJson(mapData);
          emit(UpdateTestLoadedState(updateTestModel: updateTestModel));

        }else{
          emit(UpdateTestErrorState(errorMsg: "File not updated"));
        }

      }else{
        emit(UpdateTestErrorState(errorMsg: "File Not Updated"));
      }

    }on SocketException catch(e){
      emit(UpdateTestErrorState(errorMsg: e.message.toString()));
    }catch(e){
      emit(UpdateTestErrorState(errorMsg: e.toString()));
    }

  }


}
