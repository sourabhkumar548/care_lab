import 'dart:math';

import 'package:care_lab_software/Controllers/RoportCtrl/report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import '../Controllers/CaseEntryCtrl/Bloc/case_entry_bloc.dart';
import '../Controllers/CaseEntryCtrl/Controller/caseentryctrl.dart';
import '../Helpers/case_entry_data.dart';
import '../Helpers/print_case_entry.dart';
import '../Helpers/uiHelper.dart';
import 'loginscreen.dart';

class SearchReportScreen extends StatefulWidget {
  const SearchReportScreen({super.key});

  @override
  State<SearchReportScreen> createState() => _SearchReportScreenState();
}

class _SearchReportScreenState extends State<SearchReportScreen> {

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  // Pagination variables
  int _currentPage = 1;
  int _itemsPerPage = 20;
  int _totalPages = 1;

  static List<Map<String, dynamic>> pay_status = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _goToPage(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  void _changeItemsPerPage(int items) {
    setState(() {
      _itemsPerPage = items;
      _currentPage = 1; // Reset to first page when changing items per page
    });
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String accessCode = args["code"];

    if(accessCode != "/search_report"){

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
              height: 120,
              child: UiHelper.custHorixontalTab(container: "22",context: context,),
            ),
            //MAIN CONTENT
            Container(
              height: Adaptive.h(100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Search Patient Report",widget: _buildSearchBar(),),
                    const SizedBox(height: 20,),
                    _reportData()
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
              child: UiHelper.custsidebar(container: "22",context: context,),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Search Patient Report",widget: _buildSearchBar(),),

                    const SizedBox(height: 20,),

                    _reportData()

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      width: 400,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
        border: BoxBorder.all(color: Colors.green),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: "Search by Patient Name or Case No...",
          hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 11.sp),
          border: InputBorder.none,
          prefixIcon: Icon(Icons.search, color: Colors.blue.shade700),
          suffixIcon: _searchQuery.isNotEmpty
              ? IconButton(
            icon: Icon(Icons.clear, color: Colors.grey.shade600),
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = "";
                _currentPage = 1; // Reset to first page
              });
            },
          )
              : null,
        ),
        onChanged: (value) {
          setState(() {
            _searchQuery = value.toLowerCase();
            _currentPage = 1; // Reset to first page on search
          });
        },
      ),
    );
  }

  Widget _buildPaginationControls(int totalItems) {
    _totalPages = (totalItems / _itemsPerPage).ceil();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Items per page selector
          Row(
            children: [
              Text("Show: ", style: TextStyle(fontSize: 11.sp)),
              DropdownButton<int>(
                value: _itemsPerPage,
                items: [10, 20, 50, 100].map((int value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(value.toString()),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) _changeItemsPerPage(value);
                },
              ),
              const SizedBox(width: 10),
              Text(
                "Showing ${(_currentPage - 1) * _itemsPerPage + 1}-${min(_currentPage * _itemsPerPage, totalItems)} of $totalItems",
                style: TextStyle(fontSize: 10.sp, color: Colors.grey.shade700),
              ),
            ],
          ),

          // Page navigation
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.first_page, color: _currentPage > 1 ? Colors.blue : Colors.grey),
                onPressed: _currentPage > 1 ? () => _goToPage(1) : null,
              ),
              IconButton(
                icon: Icon(Icons.chevron_left, color: _currentPage > 1 ? Colors.blue : Colors.grey),
                onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
              ),

              // Page numbers
              ..._buildPageNumbers(),

              IconButton(
                icon: Icon(Icons.chevron_right, color: _currentPage < _totalPages ? Colors.blue : Colors.grey),
                onPressed: _currentPage < _totalPages ? () => _goToPage(_currentPage + 1) : null,
              ),
              IconButton(
                icon: Icon(Icons.last_page, color: _currentPage < _totalPages ? Colors.blue : Colors.grey),
                onPressed: _currentPage < _totalPages ? () => _goToPage(_totalPages) : null,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers() {
    List<Widget> pageNumbers = [];
    int startPage = max(1, _currentPage - 2);
    int endPage = min(_totalPages, _currentPage + 2);

    for (int i = startPage; i <= endPage; i++) {
      pageNumbers.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: InkWell(
            onTap: () => _goToPage(i),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: i == _currentPage ? Colors.blue : Colors.transparent,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.blue),
              ),
              child: Text(
                i.toString(),
                style: TextStyle(
                  color: i == _currentPage ? Colors.white : Colors.blue,
                  fontWeight: i == _currentPage ? FontWeight.bold : FontWeight.normal,
                  fontSize: 10.sp,
                ),
              ),
            ),
          ),
        ),
      );
    }
    return pageNumbers;
  }

  Widget _reportData(){

    return Column(
      children: [
        Table(
          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
          columnWidths: const {
            0: FlexColumnWidth(.5), // Case No
            1: FlexColumnWidth(.5), // Case Date
            2: FlexColumnWidth(.7), // Patient Name
            3: FlexColumnWidth(2), // Patient Mobile
            4: FlexColumnWidth(.8), // Test Name
            5: FlexColumnWidth(3.5), //Test File
            6: FlexColumnWidth(1), //Test File
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.blueAccent,),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Sl No",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Case No",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Case Date",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Patient Name",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Patient Mobile",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Test Name",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Action",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                )
              ],
            ),
          ],
        ),
        BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            if(state is ReportLoadingState){
              return Center(child: CircularProgressIndicator());
            }
            if(state is ReportErrorState){
              return Center(child: UiHelper.CustText(text: state.errorMsg,color: Colors.red,size: 12.sp),);
            }
            if(state is ReportLoadedState){
              // Filter the reports based on search query
              var filteredReports = state.reportModel.report!.where((report) {
                if (_searchQuery.isEmpty) return true;

                final patientName = report.patientName?.toLowerCase() ?? "";
                final caseNo = report.caseNo?.toString().toLowerCase() ?? "";

                return patientName.contains(_searchQuery) || caseNo.contains(_searchQuery);
              }).toList();

              if (filteredReports.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Center(
                    child: UiHelper.CustText(
                        text: "No reports found matching your search",
                        color: Colors.grey.shade700,
                        size: 12.sp
                    ),
                  ),
                );
              }

              // Calculate pagination
              int totalItems = filteredReports.length;
              int startIndex = (_currentPage - 1) * _itemsPerPage;
              int endIndex = min(startIndex + _itemsPerPage, totalItems);
              var paginatedReports = filteredReports.sublist(startIndex, endIndex);

              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemBuilder: (_,index){
                      var data = paginatedReports[index];
                      int actualIndex = startIndex + index; // Calculate actual index for serial number

                      pay_status.add({
                        "case_no": data.caseNo,
                        "status": data.balance == "0" || data.balance == ".00" || data.balance == "0.00"  ? "Paid" : "Due"
                      });

                      String balance = data.balance!.replaceFirst(RegExp(r"^0"), "");
                      String advance = data.advance!.replaceFirst(RegExp(r"^0"), "");

                      String? status = pay_status
                          .firstWhere((element) => element["case_no"] == data.caseNo,
                        orElse: () => {},
                      )["status"];

                      return Column(children: [
                        Table(
                          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                          columnWidths: const {
                            0: FlexColumnWidth(.5), // Case No
                            1: FlexColumnWidth(.5), // Case Date
                            2: FlexColumnWidth(.7), // Patient Name
                            3: FlexColumnWidth(2), // Patient Mobile
                            4: FlexColumnWidth(.8), // Test Name
                            5: FlexColumnWidth(3.5), //Test File
                            6: FlexColumnWidth(1), //amount paid
                          },
                          children: [
                            TableRow(
                              decoration: BoxDecoration(color: index % 2 == 0 ? Colors.green.shade100 : Colors.grey.shade100),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text("${actualIndex+1}",style: TextStyle(color: Colors.black,fontSize: 11.sp,),textAlign: TextAlign.center,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text("${data.caseNo}",style: TextStyle(color: Colors.black,fontSize: 11.sp,),textAlign: TextAlign.center,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  child: Text("${data.caseDate}",style: TextStyle(color: Colors.black,fontSize: 11.sp,),textAlign: TextAlign.center,),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8,top: 8),
                                  child: Text("${data.patientName}",style: TextStyle(color: Colors.black,fontSize: 11.sp,)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                                  child: Text("${data.mobile == "0" ? "Not Mention" : data.mobile}",style: TextStyle(color: Colors.black,fontSize: 11.sp,)),
                                ),
                                InkWell(
                                  onTap : (){},
                                  child: ListTile(
                                    title: Text("* ${data.testName!.replaceAll("[", "").replaceAll("]", "").replaceAll(",", "\n*")}",style: TextStyle(color: Colors.black,fontSize: 11.sp,)),
                                  ),
                                ),

                                status == "Due" ? Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                                  child: InkWell(
                                    onTap : (){
                                      status == "Due" ? showCaseDialog(context: context, case_no: data.caseNo!,case_date: data.caseDate!,case_time: data.time!, patient_name: data.patientName!, year: data.year!, month: data.month!, gender: data.gender!, mobile: data.mobile!, child_male: "0", child_female: "0", address: data.address!, agent: data.agent!, doctor: data.doctor!, test_name: data.testName!, test_rate: data.testRate!, total_amount: data.totalAmount!, discount: data.discount!, after_discount: data.afterDiscount!, advance: advance, balance: balance!, discount_type: data.discountType!,test_date: data.testDate!, test_file: data.testFile!, narration: data.narration!, name_title: data.nameTitle!)
                                          : UiHelper.showSuccessToste(message: "Full Payment Already Paid",heading: "Payment Already Paid");
                                    },
                                    child: Card(
                                      color: Colors.green.shade300,
                                      child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: UiHelper.CustText(text: "Due Paid",color: Colors.black,fontweight: FontWeight.bold),
                                          )
                                      ),
                                    ),
                                  ),
                                ) : Center(child: UiHelper.CustText(text: "Payment Already Paid",color: Colors.red.shade900,fontweight: FontWeight.bold))
                              ],
                            ),
                          ],
                        ),
                      ],);
                    },
                    itemCount: paginatedReports.length,
                  ),

                  const SizedBox(height: 20),

                  // Pagination controls
                  _buildPaginationControls(totalItems),
                ],
              );
            }
            return Container();
          },
        ),
      ],
    );

  }

  static void showCaseDialog({required BuildContext context,
    required String case_date,
    required String case_no,
    required String case_time,
    required String patient_name,
    required String year,
    required String month,
    required String gender,
    required String mobile,
    required String child_male,
    required String child_female,
    required String address,
    required String agent,
    required String doctor,
    required String test_name,
    required String test_rate,
    required String total_amount,
    required String discount,
    required String after_discount,
    required String advance,
    required String balance,
    required String discount_type,
    required String test_date,
    required String test_file,
    required String narration,
    required String name_title
  })
  {
    TextEditingController paidCtrl = TextEditingController(text: balance);
    String PayMode = "Cash";
    List<String> testName = test_name.split(",");
    List<String> testRate = test_rate.split(",");
    List<String> testDate = test_date.split(",");

    final twoDigitYear = (DateTime.now().year % 100).toString().padLeft(2, '0');
    Random data = Random();
    String receiptNo = "${data.nextInt(99999)}/${twoDigitYear}-${int.parse(twoDigitYear.toString())+1}";

    GetStorage box = GetStorage();
    String receivedBy = box.read("newUser");

    String newTime = "${DateTime.now().hour.toString()}:${DateTime.now().minute.toString()}";
    String newDate = "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: SizedBox(
            width: Adaptive.w(40),
            height: Adaptive.h(40),
            child: Column(children: [

              Container(child: Column(children: [
                UiHelper.CustText(
                  text: "CARE DIAGNOSTIC CENTRE",
                  size: 12.sp,
                  fontfamily: 'font-regular',
                ),
                SizedBox(height: .5.h),
                UiHelper.CustText(
                  text: "NAYA BAZAR, NEAR GAYA PUL, DHANBAD - 826001",
                  size: 11.sp,
                  maxline: 3,
                ),
                SizedBox(height: .5.h),
                UiHelper.CustText(
                  text: "PH : 9708035306, 9708046999   |   Email : cdc.dhn@gmail.com",
                  size: 11.sp,
                  maxline: 3,
                ),
                SizedBox(height: .5.h),
                Divider()
              ],),),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UiHelper.CustText(text: "Case No: $case_no",size: 11.sp,color: Colors.black),
                  UiHelper.CustText(text: "Case Date: $case_date",size: 11.sp,color: Colors.black),
                ],),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UiHelper.CustText(text: "Patient Name: $patient_name",size: 11.sp,color: Colors.black),
                  UiHelper.CustText(text: "Mobile: $mobile",size: 11.sp,color: Colors.black),
                ],),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UiHelper.CustText(text: after_discount == "0" ? "Total Amount : ${total_amount.replaceFirst(RegExp(r"^0"), "")}.00" : "Total Amount : ${after_discount.replaceFirst(RegExp(r"^0"), "")}.00",size: 11.sp,color: Colors.black),
                  UiHelper.CustText(text: balance == ".00" || balance == "0" || balance == "" ? "Advance: 0.00" : "Advance: ${advance.replaceFirst(RegExp(r"^0"), "")}.00",size: 11.sp,color: Colors.black),
                ],),
              const SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  UiHelper.CustText(text: balance == ".00" || balance == "0" || balance == "" ? "Balance Amount: 0.00" : "Balance Amount: ${balance.replaceFirst(RegExp(r"^0"), "")}.00",size: 12.sp,color: Colors.green),
                  UiHelper.CustText(text:
                  advance == "0"
                      ? after_discount == "0" ? "Billed Amount : ${total_amount.replaceFirst(RegExp(r"^0"), "")}.00" : "Billed Amount : ${after_discount.replaceFirst(RegExp(r"^0"), "")}.00"
                      : "Billed Amount : ${advance.replaceFirst(RegExp(r"^0"), "")}.00",
                      size: 11.sp),
                ],),

              balance == ".00" || balance == "0" || balance == ""
                  ? Padding(
                padding: const EdgeInsets.only(top: 30,bottom: 20),
                child: Container(
                    padding: EdgeInsets.all(10),
                    color: Colors.green,
                    child: UiHelper.CustText(text: "Full payment has already paid successfully",color: Colors.white,size: 13.sp)),
              )
                  : Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      UiHelper.CustDropDown(
                          label: "Pay Mode",
                          defaultValue: "Cash",
                          list: CaseEnteryData.payList,
                          onChanged: (val){
                            PayMode = val!;
                          }
                      ),
                      const SizedBox(width: 20,),
                      UiHelper.CustTextField(controller: paidCtrl, label: "Bill Amount",icon: Icon(Icons.money))
                    ],)

                ],),
              )

            ],),
          ),
          actions: [

            BlocConsumer<CaseEntryBloc, CaseEntryState>(
              listener: (context, state) {
                if(state is CaseEntryLoadedState){



                  UiHelper.showSuccessToste(message: "Bill Paid Successfully");
                  PrintCaseEntry.printBill(receiptNo: receiptNo,
                      receiptDate: "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}",
                      caseNo: case_no,
                      caseDate: newDate,
                      caseTime: newTime,
                      patientName: patient_name,
                      mobile: mobile,
                      sex: gender,
                      age: "${year} Y ${month} M",
                      referredBy: doctor,
                      testName: testName,
                      testRate: testRate,
                      date: case_date,
                      totalAmount: after_discount,
                      discountAmount: after_discount,
                      balanceAmount: "${int.parse(paidCtrl.text) - int.parse(balance)}",
                      advanceAmount: advance,
                      receivedBy: receivedBy,
                      testDate: testDate
                  );
                }
                if(state is CaseEntryErrorState){
                  UiHelper.showErrorToste(message: state.errorMessage);
                }
              },
              builder: (context, state) {
                if(state is CaseEntryLoadingState){
                  return Center(child: CircularProgressIndicator());
                }
                return balance == ".00" || balance == "0" || balance == "" ? Container() : ElevatedButton(onPressed: (){

                  String pay_status = balance == paidCtrl.text ? "Paid" : "Due";

                  String adv =
                  balance == ".00" || balance == "0" || balance.isEmpty
                      ? advance
                      : "${(int.tryParse(advance) ?? 0) + (int.tryParse(paidCtrl.text) ?? 0)}";



                  CaseEntryCtrl.CaseEntry(type : "Repayment",context : context,case_date: case_date, time: newTime, date: newDate, case_no: case_no, slip_no: receiptNo, received_by: receivedBy, patient_name: patient_name, year: year, month: month, gender: gender, mobile: mobile, child_male: child_male, child_female: child_female, address: address, agent: agent, doctor: doctor, test_name: test_name, test_rate: test_rate, total_amount: total_amount, discount: discount, after_discount: after_discount, advance: adv, balance: "${double.parse(balance) - double.parse(paidCtrl.text)}",paid_amount: paidCtrl.text,pay_status: pay_status, pay_mode: PayMode, discount_type: discount_type,test_date: test_date,test_file: test_file,narration: narration,name_title: name_title);


                }, child: UiHelper.CustText(text: "Pay Now",fontfamily: 'font-bold',size: 12.sp,color: Colors.green),);
              },
            ),
            TextButton(
              onPressed: () =>Navigator.pushReplacementNamed(context, '/search_report',arguments: {"code" : "/search_report"}),
              child: UiHelper.CustText(text: "Close",fontfamily: 'font-bold',size: 12.sp,color: Colors.red),
            ),

          ],
        );
      },
    );
  }


}