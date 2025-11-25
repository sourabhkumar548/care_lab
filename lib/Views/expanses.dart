import 'dart:convert';

import 'package:care_lab_software/Controllers/CheckReportCtrl/check_report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:web/web.dart' as html;

import '../Controllers/CaseList/Cubit/case_list_cubit.dart';
import '../Controllers/DocCtrl/bloc/doc_bloc.dart';
import '../Controllers/DocCtrl/doc_ctrl.dart';
import '../Helpers/get_reporting_list.dart';
import '../Helpers/print_case_entry.dart';
import '../Helpers/uiHelper.dart';

class Expanses extends StatefulWidget {
  Expanses({super.key});

  @override
  State<Expanses> createState() => _ExpansesState();
}

class _ExpansesState extends State<Expanses> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Device.width < 1100 ?

      Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            //SIDE BAR
            Container(
              height: 120,
              child: UiHelper.custHorixontalTab(container: "7", context: context),
            ),
            //MAIN CONTENT
            Container(
              height: Adaptive.h(100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "DAILY EXPANSES LIST",
                      widget: ElevatedButton(onPressed: ()=>addExpanses(), child: UiHelper.CustText(text: "Add Expanses"))
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      )


          :
      Center(
        child: Row(
          children: [
            //SIDE BAR
            Container(
              width: Adaptive.w(15),
              child: UiHelper.custsidebar(container: "15", context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "DAILY EXPANSES LIST",
                      widget: ElevatedButton(onPressed: ()=>addExpanses(), child: UiHelper.CustText(text: "Add Expanses"))
                    ),
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  addExpanses(){
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: UiHelper.CustText(text: "Add Expanses",size: 10.5.sp),
          content: Container(
            height: 500,
            width: 500,
            child: ListView(
              shrinkWrap: true,
              children: [
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            ElevatedButton(
              child: const Text("Save"),
              onPressed: () {},
            ),
          ],
        );
      },
    );
  }

}