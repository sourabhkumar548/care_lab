
import 'package:care_lab_software/Model/today_collection_model.dart';
import 'package:flutter/material.dart';

class ScrollableTable extends StatefulWidget {

  final List<Patient> list;

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
                DataColumn(label: Text("Case No", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Mobile", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Agent Name", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Discount", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("After Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Paid Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Balance", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Pay Type", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Status", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: List.generate(widget.list.length, (index) {
                var data = widget.list[index];

                return DataRow(cells: [
                  DataCell(Text("${data.caseNo}",style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(data.patientName ?? "",style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(data.mobile == "0" ? "Not Mention" : data.mobile!,style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text(data.agent!,style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("₹${data.totalAmount}",style: TextStyle(fontWeight: FontWeight.bold))),
                  DataCell(Text("₹${data.discount}",style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataCell(Text("₹${data.afterDiscount}",style: TextStyle(fontWeight: FontWeight.bold),)),
                  DataCell(Text("₹${data.paidAmount}",style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),)),
                  DataCell(Text("₹${data.balance}",style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),)),
                  DataCell(Text("${data.payMode}",style: TextStyle(color: data.payMode == "Cash" ? Colors.green : Colors.orange,fontWeight: FontWeight.bold),)),
                  DataCell(Text("${double.parse(data.balance!) > 0 ? "Due" : "Paid"}",style: TextStyle(color: double.parse(data.balance!) > 0 ? Colors.red : Colors.black,fontWeight: FontWeight.bold),)),
                ]);
              }),
            ),
          ),
        ),

      ],
    );
  }
}
