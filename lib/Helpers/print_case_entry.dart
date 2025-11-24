import 'package:care_lab_software/Helpers/number_to_words.dart';
import 'package:care_lab_software/Helpers/uiHelper.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:sizer/sizer.dart';

class PrintCaseEntry {
  static Future<void> printBill({
    required String receiptNo,
    required String receiptDate,
    required String caseNo,
    required String caseDate,
    required String caseTime,
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
    required List<String> testDate,
  }) async {
    final doc = pw.Document();

    int mainAmount = 0;


    // max tests per page
    const int testsPerPage = 8;

    // split tests into chunks of 8
    List<List<Map<String, String>>> chunks = [];
    for (var i = 0; i < testName.length; i += testsPerPage) {
      final subList = List.generate(

        (i + testsPerPage > testName.length
            ? testName.length - i
            : testsPerPage),
            (j) {
          final idx = i + j;
          mainAmount += int.parse(testRate[idx].replaceAll('[', "").replaceAll("]", ""));
          return {
            "sn": (idx + 1).toString(),
            "name": testName[idx].replaceAll('[', "").replaceAll("]", ""),
            "date": GenerateDate(dateCount: int.parse(testDate[idx].replaceAll('[', "").replaceAll("]", "")),casedate: caseDate),
            "amt": (idx < testRate.length)
                ? "${testRate[idx].replaceAll('[', "").replaceAll("]", "")}.00"
                : "0.00",
          };
        },
      );
      chunks.add(subList);
    }

