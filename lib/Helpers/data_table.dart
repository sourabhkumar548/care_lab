import 'package:flutter/material.dart';

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
                DataColumn(label: Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Discount", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Paid Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Balance", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Doctor", style: TextStyle(fontWeight: FontWeight.bold))),
                DataColumn(label: Text("Agent", style: TextStyle(fontWeight: FontWeight.bold))),
              ],
              rows: List.generate(widget.list.length, (index) {
                var data = widget.list[index];

                return DataRow(cells: [
                  DataCell(Text("${index + 1}")),
                  DataCell(
                    Tooltip(
                      message: "Mobile: ${data.mobile}\nAdvance: ₹${data.advance}.00",
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data.patientName ?? "",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ),
                  DataCell(Text("₹${data.totalAmount}.00")),
                  DataCell(Text("₹${data.discount}.00")),
                  DataCell(Text("₹${data.afterDiscount}.00")),
                  DataCell(Text("₹${data.balance}.00")),
                  DataCell(Text("${data.balance ?? ''}")),
                  DataCell(Text("${data.balance ?? ''}")),
                ]);
              }),
            ),
          ),
        ),

      ],
    );
  }
}
