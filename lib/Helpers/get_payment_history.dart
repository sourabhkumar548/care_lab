import 'package:care_lab_software/Controllers/PaymentHistoryCtrl/cubit/payment_history_cubit.dart';
import 'package:care_lab_software/Helpers/print_case_entry.dart';
import 'package:care_lab_software/Helpers/uiHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class GetPaymentHistory{

  static GetHistory({required BuildContext context, required String Case_no,required String name,required String case_date,required String total,required String status,required String balance}){

    context.read<PaymentHistoryCubit>().GetHistory(case_no: Case_no);

    showModalBottomSheet(context: context, builder: (_){
      return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 30,left: 10,right: 10),
          child: BlocBuilder<PaymentHistoryCubit, PaymentHistoryState>(
            builder: (context, state) {
              if(state is PaymentHistoryLoadingState){
                return Center(child: CircularProgressIndicator());
              }
              if(state is PaymentHistoryErrorState){
                return Center(child: UiHelper.CustText(text: state.errorMsg));
              }
              if(state is PaymentHistoryLoadedState){
                return Column(
                  children: [
                    Row(
                      children: [
                        UiHelper.CustText(text: "Payment History",size: 12.sp,color: Colors.blue.shade700,),
                      ],
                    ),
                    const SizedBox(height: 20,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      UiHelper.CustText(text: "Patient Name : ${name}"),
                      UiHelper.CustText(text: "Case Date : ${case_date}"),
                    ],),
                    const SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                      UiHelper.CustText(text: "Case No : ${Case_no}"),
                      UiHelper.CustText(text: "Total Amt : ${total}"),
                      UiHelper.CustText(text: "Bal Amt : ${balance}"),
                      UiHelper.CustText(text: "Pay Status : ${status}"),
                    ],),
        
                    const SizedBox(height: 20,),
        
              Container(
                child: Table(
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
                            Center(child: UiHelper.CustText(text: "Slip No",size: 10.sp,color: Colors.blue.shade700)),
                            Center(child: UiHelper.CustText(text: "Pay Date",size: 10.sp,color: Colors.blue.shade700)),
                            Center(child: UiHelper.CustText(text: "Total Amt",size: 10.sp,color: Colors.blue.shade700)),
                            Center(child: UiHelper.CustText(text: "Advance",size: 10.sp,color: Colors.blue.shade700)),
                            Center(child: UiHelper.CustText(text: "Balance",size: 10.sp,color: Colors.blue.shade700)),
                            Center(child: UiHelper.CustText(text: "Paid",size: 10.sp,color: Colors.blue.shade700)),
                            Center(child: UiHelper.CustText(text: "Actions",size: 10.sp,color: Colors.blue.shade700)),
                        ]
                        )
                    ],
                ),
              ),
        
                    ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (_,index){
        
                      var data = state.paymentHistoryModel.caseList![index];
        
                      String total = data.afterDiscount!.replaceFirst(RegExp(r"^0"), "");
                      String balance = data.balance!.replaceFirst(RegExp(r"^0"), "");
                      String advance = data.advance!.replaceFirst(RegExp(r"^0"), "");
                      String paid = data.paidAmount!.replaceFirst(RegExp(r"^0"), "");
        
                      return Table(
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
                                Center(child: UiHelper.CustText(text: "${data.slipNo}",size: 10.sp)),
                                Center(child: UiHelper.CustText(text: "${data.date}",size: 10.sp)),
                                Center(child: UiHelper.CustText(text: "${total.isEmpty ? "0" : total}",size: 10.sp)),
                                Center(child: UiHelper.CustText(text: "${advance.isEmpty ? "0" : advance}",size: 10.sp)),
                                Center(child: UiHelper.CustText(text: "${balance.isEmpty ? "0" : balance}",size: 10.sp)),
                                Center(child: UiHelper.CustText(text: "${paid.isEmpty ? "0" : paid}",size: 10.sp)),
                                Row(children: [
                                  Tooltip(
                                    message : "Print Receipt",
                                    child: IconButton(onPressed: (){
                                      List<String> testName = data.testName!.split(",");
                                      List<String> testRate = data.testRate!.split(",");
                                      List<String> testDate = data.testDate!.split(",");
                                      PrintCaseEntry.printBill(receiptNo: data.slipNo!, receiptDate: data.date!, caseNo: data.caseNo!, caseDate: data.caseDate!, caseTime: data.time!, patientName: data.patientName!, mobile: data.mobile!, sex: data.gender!, age: "${data.year} Y ${data.month} M", referredBy: data.doctor!, testName: testName, testRate: testRate, date: data.date!, totalAmount: total, discountAmount: paid, balanceAmount: data.balance!, advanceAmount: data.advance!, receivedBy: data.receivedBy!,testDate: testDate);
                                    }, icon: Icon(Icons.print,color: Colors.green.shade700,),),
                                  ),
                                  const SizedBox(width: 10,),
                                  Tooltip(
                                      message: "View Details",
                                      child: IconButton(onPressed: (){}, icon: Icon(Icons.list_alt,color: Colors.red.shade700,),))
                                ],),
                              ]
                          )
                        ],
                      );
        
                    },itemCount: state.paymentHistoryModel.caseList!.length,),

                    const SizedBox(height: 40,)

                  ],
                );
              }
              return Container();
            },
          ),
        ),
      );
    });

  }

}