    for (int pageIndex = 0; pageIndex < chunks.length; pageIndex++) {
      final isFirstPage = pageIndex == 0;
      final isLastPage = pageIndex == chunks.length - 1;
      final data = chunks[pageIndex];

      // 🔹 Subtotal calculation for this page
      double pageSubtotal = 0;
      for (var row in data) {
        pageSubtotal += double.tryParse(row["amt"]!.replaceAll(".00", "")) ?? 0;
      }

      doc.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          clip: true,
          margin: pw.EdgeInsets.only(top: 12,bottom: 12,left: 18,right: 18),
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // 🔹 HEADER (only on first page)
                ...[
                  UiHelper.PWcustomTextWithRow(
                    text: "CARE DIAGNOSTIC CENTRE",
                    mainaxisalignment: pw.MainAxisAlignment.center,
                    size: 13.sp,
                    fontfamily: 'font-bold',
                      fontweight: pw.FontWeight.bold
                  ),
                  pw.SizedBox(height: .5.h),
                  UiHelper.PWcustomTextWithRow(
                    text: "NAYA BAZAR, NEAR GAYA PUL, DHANBAD - 826001",
                    mainaxisalignment: pw.MainAxisAlignment.center,
                    size: 10.sp,
                    maxline: 1,
                    fontweight: pw.FontWeight.bold
                  ),
                  pw.SizedBox(height: .5.h),
                  UiHelper.PWcustomTextWithRow(
                    text: "PH : 0326-2254788   |   Email : cdc.dhn@gmail.com",
                    mainaxisalignment: pw.MainAxisAlignment.center,
                    size: 10.sp,
                    maxline: 1,
                    fontweight: pw.FontWeight.bold
                  ),
                  pw.SizedBox(height: 1.h),

                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text("Receipt No : $receiptNo",
                          style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold)),
                      pw.Center(
                          child: UiHelper.PWcustomText(text: "MONEY RECEIPT")),
                      pw.Text(
                          "Receipt Date : ${"${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}"}",
                          style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold)),
                    ],
                  ),

                  pw.SizedBox(height: .5.h),
                  pw.Divider(color: PdfColors.grey, height: 1),
                  pw.SizedBox(height: .5.h),
                ],
                if (isFirstPage) ...[
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Case No : $caseNo",
                            style: pw.TextStyle(fontSize: 9.5.sp)),
                        pw.Text("Case Date : $caseDate",
                            style: pw.TextStyle(fontSize: 9.5.sp)),
                        pw.Text("Age : $age",
                            style: pw.TextStyle(fontSize: 9.5.sp)),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 10),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Text("Patient Name : $patientName",
                            style: pw.TextStyle(fontSize: 9.5.sp)),
                        pw.Text("Sex : $sex",
                            style: pw.TextStyle(fontSize: 9.5.sp)),
                      ],
                    ),
                  ),
                  pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(
                        horizontal: 10, vertical: 3),
                    child: pw.Row(
                      children: [
                        pw.Text("Referred By : $referredBy",
                            style: pw.TextStyle(fontSize: 9.5.sp)),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 5),
                ],

                // 🔹 TEST TABLE
                pw.Table.fromTextArray(
                  headers: ['SN', 'Test Name', 'Report Date', 'Amount'],
                  data: data
                      .map((e) => [
                        pw.Text(e["sn"]!, style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 9.5.sp),maxLines: 1),
                        pw.Text(e["name"]!, style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 9.5.sp),maxLines: 1),
                        pw.Text(e["date"]!, style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 9.5.sp),maxLines: 1),
                        pw.Text(e["amt"]!, style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 9.5.sp),maxLines: 1),
                      ])
                      .toList(),
                  headerStyle: pw.TextStyle(fontSize: 9.5.sp, fontWeight: pw.FontWeight.bold),
                  cellStyle: pw.TextStyle(fontSize: 9.5.sp),
                  columnWidths: {
                    0: pw.FlexColumnWidth(0.6),
                    1: pw.FlexColumnWidth(6),
                    2: pw.FlexColumnWidth(2),
                    3: pw.FlexColumnWidth(1.5),
                  },
                  border: pw.TableBorder.all(width: 0.2, color: PdfColors.black),
                ),

                pw.SizedBox(height: 6),

                // 🔹 SUBTOTAL (every page)
                !isLastPage ? pw.Align(
                  alignment: pw.Alignment.centerRight,
                  child: pw.Text("Subtotal : ${pageSubtotal.toStringAsFixed(2)}",
                      style: pw.TextStyle(
                          fontSize: 9.5.sp, fontWeight: pw.FontWeight.bold)),
                ) : pw.Container(),

                // 🔹 TOTALS (only on last page)
                if (isLastPage) ...[
                  pw.Column(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [

                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                        pw.Text(
                            "Total Amount : ",
                            style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold)),
                        pw.Text(
                            "${mainAmount}.00",
                            style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold)),
                      ]),

                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                        pw.Text(
                            "Discount Amount : ",
                            style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold)),
                        pw.Text(
                            "${mainAmount - int.parse(totalAmount)}.00",
                            style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold)),
                      ]),

                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                                "Total Paid Amount : ",
                                style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold)),
                            pw.Text(
                                "${totalAmount}.00",
                                style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold)),
                      ]),

                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                                "Paid Amount : ",
                                style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold)),
                            pw.Text(
                                "${discountAmount}.00",
                                style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold)),
                          ]),

                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                          children: [
                            pw.Text(
                                "Received By : $receivedBy",
                                style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold)),

                            balanceAmount == ".00" ||
                                balanceAmount == "0"
                            ?  pw.Text("Full & Final Payment Received",
                                style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold))
                            : pw.Text(
                                "Balance Amount : ${balanceAmount}.00",
                                style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold)),
                          ]),
                      pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          children: [
                            pw.Text(
                                "${numberToWords(double.parse(discountAmount).toInt())} Only",
                                style: pw.TextStyle(fontSize: 9.5.sp,fontWeight: pw.FontWeight.bold)),
                          ]),

                    ],
                  ),
                ]
              ],
            );
          },
        ),
      );
    }

    await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => doc.save());
  }

  static String GenerateDate({required int dateCount,required String casedate}){

    var d = casedate.split("-");

    DateTime today = DateTime(int.parse(d[2]), int.parse(d[1]), int.parse(d[0]));
    int daysToAdd = dateCount;

    DateTime newDate = today.add(Duration(days: daysToAdd));
    String formattedDate = DateFormat("dd-MM-yyyy").format(newDate);
    return formattedDate;
  }

}
