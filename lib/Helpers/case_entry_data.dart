import 'package:flutter/material.dart';

class CaseEnteryData {
  static List<String> monthList = List.generate(12, (index) => index.toString());
  static List<String> yearList = List.generate(100, (index) => index.toString());

  static List<String> doctorList = ["Self","(MRS) PRATIMA DUTTA  MBBS ( D.M.C.H.)","(DR.)R.N.SARKAR. MD,FICP.","(MAJOR)D.K.SINGH. (MBBS,AFMC.)","(MRS) MANISHA JALAN. MBBS."];
  static List<String> agentList = ["Self","Sourabh Kumar","Ujjal Dutta","Rajeesh Rawani"];
  static List<String> discountTypeList = ["Self","By Doctor","Other"];

  static List<DropdownMenuItem<String>> mChildList = List.generate(
    8,
        (index) => DropdownMenuItem(
      value: index.toString(),
      child: Text(index.toString()),
    ),
  );

  static List<DropdownMenuItem<String>> fChildList = List.generate(
    8,
        (index) => DropdownMenuItem(
      value: index.toString(),
      child: Text(index.toString()),
    ),
  );

  static List<DropdownMenuItem<String>> genderList = [
    DropdownMenuItem(value: "Male", child: Text("Male")),
    DropdownMenuItem(value: "Female", child: Text("Female")),
    DropdownMenuItem(value: "Other", child: Text("Other")),
  ];

  static List<DropdownMenuItem<String>> payList = [
    DropdownMenuItem(value: "Cash", child: Text("Cash")),
    DropdownMenuItem(value: "Online", child: Text("Online")),
    DropdownMenuItem(value: "Card", child: Text("Card")),
  ];
}