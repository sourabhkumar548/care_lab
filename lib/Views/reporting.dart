import 'dart:convert';

import 'package:care_lab_software/Controllers/CheckReportCtrl/check_report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:sizer/sizer.dart';
import 'package:web/web.dart' as html;

import '../Controllers/CaseList/Cubit/case_list_cubit.dart';
import '../Controllers/DocCtrl/bloc/doc_bloc.dart';
import '../Controllers/DocCtrl/doc_ctrl.dart';
import '../Helpers/get_reporting_list.dart';
import '../Helpers/print_case_entry.dart';
import '../Helpers/uiHelper.dart';

class Reporting extends StatefulWidget {
  Reporting({super.key});

  @override
  State<Reporting> createState() => _ReportingState();

  int flag = 0;
}

class _ReportingState extends State<Reporting> {
  TextEditingController dateCtrl = TextEditingController(
      text: "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}");

  // Changed to track both caseNo and test index
  String? loadingCaseNo;
  int? loadingTestIndex;

  @override
  void initState() {
    super.initState();
    // Load case list on init
    context.read<CaseListCubit>().getCaseList(
        date: dateCtrl.text,
        type: "Report"
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Center(
        child: Row(
          children: [
            //SIDE BAR
            Container(
              width: Adaptive.w(15),
              child: UiHelper.custsidebar(container: "4", context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(
                        title: "PATIENT REPORTING LIST",
                        widget: Container(
                          width: 300,
                          height: 40,
                          child: TextField(
                            controller: dateCtrl,
                            style: TextStyle(color: Colors.black),
                            decoration: InputDecoration(
                                labelText: "Select Date",
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
                                labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'font-bold',
                                    fontSize: 11.sp),
                                prefixIcon: Icon(Icons.calendar_month),
                                suffixIcon: GestureDetector(
                                    onTap: () async {
                                      DateTime? pickedDate = await showOmniDateTimePicker(
                                        context: context,
                                        type: OmniDateTimePickerType.date,
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate =
                                            "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                                        setState(() {
                                          dateCtrl.text = formattedDate;
                                          context.read<CaseListCubit>().getCaseList(
                                              date: formattedDate, type: "Report");
                                        });
                                      }
                                    },
                                    child: Icon(Icons.search))),
                          ),
                        )),
                    SizedBox(height: 5),
                    Column(
                      children: [
                        SizedBox(height: 10),
                        BlocBuilder<CaseListCubit, CaseListState>(
                          builder: (context, state) {
                            if (state is CaseListLoadingState) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (state is CaseListErrorState) {
                              return Center(
                                child: UiHelper.CustText(
                                    text: state.errorMsg,
                                    color: Colors.red,
                                    size: 12.sp),
                              );
                            }
                            if (state is CaseListLoadedState) {
                              return ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (_, index) {
                                  var mainData = state.caseListModel.caseList![index];
                                  return ListView.builder(
                                    shrinkWrap: true,
                                    itemBuilder: (_, idx) {
                                      var data = mainData.items![idx];
                                      List<String> testName =
                                      data.testName!.split(",");
                                      List<String> testDate =
                                      data.testDate!.split(",");
                                      List<String> testfile =
                                      data.testFile!.split(",");

                                      String name = data.patientName!;
                                      String date = data.date!;
                                      String slipno = data.slipNo!;
                                      String age = "${data.year!} Y ${data.month!} M";
                                      String sex = data.gender!;
                                      String referredby = data.doctor!;

                                      return Container(
                                        margin: EdgeInsets.only(bottom: 5),
                                        color: index % 2 == 0
                                            ? Colors.grey.shade200
                                            : Colors.white70,
                                        child: ExpansionTile(
                                          title: Table(
                                            columnWidths: {
                                              0: FlexColumnWidth(1),
                                              1: FlexColumnWidth(2),
                                              2: FlexColumnWidth(7),
                                              3: FlexColumnWidth(6),
                                              4: FlexColumnWidth(2),
                                            },
                                            children: [
                                              TableRow(children: [
                                                Center(
                                                    child: UiHelper.CustText(
                                                        text:
                                                        "Case No \n${data.caseNo!}",
                                                        size: 11.sp)),
                                                Center(
                                                    child: UiHelper.CustText(
                                                        text:
                                                        "Case Date \n${data.caseDate!}",
                                                        size: 11.sp)),
                                                UiHelper.CustText(
                                                    text:
                                                    "Patient Name : \n${data.patientName!}",
                                                    size: 11.sp),
                                                UiHelper.CustText(
                                                    text:
                                                    "Doctor Name : \n${data.doctor!}",
                                                    size: 11.sp),
                                                Center(
                                                    child: UiHelper.CustText(
                                                        text:
                                                        "Bill Amount \n${data.afterDiscount == "0" ? data.totalAmount : data.afterDiscount!}.00",
                                                        size: 11.sp)),
                                              ])
                                            ],
                                          ),
                                          children: [
                                            ListView.builder(
                                              shrinkWrap: true,
                                              itemBuilder: (_, testIndex) {
                                                String filename = "p_${data.caseNo}";

                                                String testDateFormatted =
                                                PrintCaseEntry.GenerateDate(
                                                    dateCount: int.parse(
                                                        "${testDate[testIndex].replaceAll('[', "").replaceAll("]", "")}"),
                                                    casedate: data.caseDate!);

                                                return Container(
                                                  color: Colors.white,
                                                  child: Table(
                                                    children: [
                                                      TableRow(children: [
                                                        Center(
                                                            child: UiHelper.CustText(
                                                                text:
                                                                "${testIndex + 1}",
                                                                size: 14,
                                                                fontfamily:
                                                                'font-bold')),
                                                        Center(
                                                            child: UiHelper.CustText(
                                                                text:
                                                                "${data.slipNo}",
                                                                size: 14,
                                                                fontfamily:
                                                                'font-bold')),
                                                        Center(
                                                            child: UiHelper.CustText(
                                                                text: "${testName[testIndex].replaceAll('[', "").replaceAll("]", "")}",
                                                                size: 14,
                                                                fontfamily:
                                                                'font-bold')),
                                                        Center(child: UiHelper.CustText(text: testDateFormatted, size: 14, fontfamily: 'font-bold')),

                                                        // Status check and Action buttons combined
                                                        FutureBuilder<CheckReportState>(
                                                          future: _checkReportStatus(filename),
                                                          builder: (context, snapshot) {
                                                            bool isReady = false;
                                                            bool isLoading = snapshot.connectionState == ConnectionState.waiting;

                                                            if (snapshot.hasData && snapshot.data is CheckReportLoadedState) {
                                                              CheckReportLoadedState loadedState = snapshot.data as CheckReportLoadedState;
                                                              isReady = loadedState.checkReportPojo.status ?? false;
                                                            }

                                                            return Row(
                                                              children: [
                                                                // Status Column
                                                                Expanded(
                                                                  child: Center(
                                                                    child: isLoading
                                                                        ? SizedBox(
                                                                      width: 20,
                                                                      height: 20,
                                                                      child: CircularProgressIndicator(strokeWidth: 2),
                                                                    )
                                                                        : UiHelper.CustText(
                                                                      text: isReady ? "Ready" : "Pending",
                                                                      size: 14,
                                                                      fontfamily: 'font-bold',
                                                                      color: isReady ? Colors.green : Colors.orange,
                                                                    ),
                                                                  ),
                                                                ),
                                                                // Action Buttons Column
                                                                Expanded(
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                    children: [
                                                                      // Show Create Report button only if NOT ready
                                                                      if (!isReady && !isLoading)
                                                                        BlocConsumer<DocBloc, DocState>(
                                                                          listener: (context, state) {
                                                                            if (state is DocErrorState) {
                                                                              UiHelper.showErrorToste(message: state.errorMsg);
                                                                            }
                                                                            if (state is DocLoadedState) {
                                                                              var json = jsonDecode(state.fileUrl);
                                                                              String url = json['url'];
                                                                              openInOfficeOnline(url);

                                                                              // Clear loading state
                                                                              setState(() {
                                                                                loadingCaseNo = null;
                                                                                loadingTestIndex = null;
                                                                              });
                                                                            }
                                                                          },
                                                                          builder: (context, state) {
                                                                            bool isThisButtonLoading =
                                                                                state is DocLoadingState &&
                                                                                    loadingCaseNo == data.caseNo &&
                                                                                    loadingTestIndex == testIndex;

                                                                            if (isThisButtonLoading) {
                                                                              return Center(
                                                                                  child: SizedBox(
                                                                                    width: 20,
                                                                                    height: 20,
                                                                                    child: CircularProgressIndicator(
                                                                                      strokeWidth: 2,
                                                                                    ),
                                                                                  ));
                                                                            }

                                                                            return Center(
                                                                              child: Tooltip(
                                                                                message: "Create Report",
                                                                                child: IconButton(
                                                                                    onPressed: () async {
                                                                                      setState(() {
                                                                                        loadingCaseNo = data.caseNo;
                                                                                        loadingTestIndex = testIndex;
                                                                                      });

                                                                                      String main_file = testfile[testIndex]
                                                                                          .replaceAll('[', "")
                                                                                          .replaceAll("]", "");

                                                                                      DocCtrl.Doc(
                                                                                          context: context,
                                                                                          name: name,
                                                                                          date: date,
                                                                                          slipno: slipno,
                                                                                          age: age,
                                                                                          sex: sex,
                                                                                          referredby: referredby,
                                                                                          filename: filename,
                                                                                          mainfile: main_file);
                                                                                    },
                                                                                    icon: Icon(
                                                                                      Icons.list_alt,
                                                                                      color: Colors.blue.shade600,
                                                                                    )),
                                                                              ),
                                                                            );
                                                                          },
                                                                        ),

                                                                      // Show Download button only if ready
                                                                      if (isReady)
                                                                        Center(
                                                                          child: Tooltip(
                                                                            message: "Download Report",
                                                                            child: IconButton(
                                                                                onPressed: () async {
                                                                                  // Get the file URL and open in Office Online
                                                                                  String reportUrl = "https://dzda.in/DocApi/public/wordfiles/${filename}.docx";
                                                                                  openInOfficeOnline(reportUrl);
                                                                                },
                                                                                icon: Icon(
                                                                                  Icons.download,
                                                                                  color: Colors.green.shade600,
                                                                                )),
                                                                          ),
                                                                        ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          },
                                                        ),
                                                      ])
                                                    ],
                                                    border: TableBorder.all(
                                                        color: Colors.grey,
                                                        width: .5),
                                                    defaultVerticalAlignment:
                                                    TableCellVerticalAlignment
                                                        .middle,
                                                    columnWidths: {
                                                      0: FlexColumnWidth(1),
                                                      1: FlexColumnWidth(1.5),
                                                      2: FlexColumnWidth(7),
                                                      3: FlexColumnWidth(2),
                                                      4: FlexColumnWidth(3),
                                                    },
                                                  ),
                                                );
                                              },
                                              itemCount: testName.length,
                                            ),
                                            const SizedBox(height: 5)
                                          ],
                                        ),
                                      );
                                    },
                                    itemCount: 1,
                                  );
                                },
                                itemCount: state.caseListModel.caseList!.length,
                              );
                            }
                            return Container();
                          },
                        )
                      ],
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

  // Helper method to check report status asynchronously
  Future<CheckReportState> _checkReportStatus(String filename) async {
    final cubit = context.read<CheckReportCubit>();
    await cubit.checkReport(file: "${filename}.docx");
    return cubit.state;
  }

  //ONLY VIEW FILE IN BROWSER
  static void openInOfficeOnline(String fileUrl) {
    final onlineViewer =
        "https://view.officeapps.live.com/op/embed.aspx?src=$fileUrl";
    html.window.open(onlineViewer, "_blank");
  }

  static void openInMSWord(String fileUrl) {
    final wordUrl = "ms-word:ofe|u|$fileUrl";
    html.window.open(wordUrl, "_self");
  }
}