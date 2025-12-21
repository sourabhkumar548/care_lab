import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:care_lab_software/Controllers/CheckReportCtrl/check_report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:open_filex/open_filex.dart';
import 'package:sizer/sizer.dart';
import 'package:web/web.dart' as html;
import '../Controllers/CaseList/Cubit/case_list_cubit.dart';
import '../Controllers/DocCtrl/bloc/doc_bloc.dart';
import '../Controllers/DocCtrl/doc_ctrl.dart';
import '../Helpers/print_case_entry.dart';
import '../Helpers/uiHelper.dart';
import 'loginscreen.dart';

class Reporting extends StatefulWidget {
  Reporting({super.key});

  @override
  State<Reporting> createState() => _ReportingState();

  int flag = 0;
}

class _ReportingState extends State<Reporting> {

  TextEditingController searchCtrl = TextEditingController();
  ValueNotifier<String> searchQuery = ValueNotifier("");


  TextEditingController dateCtrl = TextEditingController(
      text: "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}");

  // Track loading for each specific report using a unique key
  Set<String> loadingReports = {};

  @override
  void initState() {
    super.initState();
    context.read<CaseListCubit>().getCaseList(
        date: dateCtrl.text,
        type: "Report"
    );
  }

  // Generate unique key for each report
  String _getReportKey(String caseNo, int testIndex) {
    return "${caseNo}_$testIndex";
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String accessCode = args["code"];

    if(accessCode != "/reporting_page"){

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LabLoginScreen()), (val)=>true);

    }

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Device.width < 1100 ?
      _buildMobileLayout() : _buildDesktopLayout(),
    );
  }

  Widget _buildMobileLayout() {
    return Center(
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 120,
            child: UiHelper.custHorixontalTab(container: "4", context: context),
          ),
          Container(
            height: Adaptive.h(100),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  _buildTopBar(),
                  SizedBox(height: 5),
                  _buildCaseList(isMobile: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout() {
    return Center(
      child: Row(
        children: [
          Container(
            width: Adaptive.w(15),
            child: UiHelper.custsidebar(container: "4", context: context),
          ),
          Container(
            width: Adaptive.w(85),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView(
                children: [
                  _buildTopBar(),
                  SizedBox(height: 5),

                  TextField(
                    controller: searchCtrl,
                    decoration: InputDecoration(
                      hintText: "Search Case No / Patient Name",
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      suffixIcon: IconButton(onPressed: (){searchCtrl.clear();searchQuery.value = "";}, icon: Icon(Icons.close))
                    ),
                    onChanged: (val) {
                      searchQuery.value = val.toLowerCase();
                    },
                  ),

                  SizedBox(height: 10),

                  _buildCaseList(isMobile: false),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return UiHelper.CustTopBar(
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
        ));
  }

  Widget _buildCaseList({required bool isMobile}) {
    return Column(
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

              return ValueListenableBuilder<String>(
                valueListenable: searchQuery,
                builder: (context, query, _) {

                  final filteredList = state.caseListModel.caseList!.where((caseData) {

                    final caseNo =
                        caseData.caseNo?.toLowerCase() ?? "";

                    final patient =
                        caseData.patientName?.toLowerCase() ?? "";

                    final mobile =
                        caseData.mobile?.toLowerCase() ?? "";

                    final tests = caseData.items!
                        .map((e) => e.testName ?? "")
                        .join(",")
                        .toLowerCase();

                    return caseNo.contains(query) ||
                        patient.contains(query) ||
                        mobile.contains(query) ||
                        tests.contains(query);

                  }).toList();

                  if (filteredList.isEmpty) {
                    return Center(
                      child: UiHelper.CustText(
                        text: "No matching records found",
                        size: 12.sp,
                      ),
                    );
                  }

                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: filteredList.length,
                    itemBuilder: (_, index) {
                      return _buildCaseItem(
                        filteredList[index],
                        index,
                        isMobile,
                      );
                    },
                  );
                },
              );
            }

            return Container();
          },
        )
      ],
    );
  }

  Widget _buildCaseItem(dynamic mainData, int index, bool isMobile) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (_, idx) {
        var data = mainData.items![idx];
        List<String> testName = data.testName!.split(",");
        List<String> testDate = data.testDate!.split(",");
        List<String> testfile = data.testFile!.split(",");

        String name = data.patientName!;
        String date = data.date!;
        String slipno = data.caseNo!;
        String age = "${data.year!} Y ${data.month! == "0" ? "" : "${data.month}M"} ";
        String sex = data.gender!;
        String referredby = data.doctor!;

        return Container(
          margin: EdgeInsets.only(bottom: 5),
          color: index % 2 == 0 ? Colors.grey.shade200 : Colors.white70,
          child: ExpansionTile(
            title: _buildCaseHeader(data, isMobile),
            children: [
              ListView.builder(
                shrinkWrap: true,
                itemBuilder: (_, testIndex) {
                  String filename = "p_${data.caseNo}${testName[testIndex].replaceAll('[', "").replaceAll("]", "")}";
                  String testDateFormatted = PrintCaseEntry.GenerateDate(
                      dateCount: int.parse(
                          "${testDate[testIndex].replaceAll('[', "").replaceAll("]", "")}"),
                      casedate: data.caseDate!);

                  return _buildTestRow(
                    data: data,
                    testIndex: testIndex,
                    testName: testName,
                    testfile: testfile,
                    filename: filename,
                    testDateFormatted: testDateFormatted,
                    name: name,
                    date: date,
                    slipno: slipno,
                    age: age,
                    sex: sex,
                    referredby: referredby,
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
  }

  Widget _buildCaseHeader(dynamic data, bool isMobile) {
    return Table(
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
                  text: "Case No \n${data.caseNo!}",
                  size: isMobile ? 12.sp : 11.sp)),
          Center(
              child: UiHelper.CustText(
                  text: "Case Date \n${data.caseDate!}",
                  size: isMobile ? 12.sp : 11.sp)),
          UiHelper.CustText(
              text: "Patient Name : \n${data.patientName!}",
              size: isMobile ? 12.sp : 11.sp),
          UiHelper.CustText(
              text: "Doctor Name : \n${data.doctor!}",
              size: isMobile ? 12.sp : 11.sp),
          Center(
              child: UiHelper.CustText(
                  text: "Bill Amount \n${data.afterDiscount == "0" ? data.totalAmount : data.afterDiscount!}.00",
                  size: isMobile ? 12.sp : 11.sp)),
        ])
      ],
    );
  }

  Widget _buildTestRow({
    required dynamic data,
    required int testIndex,
    required List<String> testName,
    required List<String> testfile,
    required String filename,
    required String testDateFormatted,
    required String name,
    required String date,
    required String slipno,
    required String age,
    required String sex,
    required String referredby,
  }) {
    String reportKey = _getReportKey(data.caseNo!, testIndex);

    return Container(
      color: Colors.white,
      child: Table(
        children: [
          TableRow(children: [
            Center(
                child: UiHelper.CustText(
                    text: "${testIndex + 1}",
                    size: 14,
                    fontfamily: 'font-bold')),
            Center(
                child: UiHelper.CustText(
                    text: "${data.slipNo}",
                    size: 14,
                    fontfamily: 'font-bold')),
            Center(
                child: UiHelper.CustText(
                    text: "${testName[testIndex].replaceAll('[', "").replaceAll("]", "")}",
                    size: 14,
                    fontfamily: 'font-bold')),
            Center(
                child: UiHelper.CustText(
                    text: testDateFormatted,
                    size: 14,
                    fontfamily: 'font-bold')),
            FutureBuilder<CheckReportState>(
              future: _checkReportStatus(filename),
              builder: (context, snapshot) {
                bool isReady = false;
                bool isCheckingStatus = snapshot.connectionState == ConnectionState.waiting;

                if (snapshot.hasData && snapshot.data is CheckReportLoadedState) {
                  CheckReportLoadedState loadedState = snapshot.data as CheckReportLoadedState;
                  isReady = loadedState.checkReportPojo.status ?? false;
                }

                // Check if THIS specific report is being created
                bool isCreatingReport = loadingReports.contains(reportKey);

                return Row(
                  children: [
                    // Status Column


                    Expanded(
                      child: Center(
                        child: isCheckingStatus
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
                          if (!isReady && !isCheckingStatus)
                            BlocListener<DocBloc, DocState>(
                              listener: (context, state) {
                                // Only handle events for THIS specific report
                                if (!loadingReports.contains(reportKey)) return;

                                if (state is DocErrorState) {
                                  UiHelper.showErrorToste(message: state.errorMsg);
                                  setState(() {
                                    loadingReports.remove(reportKey);
                                  });
                                }
                                if (state is DocLoadedState) {
                                  var json = jsonDecode(state.fileUrl);
                                  String url = json['url'];
                                  // openInOfficeOnline(url);
                                  openInMSWord(url);

                                  setState(() {
                                    loadingReports.remove(reportKey);
                                  });
                                }
                              },
                              child: Center(
                                child: isCreatingReport
                                    ? SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                    : Tooltip(
                                  message: "Create Report",
                                  child: IconButton(
                                      onPressed: () async {
                                        setState(() {
                                          loadingReports.add(reportKey);
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
                              ),
                            ),

                          // Show Download button only if ready
                          if (isReady)
                            Center(
                              child: Tooltip(
                                message: "Download Report",
                                child: IconButton(
                                    onPressed: () async {
                                      String reportUrl = "https://dzda.in/DocApi/public/wordfiles/${filename}.docx";
                                      // openInOfficeOnline(reportUrl);
                                      openInMSWord(reportUrl);
                                    },
                                    icon: Icon(
                                      Icons.download,
                                      color: Colors.green.shade600,
                                    )),
                              ),
                            ),

                          if (isReady)
                            Center(
                              child: Tooltip(
                                message: "Open Report",
                                child: IconButton(
                                    onPressed: () async {
                                      String reportUrl = "${filename}.docx";

                                      String filePath = 'D:\\$filename.docx';

                                      final file = File(filePath);

                                      if (await file.exists()) {
                                        final result = await OpenFilex.open(filePath);
                                        print(result.type);
                                      } else {
                                        print('File not found!');
                                      }

                                    },
                                    icon: Icon(
                                      Icons.open_in_browser_sharp,
                                      color: Colors.orangeAccent,
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
        border: TableBorder.all(color: Colors.grey, width: .5),
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        columnWidths: {
          0: FlexColumnWidth(1),
          1: FlexColumnWidth(1.5),
          2: FlexColumnWidth(7),
          3: FlexColumnWidth(2),
          4: FlexColumnWidth(3),
        },
      ),
    );
  }

  Future<CheckReportState> _checkReportStatus(String filename) async {
    final cubit = context.read<CheckReportCubit>();
    await cubit.checkReport(file: "${filename}.docx");
    return cubit.state;
  }

  static void openInOfficeOnline(String fileUrl) {
    final encodedUrl = Uri.encodeComponent(fileUrl);

    final officeEditorUrl =
        "https://www.office.com/launch/word?src=$encodedUrl";

    html.window.open(officeEditorUrl, "_blank");
  }

  static void openInMSWord(String fileUrl) {
    final wordUrl = "ms-word:ofe|u|$fileUrl";
    html.window.open(wordUrl, "_self");
  }
}