import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class SaleReport extends StatelessWidget {
  const SaleReport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Container(
          width: 900,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(16),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ---------- HEADER ----------
              Center(
                child: Column(
                  children: const [
                    Text(
                      "CARE DIAGNOSTIC CENTRE",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Naya Bazar, Near Gaya Pool, Dhanbad - 826001",
                      style: TextStyle(fontSize: 12),
                    ),
                    Text(
                      "PH : 9708035306,9708046999",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              /// ---------- REPORT TITLE ----------
              Center(
                child: Column(
                  children: const [
                    Text(
                      "AGENT WISE SALE REPORT (DETAIL)",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      "From : 01/Dec/2025 To : 10/Dec/2025",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              /// ---------- AGENT NAME ----------
              const Text(
                "AGENT NAME : BABY",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              /// ---------- TABLE HEADER ----------
              _tableHeader(),
              const Divider(thickness: 1),
              const SizedBox(height: 6),

              /// ---------- DATA ROWS ----------
              _dataRow(
                caseNo: "5914",
                date: "01/12/2025",
                patient: "IKRAM QURAISHI",
                test: "USG Whole Abdomen",
                amount: "1200.00",
              ),
              const SizedBox(height: 16),
              const Divider(thickness: 1),
              _testTotalRow("1200.00", "0.00", "200.00", "1000.00", "1000.00", "0.00"),
              const SizedBox(height: 6),
              const Divider(thickness: 1),
              const SizedBox(height: 8),

              /// ---------- GRAND TOTAL ----------
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red, width: 1.5),
                ),
                child: _summaryRow(
                  label: "GRAND TOTAL",
                  bill: "1950.00",
                  discount: "200.00",
                  net: "1750.00",
                  receipt: "1000.00",
                  balance: "750.00",
                  isBold: true,
                ),
              ),
              const Spacer(),

              /// ---------- FOOTER & PRINT BUTTON ----------
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Print Date & Time : 10/12/2025 03:02:21 PM",
                    style: TextStyle(fontSize: 11),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => _printReport(context),
                    icon: const Icon(Icons.print),
                    label: const Text("Print"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ---------- PRINT FUNCTION ----------
  Future<void> _printReport(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(20),
        build: (pw.Context context) {
          return [
            /// HEADER
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    "CARE DIAGNOSTIC CENTRE",
                    style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    "Naya Bazar, Near Gaya Pool, Dhanbad - 826001",
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                  pw.Text(
                    "PH : 9708035306,9708046999",
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),

            /// TITLE
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text(
                    "AGENT WISE SALE REPORT (DETAIL)",
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.red,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    "From : 01/Dec/2025 To : 10/Dec/2025",
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),

            /// AGENT NAME
            pw.Text(
              "AGENT NAME : BABY",
              style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            ),
            pw.SizedBox(height: 16),

            /// TABLE
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              children: [
                /// Header
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _pdfCell("Case No", bold: true),
                    _pdfCell("Date", bold: true),
                    _pdfCell("Patient", bold: true),
                    _pdfCell("Test Details", bold: true),
                    _pdfCell("Bill Amt", bold: true),
                    _pdfCell("Discount", bold: true),
                    _pdfCell("Net Amt", bold: true),
                    _pdfCell("Receipt", bold: true),
                    _pdfCell("Balance", bold: true),
                  ],
                ),
                /// Data Row
                pw.TableRow(
                  children: [
                    _pdfCell("5914"),
                    _pdfCell("01/12/2025"),
                    _pdfCell("IKRAM QURAISHI"),
                    _pdfCell("USG Whole Abdomen"),
                    _pdfCell("1200.00"),
                    _pdfCell("0.00"),
                    _pdfCell("1200.00"),
                    _pdfCell("0.00"),
                    _pdfCell("1200.00"),
                  ],
                ),
                /// Test Total
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _pdfCell(""),
                    _pdfCell("Test TOTAL :", bold: true),
                    _pdfCell(""),
                    _pdfCell(""),
                    _pdfCell("1200.00", bold: true),
                    _pdfCell("0.00", bold: true),
                    _pdfCell("200.00", bold: true),
                    _pdfCell("1000.00", bold: true),
                    _pdfCell("1000.00", bold: true),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 16),

            /// GRAND TOTAL
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.red, width: 1.5),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("GRAND TOTAL", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Bill: 1950.00", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Disc: 200.00", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Net: 1750.00", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Receipt: 1000.00", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  pw.Text("Balance: 750.00", style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
            ),
          ];
        },
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerLeft,
            child: pw.Text(
              "Print Date & Time : 10/12/2025 03:02:21 PM",
              style: const pw.TextStyle(fontSize: 10),
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  /// PDF Cell Helper
  static pw.Widget _pdfCell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  /// ---------- TABLE HEADER ----------
  Widget _tableHeader() {
    return Row(
      children: const [
        _Cell("Case No", 1),
        _Cell("Date", 1),
        _Cell("Patient", 3),
        _Cell("Test Details", 3),
        _Cell("Bill Amt", 1),
        _Cell("Discount", 1),
        _Cell("Net Amt", 1),
        _Cell("Receipt", 1),
        _Cell("Balance", 1),
      ],
    );
  }

  /// ---------- DATA ROW ----------
  Widget _dataRow({
    required String caseNo,
    required String date,
    required String patient,
    required String test,
    required String amount,
  }) {
    return Row(
      children: [
        _Cell(caseNo, 1),
        _Cell(date, 1),
        _Cell(patient, 3),
        _Cell(test, 3),
        _Cell(amount, 1),
        _Cell("0.00", 1),
        _Cell(amount, 1),
        _Cell("0.00", 1),
        _Cell(amount, 1),
      ],
    );
  }

  /// ---------- TEST TOTAL ----------
  Widget _testTotalRow(
      String bill,
      String scharge,
      String discount,
      String net,
      String receipt,
      String balance,
      ) {
    return Row(
      children: [
        const _Cell("", 2),
        const _Cell("Test TOTAL :", 3, bold: true),
        _Cell(bill, 1),
        _Cell(scharge, 1),
        _Cell(discount, 1),
        _Cell(net, 1),
        _Cell(receipt, 1),
        _Cell(balance, 1),
      ],
    );
  }

  /// ---------- SUMMARY ----------
  Widget _summaryRow({
    required String label,
    required String bill,
    required String discount,
    required String net,
    required String receipt,
    required String balance,
    bool isBold = false,
  }) {
    return Row(
      children: [
        _Cell(label, 6, bold: true),
        _Cell(bill, 1, bold: isBold),
        _Cell("0.00", 1),
        _Cell(discount, 1),
        _Cell(net, 1),
        _Cell(receipt, 1),
        _Cell(balance, 1),
      ],
    );
  }
}

/// ---------- CELL WIDGET ----------
class _Cell extends StatelessWidget {
  final String text;
  final int flex;
  final bool bold;

  const _Cell(this.text, this.flex, {this.bold = false});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 11,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}