import 'package:care_lab_software/Controllers/PaymentHistoryCtrl/cubit/payment_history_cubit.dart';
import 'package:care_lab_software/Helpers/print_case_entry.dart';
import 'package:care_lab_software/Helpers/uiHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class GetPaymentHistory {
  static GetHistory({
    required String receiptNo,
    required String receiptDate,
    required String caseNo,
    required String caseDate,
    required String patientName,
    required String mobile,
    required String sex,
    required String age,
    required String referredBy,
    required List<String> testName,
    required List<String> testRate,
    required String date,
    required String totalAmount,
    required String discountAmount,
    required String balanceAmount,
    required String advanceAmount,
    required String receivedBy,
    required BuildContext context,
    required String status,
  }) {
    context.read<PaymentHistoryCubit>().GetHistory(case_no: caseNo);

    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(top: 30, left: 10, right: 10),
            child: BlocBuilder<PaymentHistoryCubit, PaymentHistoryState>(
              builder: (context, state) {
                if (state is PaymentHistoryLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is PaymentHistoryErrorState) {
                  return Center(child: UiHelper.CustText(text: state.errorMsg));
                }
                if (state is PaymentHistoryLoadedState) {
                  return Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          UiHelper.CustText(
                            text: "Payment History",
                            size: 12.sp,
                            color: Colors.blue.shade700,
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UiHelper.CustText(text: "Case No : $caseNo"),
                          UiHelper.CustText(text: "Case Date : $caseDate"),
                          UiHelper.CustText(text: "Age : $age Y"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UiHelper.CustText(
                            text: "Patient Name : $patientName",
                          ),
                          UiHelper.CustText(text: "Sex : $sex"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          UiHelper.CustText(text: "Referred By : $referredBy"),
                          UiHelper.CustText(text: "Mobile : ${mobile == "0" ? "Not Mention" : mobile}"),
                        ],
                      ),

                      const SizedBox(height: 20),

                      Table(
                        columnWidths: {
                          0: FlexColumnWidth(.5),
                          1: FlexColumnWidth(3),
                          2: FlexColumnWidth(.8),
                        },
                        border: TableBorder.all(
                          width: 0.5,
                          color: Colors.black,
                        ),
                        children: List.generate(testName.length, (index) {
                          return TableRow(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: UiHelper.CustText(
                                  text: "${index+1}",
                                  size: 10.sp,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: UiHelper.CustText(
                                  text: testName[index],
                                  size: 10.sp,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: UiHelper.CustText(
                                  text: testRate[index].toString(),
                                  size: 10.sp,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      Container(
                        child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          columnWidths: {
                            0: FlexColumnWidth(.8),
                            1: FlexColumnWidth(.8),
                            2: FlexColumnWidth(.8),
                            3: FlexColumnWidth(.6),
                            4: FlexColumnWidth(.6),
                            5: FlexColumnWidth(.8),
                          },
                          border: TableBorder.all(
                            width: 0.5,
                            color: Colors.black,
                          ),
                          children: [
                            TableRow(
                              children: [
                                Center(
                                  child: UiHelper.CustText(
                                    text: "Slip No",
                                    size: 10.sp,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                Center(
                                  child: UiHelper.CustText(
                                    text: "Pay Date",
                                    size: 10.sp,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                Center(
                                  child: UiHelper.CustText(
                                    text: "Total Amt",
                                    size: 10.sp,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                // Center(
                                //   child: UiHelper.CustText(
                                //     text: "Advance",
                                //     size: 10.sp,
                                //     color: Colors.blue.shade700,
                                //   ),
                                // ),
                                Center(
                                  child: UiHelper.CustText(
                                    text: "Paid",
                                    size: 10.sp,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                                Center(
                                  child: UiHelper.CustText(
                                    text: "Balance",
                                    size: 10.sp,
                                    color: Colors.blue.shade700,
                                  ),
                                ),

                                Center(
                                  child: UiHelper.CustText(
                                    text: "Actions",
                                    size: 10.sp,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      ListView.builder(
                        shrinkWrap: true,
                        itemBuilder: (_, index) {
                          var data = state.paymentHistoryModel.caseList![index];

                          String total = data.afterDiscount!.replaceFirst(
                            RegExp(r"^0"),
                            "",
                          );
                          String balance = data.balance!.replaceFirst(
                            RegExp(r"^0"),
                            "",
                          );
                          String advance = data.advance!.replaceFirst(
                            RegExp(r"^0"),
                            "",
                          );
                          String paid = data.paidAmount!.replaceFirst(
                            RegExp(r"^0"),
                            "",
                          );

                          return Table(
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            columnWidths: {
                              0: FlexColumnWidth(.8),
                              1: FlexColumnWidth(.8),
                              2: FlexColumnWidth(.8),
                              3: FlexColumnWidth(.6),
                              4: FlexColumnWidth(.6),
                              5: FlexColumnWidth(.8),
                            },
                            border: TableBorder.all(
                              width: 0.5,
                              color: Colors.black,
                            ),
                            children: [
                              TableRow(
                                children: [
                                  Center(
                                    child: UiHelper.CustText(
                                      text: "${data.slipNo}",
                                      size: 10.sp,
                                    ),
                                  ),
                                  Center(
                                    child: UiHelper.CustText(
                                      text: "${data.date}",
                                      size: 10.sp,
                                    ),
                                  ),
                                  Center(
                                    child: UiHelper.CustText(
                                      text: "${total.isEmpty ? "0" : total}",
                                      size: 10.sp,
                                    ),
                                  ),
                                  // Center(
                                  //   child: UiHelper.CustText(
                                  //     text:
                                  //         "${advance.isEmpty ? "0" : advance}",
                                  //     size: 10.sp,
                                  //   ),
                                  // ),
                                  Center(
                                    child: UiHelper.CustText(
                                      text: "${paid.isEmpty || paid == ".00" ? "0" : paid}",
                                      size: 10.sp,
                                    ),
                                  ),
                                  Center(
                                    child: UiHelper.CustText(
                                      text:
                                          "${balance.isEmpty || balance == ".00" ? "0" : balance}",
                                      size: 10.sp,
                                    ),
                                  ),

                                  Row(
                                    children: [
                                      Tooltip(
                                        message: "Print Receipt",
                                        child: IconButton(
                                          onPressed: () {
                                            List<String> testName = data
                                                .testName!
                                                .split(",");
                                            List<String> testRate = data
                                                .testRate!
                                                .split(",");
                                            List<String> testDate = data
                                                .testDate!
                                                .split(",");
                                            PrintCaseEntry.printBill(
                                              receiptNo: data.slipNo!,
                                              receiptDate: data.date!,
                                              caseNo: data.caseNo!,
                                              caseDate: data.caseDate!,
                                              caseTime: data.time!,
                                              patientName: data.patientName!,
                                              mobile: data.mobile!,
                                              sex: data.gender!,
                                              age:
                                                  "${data.year} Y ${data.month != "0" ? data.month : ""}${data.month != "0" ? "M" : ""} ",
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
                                          icon: Center(
                                            child: Icon(
                                              Icons.print,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),

                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                        itemCount: state.paymentHistoryModel.caseList!.length,
                      ),

                      const SizedBox(height: 40),
                    ],
                  );
                }
                return Container();
              },
            ),
          ),
        );
      },
    );
  }
}
