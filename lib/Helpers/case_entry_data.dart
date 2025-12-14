import 'package:flutter/material.dart';

class CaseEnteryData {
  static List<String> monthList = List.generate(12, (index) => index.toString());
  static List<String> yearList = List.generate(100, (index) => index.toString());

  static List<String> agentList = ["Self","Sudhir Jha","Sekhu Ahmed","Minaj","CIMFR","Sri Ram Medical","Baby","Deepak Clinic","Health Assure","Health India","Medi Buddy","Red Cross Society","Maximum Health Care","Medpipper","Chottu","Dipak Clinic","Ajit Medical","Visit Health"];
  static List<String> agentZero = ["CIMFR","Health Assure","Health India","Medi Buddy","Red Cross Society","Maximum Health Care","Medpipper","Visit Health"];
  static List<String> discountTypeList = ["By D Mitra","By B Mitra","By Doctor","By Agent","Poor Patient","Regular Patient","Staff Discount"];

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