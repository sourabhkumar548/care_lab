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
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("Add Test"),
          Text(
            "Total Amount : ${totalAmount.toStringAsFixed(2)}",
            style: TextStyle(
              color: Colors.green,
              fontFamily: 'font-bold',
              fontSize: 11.sp,
            ),
          ),
        ],
      ),
      content: SizedBox(
        width: 500,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Already selected tests
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                itemCount: selectedTests.length,
                itemBuilder: (_, index) {
                  var item = selectedTests[index];
                  return Container(
                    color: Colors.blue.shade100,
                    child: ListTile(
                      title: Text(
                          "${index + 1} : ${item["Test Name"]} (₹${item["Test Rate"]})"),
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

            // Search field
            Container(
              padding: EdgeInsets.only(top: 20, bottom: 10),
              width: Adaptive.w(20),
              child: Expanded(
                child: TextField(
                  controller: searchCtrl,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      labelText: "Enter Test Name",
                      filled: true,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.green, width: 2),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black45, width: 1.5),
                      ),
                      fillColor: Colors.grey.shade100,
                      labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 11.sp),
                      prefixIcon: Icon(Icons.search),
                      suffixIcon: InkWell(
                          onTap: (){
                            searchCtrl.clear();
                            setState(() {}); // Refresh list
                          },
                          child: Icon(Icons.search,))
                  ),
                ),
              ),
            ),

            // Test list from cubit
            BlocBuilder<RateListCubit, RateListState>(
              builder: (context, state) {
                if (state is RateListLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is RateListErrorState) {
                  return Center(child: Text("Error: ${state.errorMsg}"));
                }
                if (state is RateListLoadedState) {
                  List allTests = state.rateListModel.rateList!;

                  // Filter based on search text
                  List filteredList = allTests.where((item) {
                    final searchText = searchCtrl.text.toLowerCase();
                    return item.testName!.toLowerCase().contains(searchText) ||
                        item.department!.toLowerCase().contains(searchText);
                  }).toList();

                  return Container(
                    height: 300,
                    child: ListView.builder(
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        var item = filteredList[index];

                        bool alreadySelected = selectedTests.any(
                                (t) => t["Test Name"] == item.testName);

                        return InkWell(
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

                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (_scrollController.hasClients) {
                                  _scrollController.animateTo(
                                    _scrollController.position.maxScrollExtent,
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.easeOut,
                                  );
                                }
                              });
                            }
                            else{
                              toastification.show(
                                title: UiHelper.CustText(text: "Already selected"),
                                animationDuration: Duration(milliseconds: 200),
                                type: ToastificationType.warning,
                                autoCloseDuration: Duration(seconds: 2),
                                alignment: AlignmentDirectional.center,
                                backgroundColor: Colors.orange.shade100

                              );
                            }
                          },
                          child: ListTile(
                            title: Text(item.testName!),
                            subtitle: Text(item.department!),
                            trailing: alreadySelected
                                ? Icon(Icons.check, color: Colors.green)
                                : Text("₹${item.rate!}",
                                style: TextStyle(fontSize: 14)),
                          ),
                        );
                      },
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        TextButton(onPressed: () => Navigator.pop(context, selectedTests), child: const Text("Done")),
      ],
    );
  }
}
