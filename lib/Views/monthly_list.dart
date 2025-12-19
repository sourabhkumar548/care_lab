import 'dart:convert';

import 'package:care_lab_software/Controllers/AgentCollectionCtrl/agent_collection_cubit.dart';
import 'package:care_lab_software/Helpers/uiHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:excel/excel.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:sizer/sizer.dart';

class SaleReport extends StatelessWidget {
  String fromDate;
  String toDate;
  String agentName;

  SaleReport({
    super.key,
    required this.fromDate,
    required this.toDate,
    required this.agentName,
  });

  @override
  Widget build(BuildContext context) {
    context.read<AgentCollectionCubit>().getAgentCollection(
      fromdate: fromDate,
      todate: toDate,
      agent: agentName,
    );

    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: AppBar(
        title: Text('Agent Wise Sale Report ( From :   $fromDate   To :   $toDate )',style: TextStyle(fontWeight: FontWeight.bold),),
        actions: [

          IconButton(
            icon: Icon(Icons.table_chart),
            tooltip: 'Export to Excel',
            onPressed: () => _exportToExcel(context),
          ),
          IconButton(
            icon: Icon(Icons.print),
            tooltip: 'Print PDF',
            onPressed: () => _printReport(context),
          ),
        ],
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(24),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                /// ---------- AGENT NAME ----------
                Center(
                  child: Text(
                    "Agent Name : $agentName",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14.sp,color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 12),

                /// ---------- TABLE ----------
                BlocBuilder<AgentCollectionCubit, AgentCollectionState>(
                  builder: (context, state) {
                    if (state is AgentCollectionLoadingState) {
                      return Center(child: CircularProgressIndicator());
                    }
                    if (state is AgentCollectionErrorState) {
                      return Center(
                        child: UiHelper.CustText(
                          text: state.errorMsg,
                          color: Colors.red,
                        ),
                      );
                    }
                    if (state is AgentCollectionLoadedState) {
                      return Column(
                        children: [
                          _buildTable(state),

                          Table(
                            border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                            columnWidths: const {
                              0: FlexColumnWidth(1.0), // Case No
                              1: FlexColumnWidth(1.2), // Case Date
                              2: FlexColumnWidth(2.0), // Patient Name
                              3: FlexColumnWidth(3.5), // Test Name
                              4: FlexColumnWidth(1.5), // Total Amount
                              5: FlexColumnWidth(1.5), // Discount
                              6: FlexColumnWidth(1.5), // Net Payable
                              7: FlexColumnWidth(1.5), // Paid
                              8: FlexColumnWidth(1.5), // Due
                            },
                            children: [
                              TableRow(
                                decoration: BoxDecoration(color: Colors.blue.shade100),
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 10),
                                    child: UiHelper.CustText(text: ""),
                                  ),
                                  UiHelper.CustText(text: ""),
                                  UiHelper.CustText(text: ""),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5,top: 5),
                                    child: Text("GRAND TOTAL : ",style: TextStyle(color: Colors.black,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5,top: 5),
                                    child: Text("Total : ${state.saleModel.totals!.totalAmount.toString()}",style: TextStyle(color: Colors.black,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5,top: 5),
                                    child: Text("Discount : ${state.saleModel.totals!.totalDiscount.toString()}",style: TextStyle(color: Colors.black,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5,top: 5),
                                    child: Text("Payable : ${state.saleModel.totals!.totalAfterDiscount.toString()}",style: TextStyle(color: Colors.black,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5,top: 5),
                                    child: Text("Paid : ${state.saleModel.totals!.totalPaid.toString()}",style: TextStyle(color: Colors.black,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 5,top: 5),
                                    child: Text("Due : ${state.saleModel.totals!.totalDue.toString()}",style: TextStyle(color: Colors.black,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.right,),
                                  )
                                ],
                              ),
                            ],
                          ),

                        ],
                      );
                    }
                    return Container();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTable(AgentCollectionLoadedState state) {
    // Safely handle data list
    final dataList = state.saleModel.data ?? [];

    return Table(
      border: TableBorder.all(color: Colors.grey.shade400, width: 1),
      columnWidths: const {
        0: FlexColumnWidth(1.0), // Case No
        1: FlexColumnWidth(1.2), // Case Date
        2: FlexColumnWidth(2.0), // Patient Name
        3: FlexColumnWidth(3.5), // Test Name
        4: FlexColumnWidth(1.5), // Total Amount
        5: FlexColumnWidth(1.5), // Discount
        6: FlexColumnWidth(1.5), // Net Payable
        7: FlexColumnWidth(1.5), // Paid
        8: FlexColumnWidth(1.5), // Due
      },
      children: [
        // Header Row
        TableRow(
          decoration: BoxDecoration(color: Colors.grey.shade200),
          children: [
            _tableCell("Case No", isHeader: true),
            _tableCell("Case Date", isHeader: true),
            _tableCell("Patient Name", isHeader: true),
            _tableCell("Test Name", isHeader: true),
            _tableCell("Total Amount", isHeader: true),
            _tableCell("Discount", isHeader: true),
            _tableCell("Net Payable", isHeader: true),
            _tableCell("Paid", isHeader: true),
            _tableCell("Due", isHeader: true),
          ],
        ),
        // Data Rows
        ...dataList.map((data) {

          return TableRow(
            decoration: BoxDecoration(color: double.parse(data.balance!) > 0  ? Colors.red.shade50 : Colors.white),
            children: [
              _tableCell(data.caseNo?.toString() ?? ''),
              _tableCell(data.caseDate?.toString() ?? ''),
              _tableCell(data.patientName?.toString() ?? ''),
              _tableCell("* ${data.testName?.toString()}".replaceAll(",", "\n*").replaceAll("[", "").replaceAll("]", "") ?? ''),
              _tableCell(data.totalAmount?.toString() ?? '', align: TextAlign.right),
              _tableCell(data.discount?.toString() ?? '', align: TextAlign.right),
              _tableCell(data.afterDiscount?.toString() ?? '', align: TextAlign.right),
              _tableCell(data.paidAmount?.toString() ?? '', align: TextAlign.right),
              _tableCell(data.balance?.toString() ?? '', align: TextAlign.right),
            ],
          );
        }).toList(),
      ],
    );
  }

  Widget _tableCell(String text,
      {bool isHeader = false, TextAlign align = TextAlign.left}) {
    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Text(
        text,
        textAlign: align,
        style: TextStyle(
          fontSize: isHeader ? 16 : 14,
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  // Helper method to build PDF header
  pw.Widget _buildPdfHeader() {
    return pw.Column(
      children: [
        pw.Text(
          "CARE DIAGNOSTIC CENTRE",
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 4),
        pw.Text(
          "Naya Bazar, Near Gaya Pool, Dhanbad - 826001",
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.Text(
          "PH : 9708035306,9708046999",
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 12),
        pw.Text(
          "AGENT WISE SALE REPORT (DETAIL)",
          style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold),
        ),
        pw.SizedBox(height: 6),
        pw.Text(
          "From : $fromDate To : $toDate",
          style: pw.TextStyle(fontSize: 12),
        ),
        pw.SizedBox(height: 12),
        pw.Align(
          alignment: pw.Alignment.centerLeft,
          child: pw.Text(
            "Agent Name : $agentName",
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 13),
          ),
        ),
        pw.SizedBox(height: 12),
      ],
    );
  }
  
  Future<void> _printReport(BuildContext context) async {
    final state = context.read<AgentCollectionCubit>().state;
    if (state is! AgentCollectionLoadedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No data available to print')),
      );
      return;
    }

    try {
      // Prepare data for the table
      final tableHeaders = [
        'Case No',
        'Case Date',
        'Patient Name',
        'Test Name',
        'Total Amount',
        'Discount',
        'Net Payable',
        'Paid',
        'Due'
      ];

      // Safely convert data to List
      final dataList = state.saleModel.data ?? [];

      final tableData = <List<String>>[];
      for (var data in dataList) {
        tableData.add([
          data.caseNo?.toString() ?? '',
          data.caseDate?.toString() ?? '',
          data.patientName?.toString() ?? '',
          data.testName?.toString() ?? '',
          data.totalAmount?.toString() ?? '',
          data.discount?.toString() ?? '',
          data.afterDiscount?.toString() ?? '',
          data.paidAmount?.toString() ?? '',
          data.balance?.toString() ?? '',
        ]);
      }

      // Get grand totals from state
      final grandTotal = state.saleModel.totals;

      // Use Printing.layoutPdf with proper async callback
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          final pdf = pw.Document();

          // Add pages with MultiPage widget for automatic pagination
          pdf.addPage(
            pw.MultiPage(
              pageFormat: PdfPageFormat.a4.landscape,
              margin: pw.EdgeInsets.all(20),
              build: (pw.Context context) {
                return [
                  _buildPdfHeader(),
                  pw.Table.fromTextArray(
                    headers: tableHeaders,
                    data: tableData,
                    headerStyle: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 10,
                    ),
                    cellStyle: pw.TextStyle(fontSize: 9),
                    headerDecoration: pw.BoxDecoration(
                      color: PdfColors.grey300,
                    ),
                    cellHeight: 20,
                    // Increased column widths for amount columns
                    columnWidths: {
                      0: pw.FlexColumnWidth(1.0),   // Case No
                      1: pw.FlexColumnWidth(1.5),   // Case Date
                      2: pw.FlexColumnWidth(2.5),   // Patient Name
                      3: pw.FlexColumnWidth(3.0),   // Test Name
                      4: pw.FlexColumnWidth(1.5),   // Total Amount - INCREASED
                      5: pw.FlexColumnWidth(1.3),   // Discount - INCREASED
                      6: pw.FlexColumnWidth(1.5),   // Net Payable - INCREASED
                      7: pw.FlexColumnWidth(1.3),   // Paid - INCREASED
                      8: pw.FlexColumnWidth(1.3),   // Due - INCREASED
                    },
                    cellAlignments: {
                      0: pw.Alignment.centerLeft,
                      1: pw.Alignment.centerLeft,
                      2: pw.Alignment.centerLeft,
                      3: pw.Alignment.centerLeft,
                      4: pw.Alignment.centerRight,
                      5: pw.Alignment.centerRight,
                      6: pw.Alignment.centerRight,
                      7: pw.Alignment.centerRight,
                      8: pw.Alignment.centerRight,
                    },
                    headerAlignments: {
                      0: pw.Alignment.centerLeft,
                      1: pw.Alignment.centerLeft,
                      2: pw.Alignment.centerLeft,
                      3: pw.Alignment.centerLeft,
                      4: pw.Alignment.centerRight,
                      5: pw.Alignment.centerRight,
                      6: pw.Alignment.centerRight,
                      7: pw.Alignment.centerRight,
                      8: pw.Alignment.centerRight,
                    },
                  ),
                  // Add Grand Total Row
                  pw.SizedBox(height: 10),
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey400, width: 1),
                      color: PdfColors.blue100,
                    ),
                    child: pw.Row(
                      children: [
                        pw.Expanded(flex: 4, child: pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Text('GRAND TOTAL',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                            textAlign: pw.TextAlign.right,
                          ),
                        )),
                        pw.Expanded(flex: 3, child: pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          decoration: pw.BoxDecoration(
                            border: pw.Border(left: pw.BorderSide(color: PdfColors.grey400)),
                          ),
                          child: pw.Text("Total : ${grandTotal?.totalAmount?.toString()}" ?? '0',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                            textAlign: pw.TextAlign.right,
                          ),
                        )),
                        pw.Expanded(flex: 3, child: pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          decoration: pw.BoxDecoration(
                            border: pw.Border(left: pw.BorderSide(color: PdfColors.grey400)),
                          ),
                          child: pw.Text("Discount : ${grandTotal?.totalDiscount?.toString()}" ?? '0',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                            textAlign: pw.TextAlign.right,
                          ),
                        )),
                        pw.Expanded(flex: 3, child: pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          decoration: pw.BoxDecoration(
                            border: pw.Border(left: pw.BorderSide(color: PdfColors.grey400)),
                          ),
                          child: pw.Text("Payable : ${grandTotal?.totalAfterDiscount?.toString()}" ?? '0',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                            textAlign: pw.TextAlign.right,
                          ),
                        )),
                        pw.Expanded(flex: 3, child: pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          decoration: pw.BoxDecoration(
                            border: pw.Border(left: pw.BorderSide(color: PdfColors.grey400)),
                          ),
                          child: pw.Text("Paid : ${grandTotal?.totalPaid?.toString()}" ?? '0',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                            textAlign: pw.TextAlign.right,
                          ),
                        )),
                        pw.Expanded(flex: 3, child: pw.Container(
                          padding: pw.EdgeInsets.all(8),
                          decoration: pw.BoxDecoration(
                            border: pw.Border(left: pw.BorderSide(color: PdfColors.grey400)),
                          ),
                          child: pw.Text("Due : ${grandTotal?.totalDue?.toString()}" ?? '0',
                            style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
                            textAlign: pw.TextAlign.right,
                          ),
                        )),
                      ],
                    ),
                  ),
                ];
              },
              header: (pw.Context context) {
                // Show header on subsequent pages
                if (context.pageNumber > 1) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        "CARE DIAGNOSTIC CENTRE - Sale Report (Continued)",
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold),
                      ),
                      pw.Text(
                        "Agent: $agentName | Period: $fromDate - $toDate",
                        style: pw.TextStyle(fontSize: 10),
                      ),
                      pw.SizedBox(height: 10),
                      pw.Divider(),
                    ],
                  );
                }
                return pw.SizedBox();
              },
              footer: (pw.Context context) {
                return pw.Container(
                  alignment: pw.Alignment.centerRight,
                  margin: const pw.EdgeInsets.only(top: 10),
                  child: pw.Text(
                    'Page ${context.pageNumber} of ${context.pagesCount}',
                    style: pw.TextStyle(fontSize: 10),
                  ),
                );
              },
            ),
          );

          // Return the PDF bytes
          return pdf.save();
        },
      );

    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error generating PDF: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print('Print Error: $e');
    }
  }

  Future<void> _exportToExcel(BuildContext context) async {
    final state = context.read<AgentCollectionCubit>().state;
    if (state is! AgentCollectionLoadedState) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No data to export')),
      );
      return;
    }

    try {
      // Safely handle data list
      final dataList = state.saleModel.data ?? [];

      if (dataList.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No data available to export')),
        );
        return;
      }

      // Create Excel file
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sale Report'];

      // Add Header Information
      sheetObject.merge(
          CellIndex.indexByString('A1'), CellIndex.indexByString('I1'));
      var headerCell = sheetObject.cell(CellIndex.indexByString('A1'));
      headerCell.value = TextCellValue('CARE DIAGNOSTIC CENTRE');
      headerCell.cellStyle = CellStyle(
        bold: true,
        fontSize: 16,
        horizontalAlign: HorizontalAlign.Center,
      );

      sheetObject.merge(
          CellIndex.indexByString('A2'), CellIndex.indexByString('I2'));
      var addressCell = sheetObject.cell(CellIndex.indexByString('A2'));
      addressCell.value =
          TextCellValue('Naya Bazar, Near Gaya Pool, Dhanbad - 826001');
      addressCell.cellStyle =
          CellStyle(horizontalAlign: HorizontalAlign.Center);

      sheetObject.merge(
          CellIndex.indexByString('A3'), CellIndex.indexByString('I3'));
      var phoneCell = sheetObject.cell(CellIndex.indexByString('A3'));
      phoneCell.value = TextCellValue('PH : 9708035306,9708046999');
      phoneCell.cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center);

      // Report Title
      sheetObject.merge(
          CellIndex.indexByString('A5'), CellIndex.indexByString('I5'));
      var titleCell = sheetObject.cell(CellIndex.indexByString('A5'));
      titleCell.value = TextCellValue('AGENT WISE SALE REPORT (DETAIL)');
      titleCell.cellStyle = CellStyle(
        bold: true,
        fontSize: 14,
        horizontalAlign: HorizontalAlign.Center,
      );

      // Date Range
      sheetObject.merge(
          CellIndex.indexByString('A6'), CellIndex.indexByString('I6'));
      var dateCell = sheetObject.cell(CellIndex.indexByString('A6'));
      dateCell.value = TextCellValue('From : $fromDate To : $toDate');
      dateCell.cellStyle = CellStyle(horizontalAlign: HorizontalAlign.Center);

      // Agent Name
      var agentCell = sheetObject.cell(CellIndex.indexByString('A8'));
      agentCell.value = TextCellValue('Agent Name : $agentName');
      agentCell.cellStyle = CellStyle(bold: true);

      // Table Headers (Row 10)
      List<String> headers = [
        'Case No',
        'Case Date',
        'Patient Name',
        'Test Name',
        'Total Amount',
        'Discount',
        'Net Payable',
        'Paid',
        'Due'
      ];

      for (int i = 0; i < headers.length; i++) {
        var cell = sheetObject.cell(
            CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 9));
        cell.value = TextCellValue(headers[i]);
        cell.cellStyle = CellStyle(
          bold: true,
          backgroundColorHex: ExcelColor.grey,
          horizontalAlign: HorizontalAlign.Center,
        );
      }

      // Add Data Rows (Starting from Row 11)
      for (int i = 0; i < dataList.length; i++) {
        var data = dataList[i];
        int rowIndex = i + 10;

        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIndex))
            .value = TextCellValue(data.caseNo?.toString() ?? '');
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIndex))
            .value = TextCellValue(data.caseDate?.toString() ?? '');
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: rowIndex))
            .value = TextCellValue(data.patientName?.toString() ?? '');
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: rowIndex))
            .value = TextCellValue(data.testName?.toString() ?? '');
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: rowIndex))
            .value = TextCellValue(data.totalAmount?.toString() ?? '');
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: rowIndex))
            .value = TextCellValue(data.discount?.toString() ?? '');
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: rowIndex))
            .value = TextCellValue(data.afterDiscount?.toString() ?? '');
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: rowIndex))
            .value = TextCellValue(data.paidAmount?.toString() ?? '');
        sheetObject
            .cell(CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: rowIndex))
            .value = TextCellValue(data.balance?.toString() ?? '');
      }

      // Set column widths - INCREASED for amount columns
      sheetObject.setColumnWidth(0, 12);  // Case No
      sheetObject.setColumnWidth(1, 15);  // Case Date
      sheetObject.setColumnWidth(2, 20);  // Patient Name
      sheetObject.setColumnWidth(3, 25);  // Test Name
      sheetObject.setColumnWidth(4, 18);  // Total Amount - INCREASED
      sheetObject.setColumnWidth(5, 15);  // Discount - INCREASED
      sheetObject.setColumnWidth(6, 18);  // Net Payable - INCREASED
      sheetObject.setColumnWidth(7, 15);  // Paid - INCREASED
      sheetObject.setColumnWidth(8, 15);  // Due - INCREASED

      // Add Grand Total Row
      int grandTotalRow = dataList.length + 10;

      // Merge cells for "GRAND TOTAL" label
      sheetObject.merge(
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: grandTotalRow),
          CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: grandTotalRow));

      var grandTotalLabelCell = sheetObject.cell(
          CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: grandTotalRow));
      grandTotalLabelCell.value = TextCellValue('GRAND TOTAL');
      grandTotalLabelCell.cellStyle = CellStyle(
        bold: true,
        fontSize: 12,
        horizontalAlign: HorizontalAlign.Right,
        backgroundColorHex: ExcelColor.fromHexString('#ADD8E6'), // Light blue
      );

      // Add grand total values
      final grandTotal = state.saleModel.totals;

      var totalAmountCell = sheetObject.cell(
          CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: grandTotalRow));
      totalAmountCell.value = TextCellValue(grandTotal?.totalAmount?.toString() ?? '0');
      totalAmountCell.cellStyle = CellStyle(
        bold: true,
        fontSize: 12,
        horizontalAlign: HorizontalAlign.Right,
        backgroundColorHex: ExcelColor.fromHexString('#ADD8E6'),
      );

      var discountCell = sheetObject.cell(
          CellIndex.indexByColumnRow(columnIndex: 5, rowIndex: grandTotalRow));
      discountCell.value = TextCellValue(grandTotal?.totalDiscount?.toString() ?? '0');
      discountCell.cellStyle = CellStyle(
        bold: true,
        fontSize: 12,
        horizontalAlign: HorizontalAlign.Right,
        backgroundColorHex: ExcelColor.fromHexString('#ADD8E6'),
      );

      var netPayableCell = sheetObject.cell(
          CellIndex.indexByColumnRow(columnIndex: 6, rowIndex: grandTotalRow));
      netPayableCell.value = TextCellValue(grandTotal?.totalAfterDiscount?.toString() ?? '0');
      netPayableCell.cellStyle = CellStyle(
        bold: true,
        fontSize: 12,
        horizontalAlign: HorizontalAlign.Right,
        backgroundColorHex: ExcelColor.fromHexString('#ADD8E6'),
      );

      var paidCell = sheetObject.cell(
          CellIndex.indexByColumnRow(columnIndex: 7, rowIndex: grandTotalRow));
      paidCell.value = TextCellValue(grandTotal?.totalPaid?.toString() ?? '0');
      paidCell.cellStyle = CellStyle(
        bold: true,
        fontSize: 12,
        horizontalAlign: HorizontalAlign.Right,
        backgroundColorHex: ExcelColor.fromHexString('#ADD8E6'),
      );

      var dueCell = sheetObject.cell(
          CellIndex.indexByColumnRow(columnIndex: 8, rowIndex: grandTotalRow));
      dueCell.value = TextCellValue(grandTotal?.totalDue?.toString() ?? '0');
      dueCell.cellStyle = CellStyle(
        bold: true,
        fontSize: 12,
        horizontalAlign: HorizontalAlign.Right,
        backgroundColorHex: ExcelColor.fromHexString('#ADD8E6'),
      );

      // Save file
      var fileBytes = excel.save();
      if (fileBytes != null) {
        Directory? directory;

        if (Platform.isAndroid) {
          directory = await getExternalStorageDirectory();
        } else if (Platform.isIOS) {
          directory = await getApplicationDocumentsDirectory();
        } else {
          directory = await getDownloadsDirectory();
        }

        // Create filename with agent name and date range
        String sanitizedAgentName = agentName.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
        String sanitizedFromDate = fromDate.replaceAll('/', '-');
        String sanitizedToDate = toDate.replaceAll('/', '-');
        String fileName = 'SaleReport_${sanitizedAgentName}_${sanitizedFromDate}_to_${sanitizedToDate}.xlsx';
        String filePath = '${directory!.path}/$fileName';

        File file = File(filePath);
        await file.writeAsBytes(fileBytes);

        // Show success message
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Excel file saved: $fileName'),
              action: SnackBarAction(
                label: 'Open',
                onPressed: () => OpenFile.open(filePath),
              ),
              duration: Duration(seconds: 5),
            ),
          );

          // Optionally open the file
          await OpenFile.open(filePath);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error exporting to Excel: $e')),
        );
      }
    }
  }
}