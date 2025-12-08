import 'dart:convert';
import 'dart:math';
import 'package:care_lab_software/Helpers/get_payment_history.dart';
import 'package:care_lab_software/Helpers/print_case_entry.dart';
import 'package:care_lab_software/Helpers/uiHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/CaseEntryCtrl/Bloc/case_entry_bloc.dart';
import '../Controllers/CaseEntryCtrl/Controller/caseentryctrl.dart';
import '../Controllers/CaseList/Cubit/case_list_cubit.dart';
import 'case_entry_data.dart';

class GetCaseList{

  static List<Map<String, dynamic>> pay_status = [];

  static GetCase({required String date,required BuildContext context}){

    context.read<CaseListCubit>().getCaseList(date: date,type: "All");

      return Column(
        children: [
          SizedBox(height: 5,),
          BlocBuilder<CaseListCubit, CaseListState>(
            builder: (context, state) {
              if(state is CaseListLoadingState){
                return Center(child: CircularProgressIndicator(),);
              }
              if(state is CaseListErrorState){
                return Center(child: Text(state.errorMsg,style: TextStyle(color: Colors.red,fontSize: 12.sp,fontFamily: 'font-bold'),),);
              }
              if(state is CaseListLoadedState){
                if(state.caseListModel.caseList!.isNotEmpty){

                  return ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (_,index){

                      GetCaseList.pay_status.add({
                        "case_no": "${state.caseListModel.caseList![index].caseNo}",
                        "status": state.caseListModel.caseList![index].balance! == "0" ? "Paid" : "Due"
                      });

                    return Container(
                      margin: EdgeInsets.only(bottom: 5),
                      color: index%2 == 0 ? Colors.grey.shade200 : Colors.white70,
                      child: ExpansionTile(title: Table(
                        columnWidths: {
                          0: FlexColumnWidth(1),
                          1: FlexColumnWidth(7),
                          2: FlexColumnWidth(3),
                          3: FlexColumnWidth(3),
                          4: FlexColumnWidth(3),
                          5: FlexColumnWidth(3),
                          6: FlexColumnWidth(.5),
                        },
                        children: [
                          TableRow(children: [
                            Center(child: UiHelper.CustText(text: "${state.caseListModel.caseList![index].caseNo!}",size: 12.sp)),
                            UiHelper.CustText(text: "${state.caseListModel.caseList![index].patientName!}",size: 12.sp),
                            Center(child: UiHelper.CustText(text: "Mobile : ${state.caseListModel.caseList![index].mobile!}",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Case Date : ${state.caseListModel.caseList![index].date}",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Total Amt : ${state.caseListModel.caseList![index].afterDiscount!}",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Status : ${state.caseListModel.caseList![index].balance! == "0" ? "Paid" : "Due"}",size: 12.sp)),
                            Center(child: Tooltip(
                                message: "Payment History",
                                child: IconButton(onPressed: ()=>GetPaymentHistory.GetHistory(
                                    context: context,
                                    Case_no: state.caseListModel.caseList![index].caseNo!,
                                    case_date: state.caseListModel.caseList![index].date!,
                                    name: state.caseListModel.caseList![index].patientName!,
                                  total: state.caseListModel.caseList![index].afterDiscount!,
                                  balance: state.caseListModel.caseList![index].balance!,
                                  status: "${state.caseListModel.caseList![index].balance! == "0" ? "Paid" : "Due"}"

                                ), icon  : Icon(Icons.list,color: Colors.blue.shade600,))),)
                          ])

                        ],
                      ),
                        children: [
                          Table(
                            defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                            columnWidths: {
                              0: FlexColumnWidth(.8),
                              1: FlexColumnWidth(.8),
                              2: FlexColumnWidth(.8),
                              3: FlexColumnWidth(.6),
                              4: FlexColumnWidth(.6),
                              5: FlexColumnWidth(.6),
                              6: FlexColumnWidth(.8),
                            },
                            border: TableBorder.all(width: 0.5, color: Colors.black),
                            children: [
                              TableRow(
                                  children: [
                                    Center(child: UiHelper.CustText(text: "Slip No",size: 12.sp,color: Colors.blue.shade700)),
                                    Center(child: UiHelper.CustText(text: "Pay Date",size: 12.sp,color: Colors.blue.shade700)),
                                    Center(child: UiHelper.CustText(text: "Total Amount",size: 12.sp,color: Colors.blue.shade700)),
                                    Center(child: UiHelper.CustText(text: "Advance",size: 12.sp,color: Colors.blue.shade700)),
                                    Center(child: UiHelper.CustText(text: "Paid",size: 12.sp,color: Colors.blue.shade700)),
                                    Center(child: UiHelper.CustText(text: "Balance",size: 12.sp,color: Colors.blue.shade700)),
                                    Center(child: UiHelper.CustText(text: "Actions",size: 12.sp,color: Colors.blue.shade700)),
                                  ]
                              )
                            ],
                          ),
                          ...state.caseListModel.caseList![index].items!.map((data){

                                String total = data.afterDiscount!.replaceFirst(RegExp(r"^0"), "");
                                String balance = data.balance!.replaceFirst(RegExp(r"^0"), "");
                                String advance = data.advance!.replaceFirst(RegExp(r"^0"), "");
                                String paid = data.paidAmount!.replaceFirst(RegExp(r"^0"), "");

                            return Container(
                              color: Colors.white,
                              child: Table(
                                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                  border: TableBorder.all(width: 0.5, color: Colors.grey),
                                columnWidths: {
                                  0: FlexColumnWidth(.8),
                                  1: FlexColumnWidth(.8),
                                  2: FlexColumnWidth(.8),
                                  3: FlexColumnWidth(.6),
                                  4: FlexColumnWidth(.6),
                                  5: FlexColumnWidth(.6),
                                  6: FlexColumnWidth(.8),
                                },
                                children: [
                                  TableRow(children: [
                                          Center(child: UiHelper.CustText(text: "${data.slipNo}",size: 12.sp)),
                                          Center(child: UiHelper.CustText(text: "${data.date}",size: 12.sp)),
                                          Center(child: UiHelper.CustText(text: "${total.isEmpty ? "0" : total}",size: 12.sp)),
                                          Center(child: UiHelper.CustText(text: "${advance.isEmpty ? "0" : advance}",size: 12.sp)),
                                          Center(child: UiHelper.CustText(text: "${paid.isEmpty ? "0" : paid}",size: 12.sp)),
                                          Center(child: UiHelper.CustText(text: "${balance.isEmpty ? "0" : balance}",size: 12.sp)),

                                          Row(children: [
                                            const SizedBox(width: 10,),
                                            Tooltip(
                                              message : "Make Payment",
                                              child: IconButton(onPressed: (){

                                                String? status = GetCaseList.pay_status
                                                    .firstWhere(
                                                      (element) => element["case_no"] == data.caseNo,
                                                  orElse: () => {},
                                                )["status"];

                                                status == "Due" ? showCaseDialog(context: context, case_no: data.caseNo!,case_date: data.caseDate!,case_time: data.time!, patient_name: data.patientName!, year: data.year!, month: data.month!, gender: data.gender!, mobile: data.mobile!, child_male: data.childMale!, child_female: data.childFemale!, address: data.address!, agent: data.agent!, doctor: data.doctor!, test_name: data.testName!, test_rate: data.testRate!, total_amount: data.totalAmount!, discount: data.discount!, after_discount: data.afterDiscount!, advance: advance, balance: balance!, discount_type: data.discountType!,test_date: data.testDate!, test_file: data.testFile!, narration: data.narration!, name_title: data.nameTitle!)
                                                : UiHelper.showSuccessToste(message: "Full Payment Already Paid",heading: "Payment Already Paid");
                                              }, icon: Icon(Icons.add_box_rounded,color: Colors.blue.shade600,)),
                                            ),
                                            const SizedBox(width: 10,),
                                            Tooltip(
                                              message : "Print Receipt",
                                              child: IconButton(onPressed: (){

                                                double d = double.parse(paid);

                                                String amountStr = d.toStringAsFixed(2);

                                                if (amountStr.endsWith('.00')) {
                                                  paid = paid;
                                                } else {
                                                  paid = "${paid}.00";
                                                }

                                                List<String> testName = data.testName!.split(",");
                                                List<String> testRate = data.testRate!.split(",");
                                                List<String> testDate = data.testDate!.split(",");
                                                PrintCaseEntry.printBill(receiptNo: data.slipNo!, receiptDate: data.date!, caseNo: data.caseNo!, caseDate: data.caseDate!, caseTime: data.time!, patientName: data.patientName!, mobile: data.mobile!, sex: data.gender!, age: "${data.year} Y ${data.month != "0" ? data.month :""}${data.month != "0" ? "M" :""} ", referredBy: data.doctor!, testName: testName, testRate: testRate, date: data.date!, totalAmount: total, discountAmount: paid, balanceAmount: data.balance!, advanceAmount: data.advance!, receivedBy: data.receivedBy!,testDate: testDate);
                                              }, icon: Icon(Icons.print,color: Colors.green.shade700,),),
                                            ),
                                            const SizedBox(width: 10,),
                                            Tooltip(
                                                message: "View Details",
                                                child: IconButton(onPressed: (){}, icon: Icon(Icons.list_alt,color: Colors.red.shade700,),))
                                          ],),
                                        ]
                                      )
                                  ]),
                            );
                          }),
                        ],
                      ),
                    );

                  },itemCount: state.caseListModel.caseList!.length);

                } else {
                  return Center(child: Text("No Cases Available",style: TextStyle(color: Colors.black,fontSize: 12.sp,fontFamily: 'font-bold'),),);
                }
              }
              return Center(child: Text("No Cases Available",style: TextStyle(color: Colors.black,fontSize: 12.sp,fontFamily: 'font-bold'),),);
            },
          ),
        ],
      );

  }

  static void showCaseDialog({required BuildContext context,
    required String case_date,
    required String case_no,
    required String case_time,
    required String patient_name,
    required String year,
    required String month,
    required String gender,
    required String mobile,
    required String child_male,
    required String child_female,
    required String address,
    required String agent,
    required String doctor,
    required String test_name,
    required String test_rate,
    required String total_amount,
    required String discount,
    required String after_discount,
    required String advance,
    required String balance,
    required String discount_type,
    required String test_date,
    required String test_file,
    required String narration,
    required String name_title
  }) {

    TextEditingController paidCtrl = TextEditingController(text: balance);
    String PayMode = "Cash";
    List<String> testName = test_name.split(",");
    List<String> testRate = test_rate.split(",");
    List<String> testDate = test_date.split(",");

    final twoDigitYear = (DateTime.now().year % 100).toString().padLeft(2, '0');
    Random data = Random();
    String receiptNo = "${data.nextInt(99999)}/${twoDigitYear}-${int.parse(twoDigitYear.toString())+1}";

    GetStorage box = GetStorage();
    String receivedBy = box.read("newUser");

    String newTime = "${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}";
    String newDate = "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SizedBox(
            width: Adaptive.w(40),
            height: Adaptive.h(40),
            child: Column(children: [

              Container(child: Column(children: [
                UiHelper.CustText(
                  text: "CARE DIAGNOSTIC CENTRE",
                  size: 12.sp,
                  fontfamily: 'font-regular',
                ),
                SizedBox(height: .5.h),
                UiHelper.CustText(
                  text: "NAYA BAZAR, NEAR GAYA PUL, DHANBAD - 826001",
                  size: 11.sp,
                  maxline: 3,
                ),
                SizedBox(height: .5.h),
                UiHelper.CustText(
                  text: "PH : 0326-2254788   |   Email : ede.dhn@gmail.com",
                  size: 11.sp,
                  maxline: 3,
                ),
                SizedBox(height: .5.h),
                Divider()
              ],),),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UiHelper.CustText(text: "Case No: $case_no",size: 11.sp,color: Colors.black),
                  UiHelper.CustText(text: "Case Date: $case_date",size: 11.sp,color: Colors.black),
              ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UiHelper.CustText(text: "Patient Name: $patient_name",size: 11.sp,color: Colors.black),
                  UiHelper.CustText(text: "Mobile: $mobile",size: 11.sp,color: Colors.black),
              ],),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UiHelper.CustText(text: after_discount == "0" ? "Total Amount : ${total_amount.replaceFirst(RegExp(r"^0"), "")}.00" : "Total Amount : ${after_discount.replaceFirst(RegExp(r"^0"), "")}.00",size: 11.sp,color: Colors.black),
                  UiHelper.CustText(text: balance == ".00" || balance == "0" || balance == "" ? "Advance: 0.00" : "Advance: ${advance.replaceFirst(RegExp(r"^0"), "")}.00",size: 11.sp,color: Colors.black),
                ],),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UiHelper.CustText(text: balance == ".00" || balance == "0" || balance == "" ? "Balance Amount: 0.00" : "Balance Amount: ${balance.replaceFirst(RegExp(r"^0"), "")}.00",size: 12.sp,color: Colors.green),
                  UiHelper.CustText(text:
                  advance == "0"
                      ? after_discount == "0" ? "Billed Amount : ${total_amount.replaceFirst(RegExp(r"^0"), "")}.00" : "Billed Amount : ${after_discount.replaceFirst(RegExp(r"^0"), "")}.00"
                      : "Billed Amount : ${advance.replaceFirst(RegExp(r"^0"), "")}.00",
                      size: 11.sp),
              ],),

              balance == ".00" || balance == "0" || balance == ""
                  ? Padding(
                    padding: const EdgeInsets.only(top: 30,bottom: 20),
                    child: Container(
                        padding: EdgeInsets.all(10),
                        color: Colors.green,
                        child: UiHelper.CustText(text: "Full payment has already paid successfully",color: Colors.white,size: 13.sp)),
                  )
                  : Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            UiHelper.CustDropDown(
                                label: "Pay Mode",
                                defaultValue: "Cash",
                                list: CaseEnteryData.payList,
                                onChanged: (val){
                                  PayMode = val!;
                                }
                            ),
                            const SizedBox(width: 20,),
                            UiHelper.CustTextField(controller: paidCtrl, label: "Bill Amount",icon: Icon(Icons.money))
                        ],)

                      ],),
                  )

            ],),
          ),
          actions: [

            BlocConsumer<CaseEntryBloc, CaseEntryState>(
              listener: (context, state) {
                if(state is CaseEntryLoadedState){



                  UiHelper.showSuccessToste(message: "Bill Paid Successfully");
                  // PrintCaseEntry.printBill(receiptNo: receiptNo,
                  //     receiptDate: "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}",
                  //     caseNo: case_no,
                  //     caseDate: newDate,
                  //     caseTime: newTime,
                  //     patientName: patient_name,
                  //     mobile: mobile,
                  //     sex: gender,
                  //     age: "${year} Y ${month} M",
                  //     referredBy: doctor,
                  //     testName: testName,
                  //     testRate: testRate,
                  //     date: case_date,
                  //     totalAmount: after_discount,
                  //     discountAmount: after_discount,
                  //     balanceAmount: "${int.parse(paidCtrl.text) - int.parse(balance)}",
                  //     advanceAmount: advance,
                  //     receivedBy: receivedBy,
                  //     testDate: testDate
                  // );
                }
                if(state is CaseEntryErrorState){
                  UiHelper.showErrorToste(message: state.errorMessage);
                }
              },
              builder: (context, state) {
                if(state is CaseEntryLoadingState){
                  return Center(child: CircularProgressIndicator());
                }
                return balance == ".00" || balance == "0" || balance == "" ? Container() : ElevatedButton(onPressed: (){

                  String pay_status = balance == paidCtrl.text ? "Paid" : "Due";

                  String adv = balance == ".00" || balance == "0" || balance == "" ? advance : "${int.parse(advance)+int.parse(paidCtrl.text)}";

                  CaseEntryCtrl.CaseEntry(context : context,case_date: case_date, time: newTime, date: newDate, case_no: case_no, slip_no: receiptNo, received_by: receivedBy, patient_name: patient_name, year: year, month: month, gender: gender, mobile: mobile, child_male: child_male, child_female: child_female, address: address, agent: agent, doctor: doctor, test_name: test_name, test_rate: test_rate, total_amount: total_amount, discount: discount, after_discount: after_discount, advance: adv, balance: "${int.parse(balance) - int.parse(paidCtrl.text)}",paid_amount: paidCtrl.text,pay_status: pay_status, pay_mode: PayMode, discount_type: discount_type,test_date: test_date,test_file: test_file,narration: narration,name_title: name_title);


                }, child: UiHelper.CustText(text: "Pay Now",fontfamily: 'font-bold',size: 12.sp,color: Colors.green),);
              },
            ),
            TextButton(
              onPressed: () =>Navigator.pushReplacementNamed(context, '/case_entry_list'),
              child: UiHelper.CustText(text: "Close",fontfamily: 'font-bold',size: 12.sp,color: Colors.red),
            ),

          ],
        );
      },
    );
  }

}