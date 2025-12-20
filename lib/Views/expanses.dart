import 'dart:convert';

import 'package:care_lab_software/Controllers/CheckReportCtrl/check_report_cubit.dart';
import 'package:care_lab_software/Controllers/ExpansesCtrl/Cubit/expanses_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:web/web.dart' as html;

import '../Controllers/CaseList/Cubit/case_list_cubit.dart';
import '../Controllers/DocCtrl/bloc/doc_bloc.dart';
import '../Controllers/DocCtrl/doc_ctrl.dart';
import '../Controllers/LoginScreenCtrl/UsernameCubit/username_cubit.dart';
import '../Helpers/get_reporting_list.dart';
import '../Helpers/print_case_entry.dart';
import '../Helpers/uiHelper.dart';
import 'loginscreen.dart';

class Expanses extends StatefulWidget {
  Expanses({super.key});

  @override
  State<Expanses> createState() => _ExpansesState();
}
class _ExpansesState extends State<Expanses> {

  TextEditingController nameCtrl = TextEditingController();
  TextEditingController amountCtrl = TextEditingController();
  TextEditingController dateCtrl = TextEditingController(text:
  "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
  TextEditingController narrationCtrl = TextEditingController();

  var username = "All";


  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String accessCode = args["code"];

    if(accessCode != "/expanses"){

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LabLoginScreen()), (val)=>true);

    }

    context.read<ExpansesCubit>().getExpanses(user: username);

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
                      widget: Expanded(
                        child: Row(
                          children: [
                            Spacer(),
                            getUser(),
                            const SizedBox(width: 20,),
                            ElevatedButton(onPressed: ()=>addExpanses(), child: UiHelper.CustText(text: "Add Expanses")),
                          ],
                        ),
                      )
                    ),
                    SizedBox(height: 10),
                    getExpanses()
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
                      widget: Expanded(
                        child: Row(
                          children: [
                            Spacer(),
                            getUser(),
                            const SizedBox(width: 20,),
                            ElevatedButton(onPressed: ()=>addExpanses(), child: UiHelper.CustText(text: "Add Expanses")),
                          ],
                        ),
                      )
                    ),
                    SizedBox(height: 10),
                    getExpanses()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getExpanses() {
    return BlocBuilder<ExpansesCubit, ExpansesState>(
      builder: (context, state) {
        if (state is ExpansesLoadingState) {
          return Center(child: CircularProgressIndicator());
        }

        if (state is ExpansesErrorState) {
          return Center(child: UiHelper.CustText(text: state.errorMsg));
        }

        if (state is ExpansesGetState) {
          var exp = state.expansesModel.expanses ?? [];

          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Sl.No", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red))),
                DataColumn(label: Text("Name", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red))),
                DataColumn(label: Text("Amount", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red))),
                DataColumn(label: Text("Type", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red))),
                DataColumn(label: Text("Date", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red))),
                DataColumn(label: Text("Narration", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red))),
                DataColumn(label: Text("Pay Type", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red))),
                DataColumn(label: Text("Pay By", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.red))),
              ],
              rows: exp.asMap().entries.map((entry) {
                int index = entry.key;
                var data = entry.value;

                return DataRow(cells: [
                  DataCell(Text("${index + 1}", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(data.personName ?? "", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("₹${data.amount}.00", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("${data.debitCredit}", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("${data.date}", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("${data.narration}", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("${data.payType}", style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("${data.paidBy}", style: TextStyle(fontWeight: FontWeight.bold))),
                ]);
              }).toList(),
            ),
          );
        }

        return Container();
      },
    );
  }


  addExpanses(){

    List<DropdownMenuItem<String>> drcrList = [
      DropdownMenuItem(value: "Debit", child: Text("Debit")),
      DropdownMenuItem(value: "Credit", child: Text("Credit")),
    ];

    List<DropdownMenuItem<String>> payList = [
      DropdownMenuItem(value: "Cash", child: Text("Cash")),
      DropdownMenuItem(value: "Online", child: Text("Online")),
      DropdownMenuItem(value: "Card", child: Text("Card")),
    ];

    String payType = "Cash";
    String drcr = "Debit";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: UiHelper.CustText(text: "Add Expanses",size: 11.sp),
          content: Container(
            height: 500,
            width: 500,
            child: ListView(
              shrinkWrap: true,
              children: [
                  UiHelper.CustTextField(controller: nameCtrl, label: "Enter Name",icon: Icon(Icons.person)),
                const SizedBox(height: 15),
                  UiHelper.CustTextField(controller: amountCtrl, label: "Enter Amount",icon: Icon(Icons.monetization_on)),
                const SizedBox(height: 15),
                  UiHelper.CustDropDown(label: "Select Type", defaultValue: "Debit", list: drcrList, onChanged: (val){
                    setState(() {
                      drcr = val!;
                    });
                  }),
                const SizedBox(height: 15),
                Container(
                  width: 300,
                  height: 50,
                  child: TextField(
                    controller: dateCtrl,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        labelText: "Select Date",
                        filled: true,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: Colors.black45, width: 1.5),
                        ),
                        fillColor: Colors.grey.shade100,
                        labelStyle: TextStyle(
                            color: Colors.black,
                            fontFamily: 'font-bold',
                            fontSize: 11.sp),
                        prefixIcon: Icon(Icons.calendar_month),
                        suffixIcon: GestureDetector(
                            onTap: () async {
                              DateTime? pickedDate = await showOmniDateTimePicker(
                                context: context,
                                type: OmniDateTimePickerType.date,
                              );

                              if (pickedDate != null) {
                                String formattedDate =
                                    "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                                setState(() {
                                  dateCtrl.text = formattedDate;
                                });
                              }
                            },
                            child: Icon(Icons.calendar_month))),
                  ),
                ),
                const SizedBox(height: 15),
                  UiHelper.CustTextField(controller: narrationCtrl, label: "Enter Narration",icon: Icon(Icons.text_fields_outlined)),
                const SizedBox(height: 15),
                  UiHelper.CustDropDown(label: "Select Pay Type", defaultValue: "Cash", list: payList, onChanged: (val){
                    setState(() {
                      payType = val!;
                    });
                  }),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Cancel"),
              onPressed: () {
                nameCtrl.clear();
                amountCtrl.clear();
                dateCtrl.clear();
                narrationCtrl.clear();
                Navigator.of(context).pop(false);
              }
            ),
            BlocConsumer<ExpansesCubit, ExpansesState>(
              listener: (context, state) {
                if(state is ExpansesLoadedState){
                  UiHelper.showSuccessToste(message: state.successMsg);
                }
                if(state is ExpansesErrorState){
                 UiHelper.showErrorToste(message: state.errorMsg);
                }
              },
              builder: (context, state) {
                if(state is ExpansesLoadingState){
                  return Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () {
                    context.read<ExpansesCubit>().SaveExpanses(name: nameCtrl.text, amount: amountCtrl.text, type: drcr, date: dateCtrl.text, narration: narrationCtrl.text, paytype: payType);
                    nameCtrl.clear();
                    amountCtrl.clear();
                    dateCtrl.clear();
                    narrationCtrl.clear();
                  },
                );
              },
            )
          ],
        );
      },
    );
  }

  Widget getUser(){
    return SizedBox(
      width: 300,
      child: BlocBuilder<UsernameCubit, UsernameState>(
        builder: (context, state) {
          if(state is UsernameLoadingState){
            return Center(child: CircularProgressIndicator());
          }
          if(state is UsernameErrorState){
            return Text(state.error);
          }
          if(state is UsernameLoadedState){
            List<DropdownMenuItem<String>> staffList = [
              const DropdownMenuItem(value: "None", child: Text("None")),
              const DropdownMenuItem(value: "All", child: Text("All")),
              ...state.usernameModel.username!.map((val)=>DropdownMenuItem(value: val, child: Text(val))).toList()
            ];
            return Row(children: [
              UiHelper.CustDropDown(label: "Select User", defaultValue: "None", list: staffList,icon: Icon(Icons.person),
                  onChanged: (val){
                    setState(() {
                      username = val!;
                    });

                  }
              )
            ],);
          }
          return Container();
        },
      ),
    );
  }

}