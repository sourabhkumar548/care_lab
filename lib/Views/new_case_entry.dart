import 'dart:math';
import 'package:care_lab_software/Helpers/get_doctor_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import '../Controllers/CaseEntryCtrl/Bloc/case_entry_bloc.dart';
import '../Controllers/CaseEntryCtrl/Controller/caseentryctrl.dart';
import '../Controllers/CaseNumberCtrl/Cubit/case_number_cubit.dart';
import '../Helpers/case_entry_data.dart';
import '../Helpers/print_case_entry.dart';
import '../Helpers/ratedialog.dart';
import '../Helpers/uiHelper.dart';

class NewCaseEntry extends StatefulWidget {
  const NewCaseEntry({super.key});

  @override
  State<NewCaseEntry> createState() => _NewCaseEntryState();
}

class _NewCaseEntryState extends State<NewCaseEntry> {
  List<Map<String, dynamic>> selectedTests = [];
  String SelectedGender = "Male";
  String PayMode = "Cash";
  String DiscountType = "Self";
  final twoDigitYear = (DateTime.now().year % 100).toString().padLeft(2, '0');
  Random data = Random();

  // Controllers
  TextEditingController timeCtrl = TextEditingController(
      text: "${DateTime.now().hour}:${DateTime.now().minute}");
  TextEditingController dateCtrl = TextEditingController(
      text:
      "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
  TextEditingController caseNoCtrl = TextEditingController();
  TextEditingController slipNoCtrl = TextEditingController();
  TextEditingController receivedByCtrl = TextEditingController();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController mobileCtrl = TextEditingController();
  TextEditingController addressCtrl = TextEditingController();
  TextEditingController agentCtrl = TextEditingController(text: "Self");
  TextEditingController doctorCtrl = TextEditingController(text: "Self");

  // Billing Controllers
  TextEditingController totalCtrl = TextEditingController(text: "0");
  TextEditingController discountCtrl = TextEditingController(text: "0");
  TextEditingController afterdiscountCtrl = TextEditingController(text: "0");
  TextEditingController advanceCtrl = TextEditingController(text: "0");
  TextEditingController balanceCtrl = TextEditingController(text: "0");
  TextEditingController discountTypeCtrl = TextEditingController(text: "None");

  // Age Controllers
  TextEditingController yearCtrl = TextEditingController();
  TextEditingController monthCtrl = TextEditingController();
  TextEditingController narrationCtrl = TextEditingController();
  TextEditingController nametitleCtrl = TextEditingController();

  RxDouble paidAmount = 0.0.obs;

  @override
  void initState() {
    super.initState();
    GetStorage userBox = GetStorage();
    String User = userBox.read("newUser") ?? "";
    receivedByCtrl.text = User;

    context.read<CaseNumberCubit>().getCaseNumber();

    // Initialize billing

    updateBilling();
  }

  double total = 0;
  double discountAmount = 0;
  double advance = 0;
  double afterDiscount = 0;
  double balance = 0;

  void updateBilling() {
    total = AddTestDialogState.totalAmount;

    // discount is directly in rupees now
    discountAmount = double.tryParse(discountCtrl.text) ?? 0;

    afterDiscount = total - discountAmount;
    advance = double.tryParse(advanceCtrl.text) ?? 0;

    if(advance != 0){
      balance = afterDiscount - advance;
    }else{
      balance = 0;
    }

    totalCtrl.text = total.toStringAsFixed(2);
    afterdiscountCtrl.text = afterDiscount.toStringAsFixed(2);
    balanceCtrl.text = balance.toStringAsFixed(2);

    paidAmount.value = advance > 0 ? advance : afterDiscount;
  }

  @override
  Widget build(BuildContext context) {
    String receiptNo =
        "${data.nextInt(99999)}/${twoDigitYear}-${int.parse(twoDigitYear) + 1}";
    slipNoCtrl.text = receiptNo;

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Device.width < 1100 ?

      Center(
        child: ListView(
          shrinkWrap: true,
          children: [
            // Side Bar

            Container(
              height: 120,
              child: UiHelper.custHorixontalTab(container: "2", context: context),),


            BlocListener<CaseNumberCubit, CaseNumberState>(
              listener: (context, state) {
                if (state is CaseNumberLoadedState) {
                  final nextCaseNumber = int.parse(state.CaseNumber) + 1;
                  caseNoCtrl.text = nextCaseNumber.toString().padLeft(4, '0');
                }
              },
              child: SizedBox.shrink(),
            ),

            // Main Content
            Container(
              height: Adaptive.h(100),
              width: Device.width < 1100 ? 100.w :85.w,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "CASE ENTRY"),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        // Case Information
                        Container(
                          width: 30.w,
                          child: UiHelper.Custcard(
                            title: "Case Information",
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    UiHelper.CustTextField(
                                        controller: timeCtrl,
                                        enabled: false,
                                        label: "Time"),
                                    const SizedBox(width: 5),
                                    UiHelper.CustTextField(
                                        controller: dateCtrl,
                                        enabled: false,
                                        label: "Date"),
                                    const SizedBox(width: 5),
                                    UiHelper.CustTextField(
                                        controller: caseNoCtrl,
                                        label: "Case No",
                                        enabled: false),
                                    const SizedBox(width: 5),
                                    UiHelper.CustTextField(
                                        controller: slipNoCtrl,
                                        label: "Slip No",
                                        enabled: false),
                                    const SizedBox(width: 5),
                                    UiHelper.CustTextField(
                                        controller: receivedByCtrl,
                                        label: "Received By",
                                        enabled: false),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),

                        // Patient Details
                        UiHelper.Custcard(
                          title: "Patient Details",
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: TextField(
                                      controller: nametitleCtrl,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: "Title",
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
                                        labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 12.sp),
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: nameCtrl,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: "Patient Name",
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
                                        labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 12.sp),
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 15),
                              Row(children: [
                                Expanded(
                                  child: TextField(
                                    controller: yearCtrl,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        labelText: "Year",
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
                                        labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 12.sp),
                                        prefixIcon: Icon(Icons.calendar_month),
                                        suffixIcon: IconButton(onPressed: ()=>UiHelper.CustEditableDropDown(context, (data)=>yearCtrl.text=data,CaseEnteryData.yearList), icon: Icon(Icons.arrow_drop_down_circle_outlined))

                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: monthCtrl,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        labelText: "Month",
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
                                        labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 12.sp),
                                        prefixIcon: Icon(Icons.calendar_month),
                                        suffixIcon: IconButton(onPressed: ()=>UiHelper.CustEditableDropDown(context, (data)=>monthCtrl.text=data,CaseEnteryData.monthList), icon: Icon(Icons.arrow_drop_down_circle_outlined))

                                    ),
                                  ),
                                ),
                              ],),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  UiHelper.CustDropDown(
                                      label: "Gender",
                                      defaultValue: SelectedGender,
                                      list: CaseEnteryData.genderList,
                                      icon: Icon(Icons.male),
                                      onChanged: (val) {
                                        SelectedGender = val!;
                                      }),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: mobileCtrl,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: "Mobile No",
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
                                        labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 12.sp),
                                        prefixIcon: Icon(Icons.phone),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: addressCtrl,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: "Patient Address",
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
                                        labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 12.sp),
                                        prefixIcon: Icon(Icons.location_history),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Doctors & Agents
                    Container(
                      width: Adaptive.w(85),
                      child: UiHelper.Custcard(
                        title: "Doctors & Agents",
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: agentCtrl,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    labelText: "Enter Agent Name",
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
                                    prefixIcon: Icon(Icons.person),
                                    suffixIcon: IconButton(onPressed: ()=>UiHelper.CustEditableDropDown(context, (data)=>agentCtrl.text=data,CaseEnteryData.agentList), icon: Icon(Icons.arrow_drop_down_circle_outlined))

                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: DoctorInputField(
                                controller: doctorCtrl,
                                initialValue: "Self",
                                onDoctorSelected: (doctor) {
                                  setState(() {
                                    doctorCtrl.text = doctor;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Tests & Billing
                    ListView(
                      shrinkWrap: true,
                      children: [
                        // Tests List
                        Container(
                          width: 42.5.w,
                          child: UiHelper.Custcard(
                            title: "Tests List",
                            trailing: TextButton(
                              onPressed: () async {
                                var result = await showDialog(
                                  context: context,
                                  builder: (_) => AddTestDialog(),
                                );
                                if (result != null) {
                                  setState(() {
                                    selectedTests = result;
                                    updateBilling();
                                  });
                                }
                              },
                              child: Text("Add Test"),
                            ),
                            child: Column(
                              children: [
                                Divider(),

                                ...selectedTests.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  var item = entry.value;

                                  return Card(
                                    color: Colors.grey.shade100,
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      leading: UiHelper.CustText(text: "${index + 1} : "),
                                      title: UiHelper.CustText(text: item['Test Name']),

                                      /// ✅ Only ONE trailing widget
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          UiHelper.CustText(text: "${item['Test Rate']}"),
                                          SizedBox(width: 8),
                                          IconButton(
                                            icon: Icon(Icons.close, color: Colors.red),
                                            onPressed: () {
                                              setState(() {
                                                selectedTests.removeAt(index);
                                                AddTestDialogState.totalAmount -=
                                                    double.parse(item['Test Rate'].toString());
                                                updateBilling();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),

                              ],
                            ),
                          ),
                        ),


                        // Billing Summary
                        Container(
                          width: 42.5.w,
                          child: UiHelper.Custcard(
                            title: "Billing Summary",
                            child: Column(
                              children: [
                                // Total & Discount
                                Row(
                                  children: [
                                    UiHelper.CustTextField(
                                      controller: totalCtrl,
                                      label: "Total Amount",
                                      enabled: false,
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        controller: discountCtrl,
                                        decoration: InputDecoration(
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
                                            prefixIcon: Icon(Icons.discount),
                                            labelText: "Discount (₹)"), // <-- Changed
                                        keyboardType: TextInputType.number,
                                        onChanged: (_) {
                                          updateBilling();
                                        },
                                      ),
                                    ),

                                  ],
                                ),

                                SizedBox(height: 15),

                                // After Discount & Advance
                                Row(
                                  children: [
                                    UiHelper.CustTextField(
                                      controller: afterdiscountCtrl,
                                      label: "Amount After Discount",
                                      enabled: false,
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        controller: advanceCtrl,
                                        decoration: InputDecoration(
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
                                            prefixIcon: Icon(Icons.money),
                                            labelText: "Advance Amount"),
                                        keyboardType: TextInputType.number,
                                        onChanged: (_) {
                                          updateBilling();
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 15),

                                // Balance & Pay Mode
                                Row(
                                  children: [
                                    UiHelper.CustTextField(
                                      controller: balanceCtrl,
                                      label: "Balance Amount",
                                      enabled: false,
                                    ),
                                    SizedBox(width: 20),
                                    UiHelper.CustDropDown(
                                      label: "Pay Mode",
                                      defaultValue: PayMode,
                                      list: CaseEnteryData.payList,
                                      onChanged: (val) {
                                        PayMode = val!;
                                      },
                                    ),
                                  ],
                                ),

                                SizedBox(height: 15),

                                // Paid Amount Display
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: discountTypeCtrl,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            labelText: "Enter Discount Type",
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
                                            prefixIcon: Icon(Icons.local_hospital),
                                            suffixIcon: IconButton(onPressed: ()=>UiHelper.CustEditableDropDown(context, (data)=>discountTypeCtrl.text=data,CaseEnteryData.discountTypeList), icon: Icon(Icons.arrow_drop_down_circle_outlined))

                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    UiHelper.CustTextField(controller: narrationCtrl, label: "Enter Narration")

                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    BlocConsumer<CaseEntryBloc, CaseEntryState>(
                                      listener: (context, state) {
                                        if(state is CaseEntryLoadedState){

                                          List<String> testNames = AddTestDialogState.selectedTests.map((item) => item["Test Name"].toString()).toList();
                                          List<String> testRate = AddTestDialogState.selectedTests.map((item) => item["Test Rate"].toString()).toList();
                                          List<String> testDate = AddTestDialogState.selectedTests.map((item) => item["Test Time"].toString()).toList();

                                          String TotalAmount = AddTestDialogState.totalAmount.toString();
                                          String Advance = advanceCtrl.text.isEmpty ? "0" : advanceCtrl.text;

                                          String year = yearCtrl.text.isEmpty ? "0" : yearCtrl.text;
                                          String month = monthCtrl.text.isEmpty ? "0" : monthCtrl.text;

                                          showDialog<bool>(
                                            context: context,
                                            barrierDismissible: false, // user must tap a button
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: UiHelper.CustText(text: "Success",size: 10.5.sp),
                                                content: Text("Case Entry Successfully Done. Do You Print Receipt?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text("No"),
                                                    onPressed: () => Navigator.pop(context),
                                                  ),
                                                  ElevatedButton(
                                                    child: const Text("Yes"),
                                                    onPressed: () {

                                                      GetStorage userBox = GetStorage();
                                                      String User = userBox.read("newUser") ?? "";

                                                      PrintCaseEntry.printBill(
                                                          receiptNo: receiptNo,
                                                          receiptDate: dateCtrl.text,
                                                          caseNo: caseNoCtrl.text,
                                                          caseDate: dateCtrl.text,
                                                          caseTime: timeCtrl.text,
                                                          patientName: nameCtrl.text,
                                                          mobile: mobileCtrl.text,
                                                          sex: SelectedGender,
                                                          age: "${year} Y ${month != "0" ? month :""}${month != "0" ? "M" :""} ",
                                                          referredBy: doctorCtrl.text,
                                                          testName: testNames,
                                                          testRate: testRate,
                                                          date: dateCtrl.text,
                                                          totalAmount: TotalAmount,
                                                          discountAmount: afterdiscountCtrl.text,
                                                          balanceAmount: balanceCtrl.text,
                                                          advanceAmount: Advance,
                                                          receivedBy: User,
                                                          testDate: testDate
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
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
                                        return Obx(() {
                                          return InkWell(
                                            onTap: (){
                                              if(receivedByCtrl.text.isEmpty || receivedByCtrl.text == null){

                                                GetStorage userBox = GetStorage();
                                                String User = userBox.read("newUser") ?? "";

                                                String pay_status = balanceCtrl.text == ".00" || balanceCtrl.text == "0" || balanceCtrl.text == "" ? "Paid" : "Due";
                                                List<String> testNames = selectedTests.map((test) => test["Test Name"] as String).toList();
                                                List<int> testRates = selectedTests.map((test) => test["Test Rate"] as int).toList();
                                                List<String> testDate = selectedTests.map((test) => test["Test Time"] as String).toList();
                                                List<String> testFile = selectedTests.map((test) => test["Test File"] as String).toList();

                                                CaseEntryCtrl.CaseEntry(context : context, case_date : dateCtrl.text,time: timeCtrl.text, date: dateCtrl.text, case_no: caseNoCtrl.text, slip_no: slipNoCtrl.text, received_by: User, patient_name: nameCtrl.text, year: yearCtrl.text, month: monthCtrl.text, gender: SelectedGender, mobile: mobileCtrl.text, child_male: "0", child_female: "0", address: addressCtrl.text, agent: agentCtrl.text, doctor: doctorCtrl.text, test_name: testNames.toString(), test_rate: testRates.toString(), total_amount: total.toString(), discount: discountAmount.toString(), after_discount: afterDiscount.toString(), advance: advance.toString(), balance: balance.toString(),paid_amount: "${paidAmount.value.toStringAsFixed(2)}",pay_status: pay_status, pay_mode: PayMode, discount_type: DiscountType,test_date: testDate.toString(),test_file: testFile.toString(),narration: narrationCtrl.text,name_title: nametitleCtrl.text);

                                              }
                                              else{
                                                String pay_status = balanceCtrl.text == ".00" || balanceCtrl.text == "0" || balanceCtrl.text == "" ? "Paid" : "Due";
                                                List<String> testNames = selectedTests.map((test) => test["Test Name"] as String).toList();
                                                List<int> testRates = selectedTests.map((test) => test["Test Rate"] as int).toList();
                                                List<String> testDate = selectedTests.map((test) => test["Test Time"] as String).toList();
                                                List<String> testFile = selectedTests.map((test) => test["Test File"] as String).toList();

                                                CaseEntryCtrl.CaseEntry(context : context, case_date : dateCtrl.text,time: timeCtrl.text, date: dateCtrl.text, case_no: caseNoCtrl.text, slip_no: slipNoCtrl.text, received_by: receivedByCtrl.text, patient_name: nameCtrl.text, year: yearCtrl.text, month: monthCtrl.text, gender: SelectedGender, mobile: mobileCtrl.text, child_male: "0", child_female: "0", address: addressCtrl.text, agent: agentCtrl.text, doctor: doctorCtrl.text, test_name: testNames.toString(), test_rate: testRates.toString(), total_amount: total.toString(), discount: discountAmount.toString(), after_discount: afterDiscount.toString(), advance: advance.toString(), balance: balance.toString(),paid_amount: "${paidAmount.value.toStringAsFixed(2)}",pay_status: pay_status, pay_mode: PayMode, discount_type: DiscountType,test_date: testDate.toString(),test_file: testFile.toString(),narration: narrationCtrl.text,name_title: nametitleCtrl.text);

                                              }
                                            },
                                            child: Card(
                                              elevation: 5,
                                              color: Colors.blue.shade400,
                                              borderOnForeground: true,
                                              shadowColor: Colors.blue.shade100,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Paid Amount: ₹${paidAmount.value.toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontFamily: 'font-bold'),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ],)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
            // Side Bar
            Container(
              width: 15.w,
              child: UiHelper.custsidebar(container: "2", context: context),
            ),

            BlocListener<CaseNumberCubit, CaseNumberState>(
              listener: (context, state) {
                if (state is CaseNumberLoadedState) {
                  final nextCaseNumber = int.parse(state.CaseNumber) + 1;
                  caseNoCtrl.text = nextCaseNumber.toString().padLeft(4, '0');
                }
              },
              child: SizedBox.shrink(),
            ),

            // Main Content
            Container(
              width: 85.w,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "CASE ENTRY"),
                    ListView(
                      shrinkWrap: true,
                      children: [
                        // Case Information
                        Container(
                          width: 30.w,
                          child: UiHelper.Custcard(
                            title: "Case Information",
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    UiHelper.CustTextField(
                                        controller: timeCtrl,
                                        enabled: false,
                                        label: "Time"),
                                    const SizedBox(width: 5),
                                    UiHelper.CustTextField(
                                        controller: dateCtrl,
                                        enabled: false,
                                        label: "Date"),
                                    const SizedBox(width: 5),
                                    UiHelper.CustTextField(
                                        controller: caseNoCtrl,
                                        label: "Case No",
                                        enabled: false),
                                    const SizedBox(width: 5),
                                    UiHelper.CustTextField(
                                        controller: slipNoCtrl,
                                        label: "Slip No",
                                        enabled: false),
                                    const SizedBox(width: 5),
                                    UiHelper.CustTextField(
                                        controller: receivedByCtrl,
                                        label: "Received By",
                                        enabled: false),
                                  ],
                                ),

                              ],
                            ),
                          ),
                        ),

                        // Patient Details
                        UiHelper.Custcard(
                          title: "Patient Details",
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 150,
                                    child: TextField(
                                      controller: nametitleCtrl,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: "Title",
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
                                        labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 12.sp),
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: nameCtrl,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: "Patient Name",
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
                                        labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 12.sp),
                                        prefixIcon: Icon(Icons.person),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: 15),
                              Row(children: [
                                Expanded(
                                  child: TextField(
                                    controller: yearCtrl,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        labelText: "Year",
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
                                        labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 12.sp),
                                        prefixIcon: Icon(Icons.calendar_month),
                                        suffixIcon: IconButton(onPressed: ()=>UiHelper.CustEditableDropDown(context, (data)=>yearCtrl.text=data,CaseEnteryData.yearList), icon: Icon(Icons.arrow_drop_down_circle_outlined))

                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextField(
                                    controller: monthCtrl,
                                    style: TextStyle(color: Colors.black),
                                    decoration: InputDecoration(
                                        labelText: "Month",
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
                                        labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 12.sp),
                                        prefixIcon: Icon(Icons.calendar_month),
                                        suffixIcon: IconButton(onPressed: ()=>UiHelper.CustEditableDropDown(context, (data)=>monthCtrl.text=data,CaseEnteryData.monthList), icon: Icon(Icons.arrow_drop_down_circle_outlined))

                                    ),
                                  ),
                                ),
                              ],),
                              SizedBox(height: 15),
                              Row(
                                children: [
                                  UiHelper.CustDropDown(
                                      label: "Gender",
                                      defaultValue: SelectedGender,
                                      list: CaseEnteryData.genderList,
                                      icon: Icon(Icons.male),
                                      onChanged: (val) {
                                        SelectedGender = val!;
                                      }),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: mobileCtrl,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: "Mobile No",
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
                                        labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 12.sp),
                                        prefixIcon: Icon(Icons.phone),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: addressCtrl,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        labelText: "Patient Address",
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
                                        labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 12.sp),
                                        prefixIcon: Icon(Icons.location_history),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    // Doctors & Agents
                    Container(
                      width: Adaptive.w(85),
                      child: UiHelper.Custcard(
                        title: "Doctors & Agents",
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: agentCtrl,
                                style: TextStyle(color: Colors.black),
                                decoration: InputDecoration(
                                    labelText: "Enter Agent Name",
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
                                    prefixIcon: Icon(Icons.person),
                                    suffixIcon: IconButton(onPressed: ()=>UiHelper.CustEditableDropDown(context, (data)=>agentCtrl.text=data,CaseEnteryData.agentList), icon: Icon(Icons.arrow_drop_down_circle_outlined))

                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: DoctorInputField(
                                controller: doctorCtrl,
                                initialValue: "Self",
                                onDoctorSelected: (doctor) {
                                  setState(() {
                                    doctorCtrl.text = doctor;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Tests & Billing
                    ListView(
                      shrinkWrap: true,
                      children: [
                        // Tests List
                        Container(
                          width: 42.5.w,
                          child: UiHelper.Custcard(
                            title: "Tests List",
                            trailing: TextButton(
                              onPressed: () async {
                                var result = await showDialog(
                                  context: context,
                                  builder: (_) => AddTestDialog(),
                                );
                                if (result != null) {
                                  setState(() {
                                    selectedTests = result;
                                    updateBilling();
                                  });
                                }
                              },
                              child: Text("Add Test"),
                            ),
                            child: Column(
                              children: [
                                Divider(),

                                ...selectedTests.asMap().entries.map((entry) {
                                  int index = entry.key;
                                  var item = entry.value;

                                  return Card(
                                    color: Colors.grey.shade100,
                                    margin: EdgeInsets.symmetric(vertical: 4),
                                    child: ListTile(
                                      leading: UiHelper.CustText(text: "${index + 1} : "),
                                      title: UiHelper.CustText(text: item['Test Name']),

                                      /// ✅ Only ONE trailing widget
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          UiHelper.CustText(text: "${item['Test Rate']}"),
                                          SizedBox(width: 8),
                                          IconButton(
                                            icon: Icon(Icons.close, color: Colors.red),
                                            onPressed: () {
                                              setState(() {
                                                selectedTests.removeAt(index);
                                                AddTestDialogState.totalAmount -=
                                                    double.parse(item['Test Rate'].toString());
                                                updateBilling();
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),

                              ],
                            ),
                          ),
                        ),


                        // Billing Summary
                        Container(
                          width: 42.5.w,
                          child: UiHelper.Custcard(
                            title: "Billing Summary",
                            child: Column(
                              children: [
                                // Total & Discount
                                Row(
                                  children: [
                                    UiHelper.CustTextField(
                                      controller: totalCtrl,
                                      label: "Total Amount",
                                      enabled: false,
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        controller: discountCtrl,
                                        decoration: InputDecoration(
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
                                            prefixIcon: Icon(Icons.discount),
                                            labelText: "Discount (₹)"), // <-- Changed
                                        keyboardType: TextInputType.number,
                                        onChanged: (_) {
                                          updateBilling();
                                        },
                                      ),
                                    ),

                                  ],
                                ),

                                SizedBox(height: 15),

                                // After Discount & Advance
                                Row(
                                  children: [
                                    UiHelper.CustTextField(
                                      controller: afterdiscountCtrl,
                                      label: "Amount After Discount",
                                      enabled: false,
                                    ),
                                    SizedBox(width: 20),
                                    Expanded(
                                      child: TextField(
                                        controller: advanceCtrl,
                                        decoration: InputDecoration(
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
                                            prefixIcon: Icon(Icons.money),
                                            labelText: "Advance Amount"),
                                        keyboardType: TextInputType.number,
                                        onChanged: (_) {
                                          updateBilling();
                                        },
                                      ),
                                    ),
                                  ],
                                ),

                                SizedBox(height: 15),

                                // Balance & Pay Mode
                                Row(
                                  children: [
                                    UiHelper.CustTextField(
                                      controller: balanceCtrl,
                                      label: "Balance Amount",
                                      enabled: false,
                                    ),
                                    SizedBox(width: 20),
                                    UiHelper.CustDropDown(
                                      label: "Pay Mode",
                                      defaultValue: PayMode,
                                      list: CaseEnteryData.payList,
                                      onChanged: (val) {
                                        PayMode = val!;
                                      },
                                    ),
                                  ],
                                ),

                                SizedBox(height: 15),

                                // Paid Amount Display
                                Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: discountTypeCtrl,
                                        style: TextStyle(color: Colors.black),
                                        decoration: InputDecoration(
                                            labelText: "Enter Discount Type",
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
                                            prefixIcon: Icon(Icons.local_hospital),
                                            suffixIcon: IconButton(onPressed: ()=>UiHelper.CustEditableDropDown(context, (data)=>discountTypeCtrl.text=data,CaseEnteryData.discountTypeList), icon: Icon(Icons.arrow_drop_down_circle_outlined))

                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 15),
                                    UiHelper.CustTextField(controller: narrationCtrl, label: "Enter Narration")

                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    BlocConsumer<CaseEntryBloc, CaseEntryState>(
                                      listener: (context, state) {
                                        if(state is CaseEntryLoadedState){

                                          List<String> testNames = AddTestDialogState.selectedTests.map((item) => item["Test Name"].toString()).toList();
                                          List<String> testRate = AddTestDialogState.selectedTests.map((item) => item["Test Rate"].toString()).toList();
                                          List<String> testDate = AddTestDialogState.selectedTests.map((item) => item["Test Time"].toString()).toList();

                                          String TotalAmount = AddTestDialogState.totalAmount.toString();
                                          String Advance = advanceCtrl.text.isEmpty ? "0" : advanceCtrl.text;

                                          String year = yearCtrl.text.isEmpty ? "0" : yearCtrl.text;
                                          String month = monthCtrl.text.isEmpty ? "0" : monthCtrl.text;

                                          showDialog<bool>(
                                            context: context,
                                            barrierDismissible: false, // user must tap a button
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: UiHelper.CustText(text: "Success",size: 10.5.sp),
                                                content: Text("Case Entry Successfully Done. Do You Print Receipt?"),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text("No"),
                                                    onPressed: () => Navigator.pop(context),
                                                  ),
                                                  ElevatedButton(
                                                    child: const Text("Yes"),
                                                    onPressed: () {

                                                      GetStorage userBox = GetStorage();
                                                      String User = userBox.read("newUser") ?? "";

                                                      PrintCaseEntry.printBill(
                                                          receiptNo: receiptNo,
                                                          receiptDate: dateCtrl.text,
                                                          caseNo: caseNoCtrl.text,
                                                          caseDate: dateCtrl.text,
                                                          caseTime: timeCtrl.text,
                                                          patientName: nameCtrl.text,
                                                          mobile: mobileCtrl.text,
                                                          sex: SelectedGender,
                                                          age: "${year} Y ${month != "0" ? month :""}${month != "0" ? "M" :""} ",
                                                          referredBy: doctorCtrl.text,
                                                          testName: testNames,
                                                          testRate: testRate,
                                                          date: dateCtrl.text,
                                                          totalAmount: TotalAmount,
                                                          discountAmount: afterdiscountCtrl.text,
                                                          balanceAmount: balanceCtrl.text,
                                                          advanceAmount: Advance,
                                                          receivedBy: User,
                                                          testDate: testDate
                                                      );
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
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
                                        return Obx(() {
                                          return InkWell(
                                            onTap: (){
                                              if(receivedByCtrl.text.isEmpty || receivedByCtrl.text == null){

                                                GetStorage userBox = GetStorage();
                                                String User = userBox.read("newUser") ?? "";

                                                String pay_status = balanceCtrl.text == ".00" || balanceCtrl.text == "0" || balanceCtrl.text == "" ? "Paid" : "Due";
                                                List<String> testNames = selectedTests.map((test) => test["Test Name"] as String).toList();
                                                List<int> testRates = selectedTests.map((test) => test["Test Rate"] as int).toList();
                                                List<String> testDate = selectedTests.map((test) => test["Test Time"] as String).toList();
                                                List<String> testFile = selectedTests.map((test) => test["Test File"] as String).toList();

                                                CaseEntryCtrl.CaseEntry(context : context, case_date : dateCtrl.text,time: timeCtrl.text, date: dateCtrl.text, case_no: caseNoCtrl.text, slip_no: slipNoCtrl.text, received_by: User, patient_name: nameCtrl.text, year: yearCtrl.text, month: monthCtrl.text, gender: SelectedGender, mobile: mobileCtrl.text, child_male: "0", child_female: "0", address: addressCtrl.text, agent: agentCtrl.text, doctor: doctorCtrl.text, test_name: testNames.toString(), test_rate: testRates.toString(), total_amount: total.toString(), discount: discountAmount.toString(), after_discount: afterDiscount.toString(), advance: advance.toString(), balance: balance.toString(),paid_amount: "${paidAmount.value.toStringAsFixed(2)}",pay_status: pay_status, pay_mode: PayMode, discount_type: DiscountType,test_date: testDate.toString(),test_file: testFile.toString(),narration: narrationCtrl.text,name_title: nametitleCtrl.text);

                                              }
                                              else{
                                                String pay_status = balanceCtrl.text == ".00" || balanceCtrl.text == "0" || balanceCtrl.text == "" ? "Paid" : "Due";
                                                List<String> testNames = selectedTests.map((test) => test["Test Name"] as String).toList();
                                                List<int> testRates = selectedTests.map((test) => test["Test Rate"] as int).toList();
                                                List<String> testDate = selectedTests.map((test) => test["Test Time"] as String).toList();
                                                List<String> testFile = selectedTests.map((test) => test["Test File"] as String).toList();

                                                CaseEntryCtrl.CaseEntry(context : context, case_date : dateCtrl.text,time: timeCtrl.text, date: dateCtrl.text, case_no: caseNoCtrl.text, slip_no: slipNoCtrl.text, received_by: receivedByCtrl.text, patient_name: nameCtrl.text, year: yearCtrl.text, month: monthCtrl.text, gender: SelectedGender, mobile: mobileCtrl.text, child_male: "0", child_female: "0", address: addressCtrl.text, agent: agentCtrl.text, doctor: doctorCtrl.text, test_name: testNames.toString(), test_rate: testRates.toString(), total_amount: total.toString(), discount: discountAmount.toString(), after_discount: afterDiscount.toString(), advance: advance.toString(), balance: balance.toString(),paid_amount: "${paidAmount.value.toStringAsFixed(2)}",pay_status: pay_status, pay_mode: PayMode, discount_type: DiscountType,test_date: testDate.toString(),test_file: testFile.toString(),narration: narrationCtrl.text,name_title: nametitleCtrl.text);

                                              }
                                              },
                                            child: Card(
                                              elevation: 5,
                                              color: Colors.blue.shade400,
                                              borderOnForeground: true,
                                              shadowColor: Colors.blue.shade100,
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "Paid Amount: ₹${paidAmount.value.toStringAsFixed(2)}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12.sp,
                                                      fontFamily: 'font-bold'),
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      },
                                    ),
                                  ],)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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