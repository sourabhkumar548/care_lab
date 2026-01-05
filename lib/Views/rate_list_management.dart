import 'package:care_lab_software/Controllers/RateListCtrl/Cubit/rate_list_cubit.dart';
import 'package:care_lab_software/Controllers/RateListCtrl/DeleteRateListCubit/delete_rate_list_cubit.dart';
import 'package:care_lab_software/Controllers/UpdateTestCtrl/Cubit/update_test_cubit.dart';
import 'package:care_lab_software/Controllers/UpdateTestCtrl/UpdateDataCubit/test_data_cubit.dart';
import 'package:care_lab_software/Service/urls.dart';
import 'package:care_lab_software/Views/reporting.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:web/helpers.dart' as html;
import '../Helpers/uiHelper.dart';
import 'loginscreen.dart';

class RateListManagement extends StatefulWidget {
  const RateListManagement({super.key});

  @override
  State<RateListManagement> createState() => _RateListManagementState();
}

class _RateListManagementState extends State<RateListManagement> {

  int currentPage = 0;
  int rowsPerPage = 10;

  TextEditingController searchCtrl = TextEditingController();
  String searchText = "";

  void _refreshData() {
    context.read<RateListCubit>().GetRateList();
    setState(() {
      searchText = "";
      searchCtrl.clear();
      currentPage = 0; // Reset to first page on refresh
    });
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String accessCode = args["code"];

    if(accessCode != "/rate_list_management"){
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LabLoginScreen()), (val)=>true);
    }

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Device.width < 1100 ?

      Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            //SIDE BAR
            Container(
              height: 180,
              child: UiHelper.custHorixontalTab(container: "5",context: context),
            ),
            //MAIN CONTENT
            Container(
              height: Adaptive.h(100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Rate List Management",
                      widget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(color: Colors.black12, blurRadius: 4),
                                ],
                              ),
                              child: TextField(
                                controller: searchCtrl,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search Test Name...",
                                  icon: Icon(Icons.search),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value.trim().toLowerCase();
                                    currentPage = 0;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 4),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.refresh, color: Colors.blue),
                              onPressed: _refreshData,
                              tooltip: "Refresh",
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20,),

                    Container(
                      color: Colors.blue.shade200,
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        border: TableBorder.all(width: 0.5, color: Colors.black),
                        columnWidths: {
                          0 : FlexColumnWidth(.5),
                          1 : FlexColumnWidth(4),
                          2 : FlexColumnWidth(2),
                          3 : FlexColumnWidth(1),
                          4 : FlexColumnWidth(1),
                          5 : FlexColumnWidth(3),
                          6 : FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            SizedBox(
                                height: 40,
                                child: Center(child: UiHelper.CustText(text: "Sno",size: 12.sp))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: UiHelper.CustText(text: "Test Name",size: 12.sp),
                            ),
                            Center(child: UiHelper.CustText(text: "Department",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Rate",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Time\n(days)",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "File",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Action",size: 12.sp)),
                          ])
                        ],
                      ),
                    ),
                    BlocBuilder<RateListCubit, RateListState>(
                      builder: (context, state) {
                        if(state is RateListLoadingState){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        if(state is RateListErrorState){
                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                        }
                        if (state is RateListLoadedState) {

                          List list = state.rateListModel.rateList!;

                          // 🔍 SEARCH FILTER
                          if (searchText.isNotEmpty) {
                            list = list.where((item) {
                              return item.testName!.toLowerCase().contains(searchText);
                            }).toList();
                          }

                          int total = list.length;

                          int start = currentPage * rowsPerPage;
                          int end = start + rowsPerPage;
                          if (end > total) end = total;

                          final paginatedList = list.sublist(start, end);

                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: paginatedList.length,
                                itemBuilder: (_, index) {
                                  var data = paginatedList[index];
                                  // 🔧 CALCULATE ORIGINAL INDEX IN FULL LIST
                                  int originalIndex = start + index;

                                  return Table(
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    border: TableBorder.all(width: 0.5, color: Colors.grey),
                                    columnWidths: {
                                      0: FlexColumnWidth(.5),
                                      1: FlexColumnWidth(4),
                                      2: FlexColumnWidth(2),
                                      3: FlexColumnWidth(1),
                                      4: FlexColumnWidth(1),
                                      5: FlexColumnWidth(3),
                                      6: FlexColumnWidth(1),
                                    },
                                    children: [
                                      TableRow(children: [
                                        Center(child: UiHelper.CustText(text: "${originalIndex + 1}", size: 12.sp)),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: UiHelper.CustText(text: data.testName!, size: 11.sp),
                                        ),
                                        Center(child: UiHelper.CustText(text: data.department!, size: 11.sp)),
                                        Center(child: UiHelper.CustText(text: data.rate!, size: 11.sp)),
                                        Center(child: UiHelper.CustText(text: data.deliveryAfter!, size: 11.sp)),
                                        InkWell(
                                            onTap : (){
                                              final encodedUrl = Uri.encodeComponent("${Urls.OrignalWordFileUrl}${data.testFile!}");
                                              final officeEditorUrl = "https://www.office.com/launch/word?src=$encodedUrl";
                                              html.window.open(officeEditorUrl, "_blank");


                                              // String reportUrl = "${Urls.OrignalWordFileUrl}${data.testFile!}";
                                              // final wordUrl = "ms-word:ofe|u|$reportUrl";
                                              // html.window.open(wordUrl, "_self");
                                            },
                                            child: Center(child: UiHelper.CustText(text: data.testFile!, size: 11.sp))),
                                        Column(
                                          children: [
                                            Tooltip(
                                              message:"Edit Data",
                                              child: IconButton(onPressed: (){
                                                // ✅ USE data VARIABLE DIRECTLY FROM itemBuilder
                                                editLayout(
                                                    context: context,
                                                    id: data.id.toString(),
                                                    name: data.testName!,
                                                    rate: data.rate!,
                                                    department: data.department!,
                                                    time: data.deliveryAfter!
                                                );
                                              }, icon: Icon(Icons.edit,color: Colors.orange,)),
                                            ),
                                            Tooltip(
                                              message:"Edit File",
                                              child: IconButton(
                                                onPressed: () => pickAndUploadWebFile(context: context, id: data.id.toString()),
                                                icon: Icon(Icons.file_present_sharp, color: Colors.green),
                                              ),
                                            ),
                                            BlocConsumer<DeleteRateListCubit, DeleteRateListState>(
                                              listener: (context, state) {
                                                if(state is DeleteRateListErrorState){
                                                  UiHelper.showErrorToste(message: state.errorMsg);
                                                }
                                                if(state is DeleteRateListLoadedState){
                                                  context.read<RateListCubit>().GetRateList();
                                                  UiHelper.showSuccessToste(message: state.successMsg);
                                                }
                                              },
                                              builder: (context, state) {
                                                if(state is DeleteRateListLoadingState){
                                                  return Center(child: CircularProgressIndicator(),);
                                                }
                                                return Tooltip(
                                                  message: "Delete Test",
                                                  child: IconButton(
                                                    onPressed: () {
                                                      showDialog<bool>(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: UiHelper.CustText(text: "Confirmation",size: 10.5.sp),
                                                            content: Text("Are you sure to delete this test?"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: const Text("No"),
                                                                onPressed: () => Navigator.of(context).pop(false),
                                                              ),
                                                              ElevatedButton(
                                                                child: const Text("Yes"),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                  context.read<DeleteRateListCubit>().DeleteRateList(id: data.id.toString());
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: Icon(Icons.delete, color: Colors.red),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ])
                                    ],
                                  );
                                },
                              ),

                              SizedBox(height: 20),

                              // ---------------- PAGINATION BUTTONS ----------------
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: currentPage > 0
                                        ? () => setState(() => currentPage--)
                                        : null,
                                    child: Text("Previous"),
                                  ),
                                  SizedBox(width: 20),
                                  Text("Page ${currentPage + 1} / ${total == 0 ? 1 : ((total - 1) / rowsPerPage).floor() + 1}"),
                                  SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: end < total
                                        ? () => setState(() => currentPage++)
                                        : null,
                                    child: Text("Next"),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          );
                        }

                        return Container();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )

          :

      Center(
        child: Row(
          children: [
            //SIDE BAR
            Container(
              width: Adaptive.w(15),
              child: UiHelper.custsidebar(container: "8",context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Rate List Management",
                      widget: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 300,
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(color: Colors.black12, blurRadius: 4),
                                ],
                              ),
                              child: TextField(
                                controller: searchCtrl,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Search Test Name...",
                                  icon: Icon(Icons.search),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    searchText = value.trim().toLowerCase();
                                    currentPage = 0;
                                  });
                                },
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(color: Colors.black12, blurRadius: 4),
                              ],
                            ),
                            child: IconButton(
                              icon: Icon(Icons.refresh, color: Colors.blue),
                              onPressed: _refreshData,
                              tooltip: "Refresh",
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20,),
                    Container(
                      color: Colors.blue.shade200,
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        border: TableBorder.all(width: 0.5, color: Colors.black),
                        columnWidths: {
                          0 : FlexColumnWidth(.5),
                          1 : FlexColumnWidth(4),
                          2 : FlexColumnWidth(2),
                          3 : FlexColumnWidth(1),
                          4 : FlexColumnWidth(1),
                          5 : FlexColumnWidth(3),
                          6 : FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            SizedBox(
                                height: 40,
                                child: Center(child: UiHelper.CustText(text: "Sno"))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: UiHelper.CustText(text: "Test Name"),
                            ),
                            Center(child: UiHelper.CustText(text: "Department")),
                            Center(child: UiHelper.CustText(text: "Rate")),
                            Center(child: UiHelper.CustText(text: "Report Time")),
                            Center(child: UiHelper.CustText(text: "File")),
                            Center(child: UiHelper.CustText(text: "Action")),
                          ])
                        ],
                      ),
                    ),
                    BlocBuilder<RateListCubit, RateListState>(
                      builder: (context, state) {
                        if(state is RateListLoadingState){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        if(state is RateListErrorState){
                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                        }
                        if (state is RateListLoadedState) {

                          List list = state.rateListModel.rateList!;

                          // 🔍 SEARCH FILTER
                          if (searchText.isNotEmpty) {
                            list = list.where((item) {
                              return item.testName!.toLowerCase().contains(searchText);
                            }).toList();
                          }

                          int total = list.length;

                          int start = currentPage * rowsPerPage;
                          int end = start + rowsPerPage;
                          if (end > total) end = total;

                          final paginatedList = list.sublist(start, end);

                          return Column(
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: paginatedList.length,
                                itemBuilder: (_, index) {
                                  var data = paginatedList[index];
                                  // 🔧 CALCULATE ORIGINAL INDEX IN FULL LIST
                                  int originalIndex = start + index;

                                  return Table(
                                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                    border: TableBorder.all(width: 0.5, color: Colors.grey),
                                    columnWidths: {
                                      0: FlexColumnWidth(.5),
                                      1: FlexColumnWidth(4),
                                      2: FlexColumnWidth(2),
                                      3: FlexColumnWidth(1),
                                      4: FlexColumnWidth(1),
                                      5: FlexColumnWidth(3),
                                      6: FlexColumnWidth(1),
                                    },
                                    children: [
                                      TableRow(children: [
                                        Center(child: UiHelper.CustText(text: "${originalIndex + 1}", size: 12.sp)),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10),
                                          child: UiHelper.CustText(text: data.testName!, size: 11.sp),
                                        ),
                                        Center(child: UiHelper.CustText(text: data.department!, size: 11.sp)),
                                        Center(child: UiHelper.CustText(text: data.rate!, size: 11.sp)),
                                        Center(child: UiHelper.CustText(text: data.deliveryAfter!, size: 11.sp)),
                                        InkWell(
                                            onTap : (){
                                              final encodedUrl = Uri.encodeComponent("${Urls.OrignalWordFileUrl}${data.testFile!}");
                                              final officeEditorUrl = "https://www.office.com/launch/word?src=$encodedUrl";
                                              html.window.open(officeEditorUrl, "_blank");

                                            },
                                            child: Center(child: UiHelper.CustText(text: data.testFile!, size: 11.sp,color: Colors.blue.shade900))),
                                        Column(
                                          children: [
                                            Tooltip(
                                                message: "Edit Data",
                                                child: IconButton(onPressed: (){
                                                  // ✅ USE data VARIABLE DIRECTLY FROM itemBuilder
                                                  editLayout(
                                                      context: context,
                                                      id: data.id.toString(),
                                                      name: data.testName!,
                                                      rate: data.rate!,
                                                      department: data.department!,
                                                      time: data.deliveryAfter!
                                                  );
                                                }, icon: Icon(Icons.edit,color: Colors.orange,))),
                                            Tooltip(
                                              message: "Edit File",
                                              child: IconButton(
                                                onPressed: () => pickAndUploadWebFile(context: context, id: data.id.toString()),
                                                icon: Icon(Icons.file_present_sharp, color: Colors.green),
                                              ),
                                            ),
                                            BlocConsumer<DeleteRateListCubit, DeleteRateListState>(
                                              listener: (context, state) {
                                                if(state is DeleteRateListErrorState){
                                                  UiHelper.showErrorToste(message: state.errorMsg);
                                                }
                                                if(state is DeleteRateListLoadedState){
                                                  context.read<RateListCubit>().GetRateList();
                                                  UiHelper.showSuccessToste(message: state.successMsg);
                                                }
                                              },
                                              builder: (context, state) {
                                                if(state is DeleteRateListLoadingState){
                                                  return Center(child: CircularProgressIndicator(),);
                                                }
                                                return Tooltip(
                                                  message: "Delete Test",
                                                  child: IconButton(
                                                    onPressed: () {
                                                      showDialog<bool>(
                                                        context: context,
                                                        barrierDismissible: false,
                                                        builder: (BuildContext context) {
                                                          return AlertDialog(
                                                            title: UiHelper.CustText(text: "Confirmation",size: 10.5.sp),
                                                            content: Text("Are you sure to delete this test?"),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                child: const Text("No"),
                                                                onPressed: () => Navigator.of(context).pop(false),
                                                              ),
                                                              ElevatedButton(
                                                                child: const Text("Yes"),
                                                                onPressed: () {
                                                                  Navigator.of(context).pop();
                                                                  context.read<DeleteRateListCubit>().DeleteRateList(id: data.id.toString());
                                                                },
                                                              ),
                                                            ],
                                                          );
                                                        },
                                                      );
                                                    },
                                                    icon: Icon(Icons.delete, color: Colors.red),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ])
                                    ],
                                  );
                                },
                              ),

                              SizedBox(height: 20),

                              // ---------------- PAGINATION BUTTONS ----------------
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  ElevatedButton(
                                    onPressed: currentPage > 0
                                        ? () => setState(() => currentPage--)
                                        : null,
                                    child: Text("Previous"),
                                  ),
                                  SizedBox(width: 20),
                                  Text("Page ${currentPage + 1} / ${total == 0 ? 1 : ((total - 1) / rowsPerPage).floor() + 1}"),
                                  SizedBox(width: 20),
                                  ElevatedButton(
                                    onPressed: end < total
                                        ? () => setState(() => currentPage++)
                                        : null,
                                    child: Text("Next"),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          );
                        }

                        return Container();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void editLayout({
  required BuildContext context,
  required String id,
  required String name,
  required String rate,
  required String department,
  required String time
}) {
  showModalBottomSheet(
    context: context,
    isDismissible: false,
    isScrollControlled: true,
    builder: (modalContext) {
      TextEditingController nameCtrl = TextEditingController(text: name);
      TextEditingController rateCtrl = TextEditingController(text: rate);
      TextEditingController timeCtrl = TextEditingController(text: time);
      TextEditingController departmentCtrl = TextEditingController(text: department);

      return Padding(
        padding: EdgeInsets.only(
          left: 12,
          right: 12,
          top: 12,
          bottom: MediaQuery.of(modalContext).viewInsets.bottom + 12,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UiHelper.CustText(text: "Edit Test Data", size: 14.sp),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(modalContext);
                    },
                    icon: Icon(Icons.close, color: Colors.red),
                  )
                ],
              ),
              const Divider(),
              const SizedBox(height: 10),
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Test Name",
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: rateCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Test Rate",
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: timeCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Test Report Time",
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: departmentCtrl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Test Department",
                ),
              ),
              const SizedBox(height: 20),
              BlocConsumer<TestDataCubit, TestDataState>(
                listener: (listenerContext, state) {
                  if (state is TestDataErrorState) {
                    UiHelper.showErrorToste(message: state.errorMsg);
                  }
                  if (state is TestDataLoadedState) {
                    UiHelper.showSuccessToste(message: state.successMsg);
                    // Refresh the rate list and close modal
                    Future.delayed(Duration(milliseconds: 1000), () {
                      if (modalContext.mounted) {
                        context.read<RateListCubit>().GetRateList();
                        Navigator.pop(modalContext);
                      }
                    });
                  }
                },
                builder: (builderContext, state) {
                  if (state is TestDataLoadingState) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return InkWell(
                    onTap: () {
                      // Validate fields
                      if (nameCtrl.text.trim().isEmpty) {
                        UiHelper.showErrorToste(message: "Test name is required");
                        return;
                      }
                      if (rateCtrl.text.trim().isEmpty) {
                        UiHelper.showErrorToste(message: "Test rate is required");
                        return;
                      }
                      if (timeCtrl.text.trim().isEmpty) {
                        UiHelper.showErrorToste(message: "Report time is required");
                        return;
                      }
                      if (departmentCtrl.text.trim().isEmpty) {
                        UiHelper.showErrorToste(message: "Department is required");
                        return;
                      }

                      // Use the original context passed to editLayout
                      context.read<TestDataCubit>().updateTestData(
                        id: id,
                        name: nameCtrl.text.trim(),
                        rate: rateCtrl.text.trim(),
                        time: timeCtrl.text.trim(),
                        department: departmentCtrl.text.trim(),
                      );
                    },
                    child: Card(
                      child: Container(
                        height: 50,
                        width: double.infinity,
                        color: Colors.green,
                        child: Center(
                          child: UiHelper.CustText(
                            text: "Update Test",
                            color: Colors.white,
                            size: 11.sp,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> pickAndUploadWebFile({required BuildContext context, required String id}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    withData: true,
  );

  if (result == null) {
    UiHelper.showErrorToste(message: "No file selected");
    return;
  }

  PlatformFile file = result.files.single;

  context.read<UpdateTestCubit>().getUpdateTest(id: id, fileName: file.name, file: file);
}

