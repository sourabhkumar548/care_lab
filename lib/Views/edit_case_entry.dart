import 'dart:math';
import 'package:care_lab_software/Controllers/GetSingleCase/single_case_cubit.dart';
import 'package:care_lab_software/Controllers/UpdateCaseCtrl/update_case_bloc.dart';
import 'package:care_lab_software/Controllers/UpdateCaseCtrl/update_case_ctrl.dart';
import 'package:care_lab_software/Helpers/get_doctor_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class EditCaseEntry extends StatefulWidget {
  String case_no;
  EditCaseEntry({super.key,required this.case_no});

  @override
  State<EditCaseEntry> createState() => _EditCaseEntryState();
}

class _EditCaseEntryState extends State<EditCaseEntry> {

  List<Map<String, dynamic>> selectedTests = [];
  bool isInitialized = false;

  final twoDigitYear = (DateTime.now().year % 100).toString().padLeft(2, '0');
  Random data = Random();

  RxDouble paidAmount = 0.0.obs;

  // ✅ ADD: Store billing controllers as state variables
  late TextEditingController totalCtrl;
  late TextEditingController discountCtrl;
  late TextEditingController afterdiscountCtrl;
  late TextEditingController advanceCtrl;
  late TextEditingController balanceCtrl;

  @override
  void initState() {
    super.initState();

    // ✅ Initialize controllers here
    totalCtrl = TextEditingController();
    discountCtrl = TextEditingController();
    afterdiscountCtrl = TextEditingController();
    advanceCtrl = TextEditingController();
    balanceCtrl = TextEditingController();

    context.read<SingleCaseCubit>().getSingleCase(caseno: widget.case_no);
  }

  @override
  void dispose() {
    // ✅ Don't forget to dispose controllers
    totalCtrl.dispose();
    discountCtrl.dispose();
    afterdiscountCtrl.dispose();
    advanceCtrl.dispose();
    balanceCtrl.dispose();
    super.dispose();
  }

  double total = 0;
  double discountAmount = 0;
  double advance = 0;
  double afterDiscount = 0;
  double balance = 0;
  bool zero = false;

