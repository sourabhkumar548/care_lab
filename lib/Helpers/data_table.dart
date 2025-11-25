import 'package:care_lab_software/Helpers/uiHelper.dart';
import 'package:care_lab_software/Views/reporting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Controllers/CheckReportCtrl/check_report_cubit.dart';

class ScrollableTable extends StatefulWidget {

  final List<dynamic> list;

  const ScrollableTable({super.key, required this.list});

  @override
  _ScrollableTableState createState() => _ScrollableTableState();
}

class _ScrollableTableState extends State<ScrollableTable> {
  final ScrollController _scrollController = ScrollController();



  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: DataTable(
              columns: const [
                DataColumn(label: Text("Sl.No", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Mobile", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Discount", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("After Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Paid Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Balance", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: List.generate(widget.list.length, (index) {
                var data = widget.list[index];

                return DataRow(cells: [
                  DataCell(Text("${index + 1}",style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(data.patientName ?? "",style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(data.mobile ?? "",style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("₹${data.totalAmount}.00",style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("₹${data.discount}.00",style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataCell(Text("₹${data.afterDiscount}.00",style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataCell(Text("₹${data.paidAmount}.00",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)),
                  DataCell(Text("₹${data.balance}.00",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
                ]);
              }),
            ),
          ),
        ),

      ],
    );
  }
}
