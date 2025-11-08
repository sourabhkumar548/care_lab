import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Helpers/uiHelper.dart';
import 'bloc/doc_bloc.dart';

class DocCtrl{
  static Doc({
    required BuildContext context,
    required String name,
    required String date,
    required String slipno,
    required String age,
    required String sex,
    required String referredby,
    required String filename,
    required String mainfile,})
  {
    if(name.isEmpty){
      UiHelper.showErrorToste(message: "Name is Empty try again",heading: "Required");
    }else if(date.isEmpty){
      UiHelper.showErrorToste(message: "Date is Empty try again",heading: "Required");
    }else if(slipno.isEmpty){
      UiHelper.showErrorToste(message: "Slip No is Empty try again",heading: "Required");
    }else if(age.isEmpty){
      UiHelper.showErrorToste(message: "Age is Empty try again",heading: "Required");
    }else if(sex.isEmpty){
      UiHelper.showErrorToste(message: "Gender is Empty try again",heading: "Required");
    }else if(referredby.isEmpty){
      UiHelper.showErrorToste(message: "Doctor Name is Empty try again",heading: "Required");
    }else if(filename.isEmpty){
      UiHelper.showErrorToste(message: "File Name is Empty try again",heading: "Required");
    }else if(mainfile.isEmpty){
      UiHelper.showErrorToste(message: "Default File Not Found try again",heading: "Required");
    }else{
      context.read<DocBloc>().add(DocSendEvent(name: name, date: date, slipno: slipno, age: age, sex: sex, referredby: referredby, filename: filename, mainfile: mainfile));
    }

  }
}