  void updateBilling({
    required TextEditingController discountCtrl,
    required TextEditingController advanceCtrl,
    required TextEditingController totalCtrl,
    required TextEditingController afterdiscountCtrl,
    required TextEditingController balanceCtrl
  }) {
    setState(() {
      total = zero ? 0 : AddTestDialogState.totalAmount;
      discountAmount = double.tryParse(discountCtrl.text) ?? 0;
      afterDiscount = total - discountAmount;
      advance = double.tryParse(advanceCtrl.text) ?? 0;
      balance = afterDiscount - advance;

      // ✅ UPDATE the text controllers
      totalCtrl.text = total.toStringAsFixed(2);
      afterdiscountCtrl.text = afterDiscount.toStringAsFixed(2);
      balanceCtrl.text = balance.toStringAsFixed(2);

      paidAmount.value = advance > 0 ? advance : 0;
    });
  }
  @override
  Widget build(BuildContext context) {


    return Scaffold(
        backgroundColor: Colors.blue.shade100,
        body: Device.width < 1100 ?

        BlocBuilder<SingleCaseCubit, SingleCaseState>(
            builder: (context, state) {
              if(state is SingleCaseLoadingState){
                return Center(child: CircularProgressIndicator());
              }
              if(state is SingleCaseErrorState){
                return Center(child: UiHelper.CustText(text: state.errorMsg));
              }
              if(state is SingleCaseLoadedState){

                var data = state.caseModel.caseData!;

                // ✅ ONLY initialize once
                if (!isInitialized) {
                  paidAmount.value = double.parse(data.advance!);

                  // Parse existing tests
                  List<String> names = data.testName!.replaceAll('[', '').replaceAll(']', '').split(',').map((e) => e.trim()).toList();
                  List<String> rate = data.testRate!.replaceAll('[', '').replaceAll(']', '').split(',').map((e) => e.trim()).toList();
                  List<String> time = data.testDate!.replaceAll('[', '').replaceAll(']', '').split(',').map((e) => e.trim()).toList();
                  List<String> file = data.testFile!.replaceAll('[', '').replaceAll(']', '').split(',').map((e) => e.trim()).toList();

                  selectedTests.clear();
                  for (int i = 0; i < names.length && i < rate.length; i++) {
                    selectedTests.add({
                      'Test Name': names[i],
                      'Test Rate': int.tryParse(rate[i]) ?? 0,
                      'Test Time': time[i],
                      'Test File': file[i],
                    });
                  }

                  AddTestDialogState.selectedTests = List.from(selectedTests);
                  AddTestDialogState.totalAmount = selectedTests.fold(0.0, (sum, test) =>
                  sum + (double.tryParse(test['Test Rate'].toString()) ?? 0)
                  );

                  // ✅ Set initial controller values
                  double initialTotal = zero ? 0 : AddTestDialogState.totalAmount;
                  double initialDiscount = double.tryParse(data.discount!) ?? 0;
                  double initialAfterDiscount = initialTotal - initialDiscount;
                  double initialAdvance = double.tryParse(data.advance!) ?? 0;
                  double initialBalance = initialAfterDiscount - initialAdvance;

                  totalCtrl.text = initialTotal.toStringAsFixed(2);
                  discountCtrl.text = data.discount!;
                  afterdiscountCtrl.text = initialAfterDiscount.toStringAsFixed(2);
                  advanceCtrl.text = data.advance!;
                  balanceCtrl.text = initialBalance.toStringAsFixed(2);

                  isInitialized = true;
                }


                String SelectedGender = data.gender!;
                String PayMode = data.payMode!;
                String DiscountType = data.discountType!;


                TextEditingController timeCtrl = TextEditingController(text: data.time);
                TextEditingController dateCtrl = TextEditingController(text: data.date);
                TextEditingController caseNoCtrl = TextEditingController(text: data.caseNo);
                TextEditingController slipNoCtrl = TextEditingController(text: data.slipNo);
                TextEditingController receivedByCtrl = TextEditingController(text: data.receivedBy);
                TextEditingController nameCtrl = TextEditingController(text: data.patientName);
                TextEditingController mobileCtrl = TextEditingController(text: data.mobile);
                TextEditingController addressCtrl = TextEditingController(text: data.address);
                TextEditingController agentCtrl = TextEditingController(text: data.agent);
                TextEditingController doctorCtrl = TextEditingController(text: data.doctor);

                // Billing Controllers

                TextEditingController discountTypeCtrl = TextEditingController(text: data.discountType);

                // Age Controllers
                TextEditingController yearCtrl = TextEditingController(text: data.year);
                TextEditingController monthCtrl = TextEditingController(text: data.month);
                TextEditingController narrationCtrl = TextEditingController(text: data.narration);
                TextEditingController nametitleCtrl = TextEditingController(text: data.nameTitle);

                return Center(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                      // Side Bar

                      Container(
                      height: 120,
                      child: UiHelper.custHorixontalTab(container: "2", context: context),),

                    // Main Content
                    Container(
                        height: Adaptive.h(100),
                        width: Device.width < 1100 ? 100.w :85.w,
                        child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView(
                                children: [
                            UiHelper.CustTopBar(title: "EDIT CASE ENTRY"),
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
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(3),
                                            ],
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
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(3),
                                            ],
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
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                                LengthLimitingTextInputFormatter(10),
                                              ],
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
                                            suffixIcon: IconButton(onPressed: ()=>
                                                UiHelper.CustEditableDropDown(context, (data)=>agentCtrl.text=data,CaseEnteryData.agentList),
                                                icon: Icon(Icons.arrow_drop_down_circle_outlined))

                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: DoctorInputField(
                                        controller: doctorCtrl,
                                        initialValue: data.doctor ?? "Self",
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

                                    if(CaseEnteryData.agentZero.contains(agentCtrl.text)){
                                      setState(() {
                                        zero = true;
                                      });
                                    }

                                    // ✅ Initialize AddTestDialogState with current tests before opening dialog
                                    AddTestDialogState.selectedTests = List.from(selectedTests);
                                    AddTestDialogState.totalAmount = selectedTests.fold(0.0, (sum, test) =>
                                    sum + (double.tryParse(test['Test Rate'].toString()) ?? 0)
                                    );

                                    var result = await showDialog(
                                      context: context,
                                      builder: (_) => AddTestDialog(),
                                    );

                                    if (result != null) {
                                      setState(() {
                                        selectedTests = result;
                                        // Recalculate total from the returned tests
                                        AddTestDialogState.totalAmount = result.fold(0.0, (sum, test) =>
                                        sum + (double.tryParse(test['Test Rate'].toString()) ?? 0)
                                        );
                                        updateBilling(
                                            discountCtrl: discountCtrl,
                                            advanceCtrl: advanceCtrl,
                                            totalCtrl: totalCtrl,
                                            afterdiscountCtrl: afterdiscountCtrl,
                                            balanceCtrl: balanceCtrl
                                        );
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

                                          /// ✅ Editable Test Rate Field
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              SizedBox(
                                                width: 100,
                                                child: TextField(
                                                  controller: TextEditingController(text: zero ? "0" :"${item['Test Rate']}"),
                                                  keyboardType: TextInputType.number,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(color: Colors.black, fontSize: 14),
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.digitsOnly,
                                                  ],
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                    border: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                      borderSide: BorderSide(color: Colors.black45, width: 1),
                                                    ),
                                                    focusedBorder: OutlineInputBorder(
                                                      borderRadius: BorderRadius.circular(5),
                                                      borderSide: BorderSide(color: Colors.blue, width: 2),
                                                    ),
                                                  ),
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      // Get old rate
                                                      double oldRate = double.tryParse(item['Test Rate'].toString()) ?? 0;

                                                      // Get new rate
                                                      double newRate = double.tryParse(newValue) ?? 0;

                                                      // Update the item
                                                      item['Test Rate'] = newRate.toInt();

                                                      // Update total amount
                                                      AddTestDialogState.totalAmount = AddTestDialogState.totalAmount - oldRate + newRate;

                                                      // Update billing
                                                      updateBilling(discountCtrl: discountCtrl, advanceCtrl: advanceCtrl, totalCtrl: totalCtrl, afterdiscountCtrl: afterdiscountCtrl, balanceCtrl: balanceCtrl);
                                                    });
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 8),
                                              IconButton(
                                                icon: Icon(Icons.close, color: Colors.red),
                                                onPressed: () {
                                                  setState(() {
                                                    // Get the rate before removing
                                                    double rateToRemove = double.tryParse(item['Test Rate'].toString()) ?? 0;

                                                    // Remove from both lists
                                                    selectedTests.removeAt(index);

                                                    // Also remove from AddTestDialogState if it exists there
                                                    AddTestDialogState.selectedTests.removeWhere((test) =>
                                                    test['Test Name'] == item['Test Name']
                                                    );

                                                    // Update total
                                                    AddTestDialogState.totalAmount -= rateToRemove;

                                                    // Ensure total doesn't go negative
                                                    if (AddTestDialogState.totalAmount < 0) {
                                                      AddTestDialogState.totalAmount = 0;
                                                    }

                                                    updateBilling(
                                                        discountCtrl: discountCtrl,
                                                        advanceCtrl: advanceCtrl,
                                                        totalCtrl: totalCtrl,
                                                        afterdiscountCtrl: afterdiscountCtrl,
                                                        balanceCtrl: balanceCtrl
                                                    );
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
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
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
                                          labelText: "Discount (₹)"),
                                      keyboardType: TextInputType.number,
                                      onChanged: (_) {
                                        updateBilling(discountCtrl: discountCtrl, advanceCtrl: advanceCtrl, totalCtrl: totalCtrl, afterdiscountCtrl: afterdiscountCtrl, balanceCtrl: balanceCtrl);

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
                                      inputFormatters: [
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
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
                                          labelText: "Paid Amount"),
                                      keyboardType: TextInputType.number,
                                      onChanged: (_) {
                                        updateBilling(discountCtrl: discountCtrl, advanceCtrl: advanceCtrl, totalCtrl: totalCtrl, afterdiscountCtrl: afterdiscountCtrl, balanceCtrl: balanceCtrl);

                                      },// CONTINUATION OF THE MOBILE LAYOUT AND START OF DESKTOP LAYOUT
// This continues from where the first part ended

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
                                            enabled: true,
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
                                          BlocConsumer<UpdateCaseBloc, UpdateCaseState>(
                                            listener: (context, state) {
                                              if(state is UpdateCaseLoadedState){

                                                List<String> testNames = AddTestDialogState.selectedTests.map((item) => item["Test Name"].toString()).toList();
                                                List<String> testRate = AddTestDialogState.selectedTests.map((item) => item["Test Rate"].toString()).toList();
                                                List<String> testDate = AddTestDialogState.selectedTests.map((item) => item["Test Time"].toString()).toList();

                                                String TotalAmount = AddTestDialogState.totalAmount.toString();
                                                String Advance = advanceCtrl.text.isEmpty ? "0" : advanceCtrl.text;

                                                String year = yearCtrl.text.isEmpty ? "0" : yearCtrl.text;
                                                String month = monthCtrl.text.isEmpty ? "0" : monthCtrl.text;

                                                showDialog<bool>(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder: (BuildContext context) {
                                                    return AlertDialog(
                                                      title: UiHelper.CustText(text: "Success",size: 10.5.sp),
                                                      content: Text("Case Successfully Updated. Do You Print Receipt?"),
                                                      actions: <Widget>[
                                                        TextButton(
                                                          child: const Text("No"),
                                                          onPressed: (){
                                                            setState(() {
                                                              selectedTests.clear();
                                                              AddTestDialogState.selectedTests.clear();
                                                              AddTestDialogState.totalAmount = 0;
                                                              updateBilling(discountCtrl: discountCtrl, advanceCtrl: advanceCtrl, totalCtrl: totalCtrl, afterdiscountCtrl: afterdiscountCtrl, balanceCtrl: balanceCtrl);
                                                            });
                                                            Navigator.popAndPushNamed(
                                                                context,
                                                                '/case_entry_page');
                                                          },
                                                        ),
                                                        ElevatedButton(
                                                          child: const Text("Yes"),
                                                          onPressed: () {
                                                            GetStorage userBox = GetStorage();
                                                            String User = userBox.read("newUser") ?? "";

                                                            if(CaseEnteryData.agentZero.contains(agentCtrl.text)){
                                                              PrintCaseEntry.printBill(
                                                                  receiptNo: slipNoCtrl.text,
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
                                                                  totalAmount: "0",
                                                                  discountAmount: "0",
                                                                  balanceAmount: "0",
                                                                  advanceAmount: "0",
                                                                  receivedBy: User,
                                                                  testDate: testDate
                                                              );
                                                            }else{
                                                              PrintCaseEntry.printBill(
                                                                  receiptNo: slipNoCtrl.text,
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
                                                                  totalAmount: "${double.parse(TotalAmount)-double.parse(discountCtrl.text)}.00",
                                                                  discountAmount: "${paidAmount.value.toStringAsFixed(2)}",
                                                                  balanceAmount: balance.toString(),
                                                                  advanceAmount: Advance,
                                                                  receivedBy: User,
                                                                  testDate: testDate
                                                              );
                                                            }

                                                            setState(() {
                                                              selectedTests.clear();
                                                              AddTestDialogState.selectedTests.clear();
                                                              AddTestDialogState.totalAmount = 0;
                                                              updateBilling(discountCtrl: discountCtrl, advanceCtrl: advanceCtrl, totalCtrl: totalCtrl, afterdiscountCtrl: afterdiscountCtrl, balanceCtrl: balanceCtrl);

                                                            });

                                                            Navigator.popAndPushNamed(context, '/case_entry_page');
                                                          },
                                                        ),
                                                      ],
                                                    );
                                                  },
                                                );


                                              }
                                              if(state is UpdateCaseErrorState){
                                                UiHelper.showErrorToste(message: state.errorMsg);
                                              }
                                            },
                                            builder: (context, state) {
                                              if(state is UpdateCaseLoadingState){
                                                return Center(child: CircularProgressIndicator());
                                              }
                                              return Obx(() {
                                                return InkWell(
                                                  onTap: (){

                                                      String pay_status = balanceCtrl.text == ".00" || balanceCtrl.text == "0" || balanceCtrl.text == "" || balanceCtrl.text == "0.00" ? "Paid" : "Due";
                                                      List<String> testNames = selectedTests.map((test) => test["Test Name"] as String).toList();
                                                      List<int> testRates = selectedTests.map((test) => int.tryParse(test["Test Rate"].toString()) ?? 0).toList();
                                                      List<String> testDate = selectedTests.map((test) => test["Test Time"] as String).toList();
                                                      List<String> testFile = selectedTests.map((test) => test["Test File"] as String).toList();

                                                      UpdateCaseCtrl.UpdateCase(context : context, case_date : dateCtrl.text,time: timeCtrl.text, date: dateCtrl.text, case_no: caseNoCtrl.text, slip_no: slipNoCtrl.text, received_by: receivedByCtrl.text, patient_name: nameCtrl.text, year: yearCtrl.text, month: monthCtrl.text, gender: SelectedGender, mobile: mobileCtrl.text, child_male: "0", child_female: "0", address: addressCtrl.text, agent: agentCtrl.text, doctor: doctorCtrl.text, test_name: testNames.toString(), test_rate: testRates.toString(), total_amount: totalCtrl.text, discount: discountCtrl.text, after_discount: afterdiscountCtrl.text, advance: advanceCtrl.text, balance: balanceCtrl.text,paid_amount: "${paidAmount.value.toStringAsFixed(2)}",pay_status: pay_status, pay_mode: PayMode, discount_type: DiscountType,test_date: testDate.toString(),test_file: testFile.toString(),narration: narrationCtrl.text,name_title: nametitleCtrl.text);

                                                  },
                                                  child: Card(
                                                    elevation: 5,
                                                    color: Colors.blue.shade400,
                                                    borderOnForeground: true,
                                                    shadowColor: Colors.blue.shade100,
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        "Update Case: ₹${paidAmount.value.toStringAsFixed(2)}",
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
                );
              }
              return Container();
            },
        )



            :

        // DESKTOP LAYOUT STARTS HERE
        BlocBuilder<SingleCaseCubit, SingleCaseState>(
          builder: (context, state) {
            if(state is SingleCaseLoadingState){
              return Center(child: CircularProgressIndicator());
            }
            if(state is SingleCaseErrorState){
              return Center(child: UiHelper.CustText(text: state.errorMsg));
            }
            if(state is SingleCaseLoadedState){
              var data = state.caseModel.caseData!;

              // ✅ ONLY initialize once
              if (!isInitialized) {
                paidAmount.value = double.parse(data.advance!);

                // Parse existing tests
                List<String> names = data.testName!.replaceAll('[', '').replaceAll(']', '').split(',').map((e) => e.trim()).toList();
                List<String> rate = data.testRate!.replaceAll('[', '').replaceAll(']', '').split(',').map((e) => e.trim()).toList();
                List<String> time = data.testDate!.replaceAll('[', '').replaceAll(']', '').split(',').map((e) => e.trim()).toList();
                List<String> file = data.testFile!.replaceAll('[', '').replaceAll(']', '').split(',').map((e) => e.trim()).toList();

                selectedTests.clear();
                for (int i = 0; i < names.length && i < rate.length; i++) {
                  selectedTests.add({
                    'Test Name': names[i],
                    'Test Rate': int.tryParse(rate[i]) ?? 0,
                    'Test Time': time[i],
                    'Test File': file[i],
                  });
                }

                AddTestDialogState.selectedTests = List.from(selectedTests);
                AddTestDialogState.totalAmount = selectedTests.fold(0.0, (sum, test) =>
                sum + (double.tryParse(test['Test Rate'].toString()) ?? 0)
                );

                // ✅ Set initial controller values
                double initialTotal = zero ? 0 : AddTestDialogState.totalAmount;
                double initialDiscount = double.tryParse(data.discount!) ?? 0;
                double initialAfterDiscount = initialTotal - initialDiscount;
                double initialAdvance = double.tryParse(data.advance!) ?? 0;
                double initialBalance = initialAfterDiscount - initialAdvance;

                totalCtrl.text = initialTotal.toStringAsFixed(2);
                discountCtrl.text = data.discount!;
                afterdiscountCtrl.text = initialAfterDiscount.toStringAsFixed(2);
                advanceCtrl.text = data.advance!;
                balanceCtrl.text = initialBalance.toStringAsFixed(2);

                isInitialized = true;
              }

              String SelectedGender = data.gender!;
              String PayMode = data.payMode!;
              String DiscountType = data.discountType!;


              TextEditingController timeCtrl = TextEditingController(text: data.time);
              TextEditingController dateCtrl = TextEditingController(text: data.date);
              TextEditingController caseNoCtrl = TextEditingController(text: data.caseNo);
              TextEditingController slipNoCtrl = TextEditingController(text: data.slipNo);
              TextEditingController receivedByCtrl = TextEditingController(text: data.receivedBy);
              TextEditingController nameCtrl = TextEditingController(text: data.patientName);
              TextEditingController mobileCtrl = TextEditingController(text: data.mobile);
              TextEditingController addressCtrl = TextEditingController(text: data.address);
              TextEditingController agentCtrl = TextEditingController(text: data.agent);
              TextEditingController doctorCtrl = TextEditingController(text: data.doctor);

              // Billing Controllers

              TextEditingController discountTypeCtrl = TextEditingController(text: data.discountType);

              // Age Controllers
              TextEditingController yearCtrl = TextEditingController(text: data.year);
              TextEditingController monthCtrl = TextEditingController(text: data.month);
              TextEditingController narrationCtrl = TextEditingController(text: data.narration);
              TextEditingController nametitleCtrl = TextEditingController(text: data.nameTitle);

              return Center(
                child: Row(
                  children: [
                    // Side Bar
                    Container(
                      width: 15.w,
                      child: UiHelper.custsidebar(container: "2", context: context),
                    ),

                    // Main Content
                    Container(
                      width: 85.w,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ListView(
                          children: [
                            UiHelper.CustTopBar(title: "EDIT CASE ENTRY"),
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
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(3),
                                            ],
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
                                            keyboardType: TextInputType.number,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.digitsOnly,
                                              LengthLimitingTextInputFormatter(3),
                                            ],
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
                                              keyboardType: TextInputType.number,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.digitsOnly,
                                                LengthLimitingTextInputFormatter(10),
                                              ],
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
                                            suffixIcon: IconButton(onPressed: ()=>
                                                UiHelper.CustEditableDropDown(context, (data)=>agentCtrl.text=data,CaseEnteryData.agentList),
                                                icon: Icon(Icons.arrow_drop_down_circle_outlined))

                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: DoctorInputField(
                                        controller: doctorCtrl,
                                        initialValue: data.doctor ?? "Self",
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

                                        if(CaseEnteryData.agentZero.contains(agentCtrl.text)){
                                          setState(() {
                                            zero = true;
                                          });
                                        }

                                        // ✅ Initialize AddTestDialogState with current tests before opening dialog
                                        AddTestDialogState.selectedTests = List.from(selectedTests);
                                        AddTestDialogState.totalAmount = selectedTests.fold(0.0, (sum, test) =>
                                        sum + (double.tryParse(test['Test Rate'].toString()) ?? 0)
                                        );

                                        var result = await showDialog(
                                          context: context,
                                          builder: (_) => AddTestDialog(),
                                        );

                                        if (result != null) {
                                          setState(() {
                                            selectedTests = result;
                                            // Recalculate total from the returned tests
                                            AddTestDialogState.totalAmount = result.fold(0.0, (sum, test) =>
                                            sum + (double.tryParse(test['Test Rate'].toString()) ?? 0)
                                            );
                                            updateBilling(
                                                discountCtrl: discountCtrl,
                                                advanceCtrl: advanceCtrl,
                                                totalCtrl: totalCtrl,
                                                afterdiscountCtrl: afterdiscountCtrl,
                                                balanceCtrl: balanceCtrl
                                            );
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

                                              /// ✅ Editable Test Rate Field
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  SizedBox(
                                                    width: 100,
                                                    child: TextField(
                                                      controller: TextEditingController(text: zero ? "0" :"${item['Test Rate']}"),
                                                      keyboardType: TextInputType.number,
                                                      textAlign: TextAlign.center,
                                                      style: TextStyle(color: Colors.black, fontSize: 14),
                                                      inputFormatters: [
                                                        FilteringTextInputFormatter.digitsOnly,
                                                      ],
                                                      decoration: InputDecoration(
                                                        contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                                        border: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                          borderSide: BorderSide(color: Colors.black45, width: 1),
                                                        ),
                                                        focusedBorder: OutlineInputBorder(
                                                          borderRadius: BorderRadius.circular(5),
                                                          borderSide: BorderSide(color: Colors.blue, width: 2),
                                                        ),
                                                      ),
                                                      onChanged: (newValue) {
                                                        setState(() {
                                                          // Get old rate
                                                          double oldRate = double.tryParse(item['Test Rate'].toString()) ?? 0;

                                                          // Get new rate
                                                          double newRate = double.tryParse(newValue) ?? 0;

                                                          // Update the item
                                                          item['Test Rate'] = newRate.toInt();

                                                          // Update total amount
                                                          AddTestDialogState.totalAmount = AddTestDialogState.totalAmount - oldRate + newRate;

                                                          // Update billing
                                                          updateBilling(discountCtrl: discountCtrl, advanceCtrl: advanceCtrl, totalCtrl: totalCtrl, afterdiscountCtrl: afterdiscountCtrl, balanceCtrl: balanceCtrl);
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  SizedBox(width: 8),
                                                  IconButton(
                                                    icon: Icon(Icons.close, color: Colors.red),
                                                    onPressed: () {
                                                      setState(() {
                                                        // Get the rate before removing
                                                        double rateToRemove = double.tryParse(item['Test Rate'].toString()) ?? 0;

                                                        // Remove from both lists
                                                        selectedTests.removeAt(index);

                                                        // Also remove from AddTestDialogState if it exists there
                                                        AddTestDialogState.selectedTests.removeWhere((test) =>
                                                        test['Test Name'] == item['Test Name']
                                                        );

                                                        // Update total
                                                        AddTestDialogState.totalAmount -= rateToRemove;

                                                        // Ensure total doesn't go negative
                                                        if (AddTestDialogState.totalAmount < 0) {
                                                          AddTestDialogState.totalAmount = 0;
                                                        }

                                                        updateBilling(
                                                            discountCtrl: discountCtrl,
                                                            advanceCtrl: advanceCtrl,
                                                            totalCtrl: totalCtrl,
                                                            afterdiscountCtrl: afterdiscountCtrl,
                                                            balanceCtrl: balanceCtrl
                                                        );
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
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
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
                                                    labelText: "Discount (₹)"),
                                                keyboardType: TextInputType.number,
                                                onChanged: (_) {
                                                  updateBilling(discountCtrl: discountCtrl, advanceCtrl: advanceCtrl, totalCtrl: totalCtrl, afterdiscountCtrl: afterdiscountCtrl, balanceCtrl: balanceCtrl);

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
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.digitsOnly,
                                                ],
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
                                                    labelText: "Paid Amount"),
                                                keyboardType: TextInputType.number,
                                                onChanged: (_) {
                                                  updateBilling(discountCtrl: discountCtrl, advanceCtrl: advanceCtrl, totalCtrl: totalCtrl, afterdiscountCtrl: afterdiscountCtrl, balanceCtrl: balanceCtrl);

                                                },// CONTINUATION OF THE MOBILE LAYOUT AND START OF DESKTOP LAYOUT
// This continues from where the first part ended

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
                                              enabled: true,
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
                                            BlocConsumer<UpdateCaseBloc, UpdateCaseState>(
                                              listener: (context, state) {
                                                if(state is UpdateCaseLoadedState){

                                                  List<String> testNames = AddTestDialogState.selectedTests.map((item) => item["Test Name"].toString()).toList();
                                                  List<String> testRate = AddTestDialogState.selectedTests.map((item) => item["Test Rate"].toString()).toList();
                                                  List<String> testDate = AddTestDialogState.selectedTests.map((item) => item["Test Time"].toString()).toList();

                                                  String TotalAmount = AddTestDialogState.totalAmount.toString();
                                                  String Advance = advanceCtrl.text.isEmpty ? "0" : advanceCtrl.text;

                                                  String year = yearCtrl.text.isEmpty ? "0" : yearCtrl.text;
                                                  String month = monthCtrl.text.isEmpty ? "0" : monthCtrl.text;

                                                  showDialog<bool>(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder: (BuildContext context) {
                                                      return AlertDialog(
                                                        title: UiHelper.CustText(text: "Success",size: 10.5.sp),
                                                        content: Text("Case Successfully Updated. Do You Print Receipt?"),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            child: const Text("No"),
                                                            onPressed: (){
                                                              setState(() {
                                                                selectedTests.clear();
                                                                AddTestDialogState.selectedTests.clear();
                                                                AddTestDialogState.totalAmount = 0;
                                                                updateBilling(discountCtrl: discountCtrl, advanceCtrl: advanceCtrl, totalCtrl: totalCtrl, afterdiscountCtrl: afterdiscountCtrl, balanceCtrl: balanceCtrl);
                                                              });
                                                              Navigator.popAndPushNamed(
                                                                  context,
                                                                  '/case_entry_page');
                                                            },
                                                          ),
                                                          ElevatedButton(
                                                            child: const Text("Yes"),
                                                            onPressed: () {
                                                              GetStorage userBox = GetStorage();
                                                              String User = userBox.read("newUser") ?? "";

                                                              if(CaseEnteryData.agentZero.contains(agentCtrl.text)){
                                                                PrintCaseEntry.printBill(
                                                                    receiptNo: slipNoCtrl.text,
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
                                                                    totalAmount: "0",
                                                                    discountAmount: "0",
                                                                    balanceAmount: "0",
                                                                    advanceAmount: "0",
                                                                    receivedBy: User,
                                                                    testDate: testDate
                                                                );
                                                              }else{
                                                                PrintCaseEntry.printBill(
                                                                    receiptNo: slipNoCtrl.text,
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
                                                                    totalAmount: "${double.parse(TotalAmount)-double.parse(discountCtrl.text)}.00",
                                                                    discountAmount: "${paidAmount.value.toStringAsFixed(2)}",
                                                                    balanceAmount: balance.toString(),
                                                                    advanceAmount: Advance,
                                                                    receivedBy: User,
                                                                    testDate: testDate
                                                                );
                                                              }

                                                              setState(() {
                                                                selectedTests.clear();
                                                                AddTestDialogState.selectedTests.clear();
                                                                AddTestDialogState.totalAmount = 0;
                                                                updateBilling(discountCtrl: discountCtrl, advanceCtrl: advanceCtrl, totalCtrl: totalCtrl, afterdiscountCtrl: afterdiscountCtrl, balanceCtrl: balanceCtrl);

                                                              });

                                                              Navigator.popAndPushNamed(context, '/case_entry_page');
                                                            },
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  );


                                                }
                                                if(state is UpdateCaseErrorState){
                                                  UiHelper.showErrorToste(message: state.errorMsg);
                                                }
                                              },
                                              builder: (context, state) {
                                                if(state is UpdateCaseLoadingState){
                                                  return Center(child: CircularProgressIndicator());
                                                }
                                                return Obx(() {
                                                  return InkWell(
                                                    onTap: (){

                                                        String pay_status = balanceCtrl.text == ".00" || balanceCtrl.text == "0" || balanceCtrl.text == "" || balanceCtrl.text == "0.00" ? "Paid" : "Due";
                                                        List<String> testNames = selectedTests.map((test) => test["Test Name"] as String).toList();
                                                        List<int> testRates = selectedTests.map((test) => int.tryParse(test["Test Rate"].toString()) ?? 0).toList();
                                                        List<String> testDate = selectedTests.map((test) => test["Test Time"] as String).toList();
                                                        List<String> testFile = selectedTests.map((test) => test["Test File"] as String).toList();

                                                        UpdateCaseCtrl.UpdateCase(context : context, case_date : dateCtrl.text,time: timeCtrl.text, date: dateCtrl.text, case_no: caseNoCtrl.text, slip_no: slipNoCtrl.text, received_by: receivedByCtrl.text, patient_name: nameCtrl.text, year: yearCtrl.text, month: monthCtrl.text, gender: SelectedGender, mobile: mobileCtrl.text, child_male: "0", child_female: "0", address: addressCtrl.text, agent: agentCtrl.text, doctor: doctorCtrl.text, test_name: testNames.toString(), test_rate: testRates.toString(), total_amount: totalCtrl.text, discount: discountCtrl.text, after_discount: afterdiscountCtrl.text, advance: advanceCtrl.text, balance: balanceCtrl.text,paid_amount: "${paidAmount.value.toStringAsFixed(2)}",pay_status: pay_status, pay_mode: PayMode, discount_type: DiscountType,test_date: testDate.toString(),test_file: testFile.toString(),narration: narrationCtrl.text,name_title: nametitleCtrl.text);

                                                    },
                                                    child: Card(
                                                      elevation: 5,
                                                      color: Colors.blue.shade400,
                                                      borderOnForeground: true,
                                                      shadowColor: Colors.blue.shade100,
                                                      child: Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: Text(
                                                          "Update Case: ₹${paidAmount.value.toStringAsFixed(2)}",
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
              );
            }
            return Container();
          },
        )
    );
  }
}