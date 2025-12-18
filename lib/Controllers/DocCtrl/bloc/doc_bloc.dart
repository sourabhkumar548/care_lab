import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;

import '../../../Service/urls.dart';

part 'doc_event.dart';
part 'doc_state.dart';

class DocBloc extends Bloc<DocEvent, DocState> {
  DocBloc() : super(DocInitialState()) {
    on<DocSendEvent>((event, emit) async{
      emit(DocLoadingState());

      try{
        final response = await http.post(Uri.parse(Urls.CreateReportUrl),body: jsonEncode({
          "name" : event.name,
          "date" : event.date,
          "slipno" : event.slipno,
          "age" : event.age,
          "sex" : event.sex,
          "referredby" : event.referredby,
          "filename" : event.filename,
          "main_file" : event.mainfile
        }),headers: {
          "Content-Type":"application/json"
        });
        if(response.statusCode == 200){
          emit(DocLoadedState(fileUrl: response.body));
        }
        else{
          emit(DocErrorState(errorMsg: "Error Occurred"));
        }
      }
      on SocketException catch(e){
        emit(DocErrorState(errorMsg: "Network Error...!"));
      }
      catch(e){
        emit(DocErrorState(errorMsg: e.toString()));
      }
    });
  }
}
