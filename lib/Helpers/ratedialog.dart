import 'package:care_lab_software/Helpers/uiHelper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

import '../Controllers/RateListCtrl/Cubit/rate_list_cubit.dart';

class AddTestDialog extends StatefulWidget {
  @override
  State<AddTestDialog> createState() => AddTestDialogState();
}

class AddTestDialogState extends State<AddTestDialog> {
  TextEditingController searchCtrl = TextEditingController();

  static List<Map<String, dynamic>> selectedTests = [];
  static double totalAmount = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    // Update list whenever search text changes
    searchCtrl.addListener(() {
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.all(20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 700,
        height: 750,
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            // ---------- TITLE + TOTAL ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Add Test", style: TextStyle(fontSize: 18)),
                Text(
                  "Total Amount : ${totalAmount.toStringAsFixed(2)}",
                  style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 14),
                ),
              ],
            ),

            SizedBox(height: 15),

            // ---------- SELECTED TEST LIST ----------
            Container(
              height: 230,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListView.builder(
                controller: _scrollController,
                itemCount: selectedTests.length,
                itemBuilder: (_, index) {
                  var item = selectedTests[index];
                  return Card(
                    color: Colors.white,
                    elevation: 0,
                    margin: EdgeInsets.only(bottom: 6),
                    child: ListTile(
                      title: Text("${index + 1} : ${item["Test Name"]}"),
                      subtitle: Text("₹${item["Test Rate"]}"),
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            totalAmount -= double.parse(item["Test Rate"].toString());
                            selectedTests.removeAt(index);
                          });
                        },
                        icon: Icon(Icons.close, color: Colors.red),
                      ),
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 20),

            // ---------- SEARCH BOX ----------
            TextField(
              controller: searchCtrl,
              decoration: InputDecoration(
                labelText: "Enter Test Name",
                prefixIcon: Icon(Icons.search),
                suffixIcon: InkWell(
                  onTap: () {
                    searchCtrl.clear();
                    setState(() {});
                  },
                  child: Icon(Icons.close),
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),

            SizedBox(height: 15),

            // ---------- RATE LIST FROM API ----------
            Expanded(
              child: BlocBuilder<RateListCubit, RateListState>(
                builder: (context, state) {
                  if (state is RateListLoadingState) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is RateListErrorState) {
                    return Center(child: Text("Error: ${state.errorMsg}"));
                  }
                  if (state is RateListLoadedState) {
                    List allTests = state.rateListModel.rateList!;

                    // Filtered
                    List filtered = allTests.where((item) {
                      final s = searchCtrl.text.toLowerCase();
                      return item.testName!.toLowerCase().contains(s) ||
                          item.department!.toLowerCase().contains(s);
                    }).toList();

                    return ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, index) {
                        var item = filtered[index];
                        bool alreadySelected = selectedTests.any(
                                (t) => t["Test Name"] == item.testName);

                        return Card(
                          child: ListTile(
                            title: Text(item.testName!),
                            subtitle: Text(item.department!),
                            trailing: alreadySelected
                                ? Icon(Icons.check, color: Colors.green)
                                : Text("₹${item.rate!}"),
                            onTap: () {
                              if (!alreadySelected) {
                                setState(() {
                                  selectedTests.add({
                                    "Department": item.department,
                                    "Test Name": item.testName,
                                    "Test Rate": double.parse(item.rate!),
                                    "Test Time": item.deliveryAfter,
                                    "Test File": item.testFile,
                                  });
                                  totalAmount += double.parse(item.rate!);
                                });

                                Future.delayed(Duration(milliseconds: 200), () {
                                  if (_scrollController.hasClients) {
                                    _scrollController.jumpTo(
                                      _scrollController.position.maxScrollExtent,
                                    );
                                  }
                                });
                              } else {
                                toastification.show(
                                  title: UiHelper.CustText(text: "Already selected"),
                                  type: ToastificationType.warning,
                                  autoCloseDuration: Duration(seconds: 2),
                                  alignment: Alignment.center,
                                  backgroundColor: Colors.orange.shade100,
                                );
                              }
                            },
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),

            SizedBox(height: 10),

            // ---------- ACTIONS ----------
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancel")),
                SizedBox(width: 20),
                TextButton(
                    onPressed: () => Navigator.pop(context, selectedTests),
                    child: Text("Done")),
              ],
            )
          ],
        ),
      ),
    );
  }

}
