import 'dart:convert';
import 'dart:math';
import 'package:care_lab_software/Helpers/get_payment_history.dart';
import 'package:care_lab_software/Helpers/print_case_entry.dart';
import 'package:care_lab_software/Helpers/uiHelper.dart';
import 'package:care_lab_software/Views/edit_case_entry.dart';
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
import 'constants.dart';

class GetCaseList{

  static List<Map<String, dynamic>> pay_status = [];

  static GetCase({required String date, required BuildContext context}) {

    context.read<CaseListCubit>().getCaseList(date: date, type: "All");

    TextEditingController searchCtrl = TextEditingController();
    ValueNotifier<String> searchQuery = ValueNotifier("");

    return Column(
      children: [

        /// 🔍 SEARCH BAR
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: searchCtrl,
            decoration: InputDecoration(
              hintText: "Search by Case No / Patient Name / Mobile",
              prefixIcon: Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
                suffixIcon: IconButton(onPressed: (){searchCtrl.clear();searchQuery.value = "";}, icon: Icon(Icons.close))
            ),
            onChanged: (val) {
              searchQuery.value = val.toLowerCase();
            },
          ),
        ),

        SizedBox(height: 5),

        BlocBuilder<CaseListCubit, CaseListState>(
          builder: (context, state) {

            if (state is CaseListLoadingState) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is CaseListErrorState) {
              return Center(
                child: Text(
                  state.errorMsg,
                  style: TextStyle(color: Colors.red, fontSize: 12.sp),
                ),
              );
            }

            if (state is CaseListLoadedState) {

              if (state.caseListModel.caseList!.isEmpty) {
                return Center(
                  child: Text(
                    "No Cases Available",
                    style: TextStyle(fontSize: 12.sp),
                  ),
                );
              }

              return ValueListenableBuilder<String>(
                valueListenable: searchQuery,
                builder: (context, query, _) {

                  final filteredList = state.caseListModel.caseList!.where((c) {
                    return c.caseNo!.toLowerCase().contains(query) ||
                        c.patientName!.toLowerCase().contains(query) ||
                        c.mobile!.toLowerCase().contains(query);
                  }).toList();

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Text(
                        "No matching cases found",
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredList.length,
                    itemBuilder: (_, index) {

                      final caseData = filteredList[index];

                      GetCaseList.pay_status.add({
                        "case_no": caseData.caseNo,
                        "status": caseData.balance == "0" || caseData.balance == ".00" || caseData.balance == "0.00"  ? "Paid" : "Due"
                      });

                      /// ⬇️ BELOW CODE IS 100% SAME AS YOURS00
                      return Container(
                        margin: EdgeInsets.only(bottom: 5),
                        color: index%2 == 0 ? Colors.grey.shade200 : Colors.white70,
                        child: ExpansionTile(title: Table(
                          columnWidths: {
                            0: FlexColumnWidth(1),
                            1: FlexColumnWidth(5),
                            2: FlexColumnWidth(4.5),
                            3: FlexColumnWidth(3),
                            4: FlexColumnWidth(2.5),
                            5: FlexColumnWidth(3),
                            6: FlexColumnWidth(1.5),
                          },
                          children: [
                            TableRow(children: [
                              Center(child: UiHelper.CustText(text: "${caseData.caseNo!}",size: 12.sp)),
                              UiHelper.CustText(text: "${caseData.patientName!}",size: 12.sp),
                              Center(child: UiHelper.CustText(text: "Mobile : ${caseData.mobile!}",size: 12.sp)),
                              Center(child: UiHelper.CustText(text: "Case Date : ${caseData.date}",size: 12.sp)),
                              Center(child: UiHelper.CustText(text: "Total Amt : ${caseData.afterDiscount!}",size: 12.sp)),
                              Center(child: UiHelper.CustText(text: "Status : ${caseData.balance! == "0"|| caseData.balance! == ".00" || caseData.balance! == "0.00" ? "Paid" : "Due"}",size: 12.sp)),
                              Center(child: Row(
                                children: [

                                  Tooltip(
                                      message: "Edit Case",
                                      child: IconButton(onPressed: ()=>Get.to(EditCaseEntry(case_no: caseData.caseNo!)),
                                          icon: Icon(Icons.edit,color: Colors.green,))),

                                  Tooltip(
                                      message: "Payment History",
                                      child: IconButton(onPressed: (){


                                        List<String> nameList = caseData.items![0].testName!
                                            .replaceAll('[', '')
                                            .replaceAll(']', '')
                                            .split(',')
                                            .map((e) => e.trim())
                                            .toList();

                                        List<String> rateList = caseData.items![0].testRate!
                                            .replaceAll('[', '')
                                            .replaceAll(']', '')
                                            .split(',')
                                            .map((e) => e.trim())
                                            .toList();

                                        GetPaymentHistory.GetHistory(
                                            receiptNo : caseData.slipNo!,
                                            receiptDate : caseData.date!,
                                            caseNo : caseData.caseNo!,
                                            caseDate : caseData.date!,
                                            patientName : caseData.patientName!,
                                            mobile : caseData.mobile!,
                                            sex: caseData.items![0].gender!,
                                            age : caseData.items![0].year!,
                                            referredBy : caseData.items![0].doctor!,
                                            testName : nameList,
                                            testRate : rateList,
                                            date :caseData.items![0].date!,
                                            totalAmount : caseData.items![0].totalAmount!,
                                            discountAmount : caseData.items![0].discount!,
                                            balanceAmount: caseData.items![0].balance!,
                                            advanceAmount : caseData.items![0].advance!,
                                            receivedBy : caseData.items![0].receivedBy!,
                                            context: context,
                                            status: "${caseData.balance! == "0" || caseData.balance! == ".00" || caseData.balance! == "0.00" ? "Paid" : "Due"}"

                                        );
                                      }, icon  : Icon(Icons.list,color: Colors.blue.shade600,))),
                                ],
                              ),)
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
                            ...caseData.items!.map((data){

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
                                        Center(child: UiHelper.CustText(text: "${paid.isEmpty || paid==".00" ? "0" : paid}",size: 12.sp)),
                                        Center(child: UiHelper.CustText(text: "${balance.isEmpty ? "0" : balance}",size: 12.sp)),

                                        Row(children: [
                                          const SizedBox(width: 10,),
                                          Tooltip(
                                            message : "Make Payment",
                                            child: IconButton(onPressed: (){

                                              String? status = GetCaseList.pay_status
                                                  .firstWhere((element) => element["case_no"] == data.caseNo,
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

                                        ],),
                                      ]
                                      )
                                    ]),
                              );
                            }),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            }

            return SizedBox();
          },
        ),
      ],
    );
  }

  static GetCaseMobile({required String date, required BuildContext context}) {
    context.read<CaseListCubit>().getCaseList(date: date, type: "All");

    TextEditingController searchCtrl = TextEditingController();
    ValueNotifier<String> searchQuery = ValueNotifier("");

    return Column(
      children: [
        /// 🔍 SEARCH BAR
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: TextField(
            controller: searchCtrl,
            decoration: InputDecoration(
              hintText: "Search by Case No / Patient Name / Mobile",
              hintStyle: TextStyle(fontSize: 16),
              prefixIcon: Icon(Icons.search, size: 24),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              suffixIcon: IconButton(
                onPressed: () {
                  searchCtrl.clear();
                  searchQuery.value = "";
                },
                icon: Icon(Icons.close, size: 24),
              ),
            ),
            onChanged: (val) {
              searchQuery.value = val.toLowerCase();
            },
          ),
        ),

        SizedBox(height: 5),

        BlocBuilder<CaseListCubit, CaseListState>(
          builder: (context, state) {
            if (state is CaseListLoadingState) {
              return Center(child: CircularProgressIndicator());
            }

            if (state is CaseListErrorState) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    state.errorMsg,
                    style: TextStyle(color: Colors.red, fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (state is CaseListLoadedState) {
              if (state.caseListModel.caseList!.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "No Cases Available",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                );
              }

              return ValueListenableBuilder<String>(
                valueListenable: searchQuery,
                builder: (context, query, _) {
                  final filteredList = state.caseListModel.caseList!.where((c) {
                    return c.caseNo!.toLowerCase().contains(query) ||
                        c.patientName!.toLowerCase().contains(query) ||
                        c.mobile!.toLowerCase().contains(query);
                  }).toList();

                  if (filteredList.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "No matching cases found",
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: filteredList.length,
                    itemBuilder: (_, index) {
                      final caseData = filteredList[index];

                      GetCaseList.pay_status.add({
                        "case_no": caseData.caseNo,
                        "status": caseData.balance == "0" ||
                            caseData.balance == ".00" ||
                            caseData.balance == "0.00"
                            ? "Paid"
                            : "Due"
                      });

                      return Container(
                        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: index % 2 == 0 ? Colors.grey.shade200 : Colors.white70,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: ExpansionTile(
                          tilePadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          childrenPadding: EdgeInsets.all(8),
                          title: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: MediaQuery.of(context).size.width - 32,
                              ),
                              child: Table(
                                columnWidths: {
                                  0: IntrinsicColumnWidth(),
                                  1: FlexColumnWidth(2),
                                  2: IntrinsicColumnWidth(),
                                  3: IntrinsicColumnWidth(),
                                  4: IntrinsicColumnWidth(),
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(4),
                                        child: UiHelper.CustText(
                                          text: "${caseData.caseNo!}",
                                          size: 14,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4),
                                        child: UiHelper.CustText(
                                          text: "${caseData.patientName!}",
                                          size: 14,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4),
                                        child: UiHelper.CustText(
                                          text: "₹${caseData.afterDiscount!}",
                                          size: 14,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Container(
                                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: caseData.balance! == "0" ||
                                                caseData.balance! == ".00" ||
                                                caseData.balance! == "0.00"
                                                ? Colors.green.shade100
                                                : Colors.orange.shade100,
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: UiHelper.CustText(
                                            text: caseData.balance! == "0" ||
                                                caseData.balance! == ".00" ||
                                                caseData.balance! == "0.00"
                                                ? "Paid"
                                                : "Due",
                                            size: 14,
                                          ),
                                        ),
                                      ),
                                      Tooltip(
                                        message: "Edit Case",
                                        child: IconButton(
                                          padding: EdgeInsets.all(4),
                                          constraints: BoxConstraints(),
                                          onPressed: () => Get.to(
                                            EditCaseEntry(case_no: caseData.caseNo!),
                                          ),
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.green,
                                            size: 24,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          children: [
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Column(
                                children: [
                                  // Header Table
                                  Table(
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    columnWidths: {
                                      0: FixedColumnWidth(100),
                                      1: FixedColumnWidth(110),
                                      2: FixedColumnWidth(110),
                                      3: FixedColumnWidth(90),
                                      4: FixedColumnWidth(90),
                                      5: FixedColumnWidth(90),
                                      6: FixedColumnWidth(140),
                                    },
                                    border: TableBorder.all(width: 0.5, color: Colors.black),
                                    children: [
                                      TableRow(
                                        children: [
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: UiHelper.CustText(
                                                text: "Slip No",
                                                size: 14,
                                                color: Colors.blue.shade700,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: UiHelper.CustText(
                                                text: "Pay Date",
                                                size: 14,
                                                color: Colors.blue.shade700,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: UiHelper.CustText(
                                                text: "Total",
                                                size: 14,
                                                color: Colors.blue.shade700,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: UiHelper.CustText(
                                                text: "Advance",
                                                size: 14,
                                                color: Colors.blue.shade700,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: UiHelper.CustText(
                                                text: "Paid",
                                                size: 14,
                                                color: Colors.blue.shade700,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: UiHelper.CustText(
                                                text: "Balance",
                                                size: 14,
                                                color: Colors.blue.shade700,
                                              ),
                                            ),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding: EdgeInsets.all(8),
                                              child: UiHelper.CustText(
                                                text: "Actions",
                                                size: 14,
                                                color: Colors.blue.shade700,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  // Data Rows
                                  ...caseData.items!.map((data) {
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
                                          0: FixedColumnWidth(100),
                                          1: FixedColumnWidth(110),
                                          2: FixedColumnWidth(110),
                                          3: FixedColumnWidth(90),
                                          4: FixedColumnWidth(90),
                                          5: FixedColumnWidth(90),
                                          6: FixedColumnWidth(140),
                                        },
                                        children: [
                                          TableRow(
                                            children: [
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: UiHelper.CustText(
                                                    text: "${data.slipNo}",
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: UiHelper.CustText(
                                                    text: "${data.date}",
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: UiHelper.CustText(
                                                    text: "${total.isEmpty ? "0" : total}",
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: UiHelper.CustText(
                                                    text: "${advance.isEmpty ? "0" : advance}",
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: UiHelper.CustText(
                                                    text: "${paid.isEmpty || paid == ".00" ? "0" : paid}",
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                              Center(
                                                child: Padding(
                                                  padding: EdgeInsets.all(8),
                                                  child: UiHelper.CustText(
                                                    text: "${balance.isEmpty ? "0" : balance}",
                                                    size: 14,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Tooltip(
                                                    message: "Make Payment",
                                                    child: IconButton(
                                                      padding: EdgeInsets.all(4),
                                                      constraints: BoxConstraints(),
                                                      onPressed: () {
                                                        String? status = GetCaseList.pay_status
                                                            .firstWhere(
                                                              (element) => element["case_no"] == data.caseNo,
                                                          orElse: () => {},
                                                        )["status"];

                                                        status == "Due"
                                                            ? showCaseDialog(
                                                          context: context,
                                                          case_no: data.caseNo!,
                                                          case_date: data.caseDate!,
                                                          case_time: data.time!,
                                                          patient_name: data.patientName!,
                                                          year: data.year!,
                                                          month: data.month!,
                                                          gender: data.gender!,
                                                          mobile: data.mobile!,
                                                          child_male: data.childMale!,
                                                          child_female: data.childFemale!,
                                                          address: data.address!,
                                                          agent: data.agent!,
                                                          doctor: data.doctor!,
                                                          test_name: data.testName!,
                                                          test_rate: data.testRate!,
                                                          total_amount: data.totalAmount!,
                                                          discount: data.discount!,
                                                          after_discount: data.afterDiscount!,
                                                          advance: advance,
                                                          balance: balance!,
                                                          discount_type: data.discountType!,
                                                          test_date: data.testDate!,
                                                          test_file: data.testFile!,
                                                          narration: data.narration!,
                                                          name_title: data.nameTitle!,
                                                        )
                                                            : UiHelper.showSuccessToste(
                                                          message: "Full Payment Already Paid",
                                                          heading: "Payment Already Paid",
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.add_box_rounded,
                                                        color: Colors.blue.shade600,
                                                        size: 24,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  Tooltip(
                                                    message: "Print Receipt",
                                                    child: IconButton(
                                                      padding: EdgeInsets.all(4),
                                                      constraints: BoxConstraints(),
                                                      onPressed: () {
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
                                                        PrintCaseEntry.printBill(
                                                          receiptNo: data.slipNo!,
                                                          receiptDate: data.date!,
                                                          caseNo: data.caseNo!,
                                                          caseDate: data.caseDate!,
                                                          caseTime: data.time!,
                                                          patientName: data.patientName!,
                                                          mobile: data.mobile!,
                                                          sex: data.gender!,
                                                          age: "${data.year} Y ${data.month != "0" ? data.month : ""}${data.month != "0" ? "M" : ""} ",
                                                          referredBy: data.doctor!,
                                                          testName: testName,
                                                          testRate: testRate,
                                                          date: data.date!,
                                                          totalAmount: total,
                                                          discountAmount: paid,
                                                          balanceAmount: data.balance!,
                                                          advanceAmount: data.advance!,
                                                          receivedBy: data.receivedBy!,
                                                          testDate: testDate,
                                                        );
                                                      },
                                                      icon: Icon(
                                                        Icons.print,
                                                        color: Colors.green.shade700,
                                                        size: 24,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              );
            }

            return SizedBox();
          },
        ),
      ],
    );
  }



  static void showCaseDialog({required BuildContext context,
    String? page,
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
    String receiptNo = "${data.nextInt(99999)}/${Constants.year}";

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
                  text: "PH : 9708035306, 9708046999   |   Email : cdc.dhn@gmail.com",
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

                  if(page == "case_entry"){
                    showDialog<bool>(
                      context: context,
                      barrierDismissible: false, // user must tap a button
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: UiHelper.CustText(text: "Success",size: 10.5.sp),
                          content: Text("Case Entry Successfully Done. Do You Print Receipt or Paid More Amount?"),
                          actions: <Widget>[
                            TextButton(
                              child: const Text("clear",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                              onPressed: (){
                                Navigator.popAndPushNamed(
                                    context,
                                    '/case_entry_page',arguments: {"code" : "/case_entry_page"});
                              },
                            ),
                            ElevatedButton(
                              child: const Text("Print"),
                              onPressed: () {
                                PrintCaseEntry.printBill(receiptNo: receiptNo,
                                    receiptDate: "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}",
                                    caseNo: case_no,
                                    caseDate: newDate,
                                    caseTime: newTime,
                                    patientName: patient_name,
                                    mobile: mobile,
                                    sex: gender,
                                    age: "${year} Y ${month} M",
                                    referredBy: doctor,
                                    testName: testName,
                                    testRate: testRate,
                                    date: case_date,
                                    totalAmount: after_discount,
                                    discountAmount: "${int.parse(advance) + int.parse(paidCtrl.text)}",
                                    balanceAmount: " ${int.parse(balance) - int.parse(paidCtrl.text)}",
                                    advanceAmount: "0",
                                    receivedBy: receivedBy,
                                    testDate: testDate
                                );
                              },
                            ),
                          ],
                        );
                      },
                    );
                  }



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

                  String adv =
                  balance == ".00" || balance == "0" || balance.isEmpty
                      ? advance
                      : "${(int.tryParse(advance) ?? 0) + (int.tryParse(paidCtrl.text) ?? 0)}";



                  CaseEntryCtrl.CaseEntry(type : "Repayment",context : context,case_date: case_date, time: newTime, date: newDate, case_no: case_no, slip_no: receiptNo, received_by: receivedBy, patient_name: patient_name, year: year, month: month, gender: gender, mobile: mobile, child_male: child_male, child_female: child_female, address: address, agent: agent, doctor: doctor, test_name: test_name, test_rate: test_rate, total_amount: total_amount, discount: discount, after_discount: after_discount, advance: adv, balance: "${double.parse(balance) - double.parse(paidCtrl.text)}",paid_amount: paidCtrl.text,pay_status: pay_status, pay_mode: PayMode, discount_type: discount_type,test_date: test_date,test_file: test_file,narration: narration,name_title: name_title);


                }, child: UiHelper.CustText(text: "Pay Now",fontfamily: 'font-bold',size: 12.sp,color: Colors.green),);
              },
            ),
            TextButton(
              onPressed: () =>Navigator.pushReplacementNamed(context, '/case_entry_list',arguments: {"code" : "/case_entry_list"}),
              child: UiHelper.CustText(text: "Close",fontfamily: 'font-bold',size: 12.sp,color: Colors.red),
            ),

          ],
        );
      },
    );
  }

}