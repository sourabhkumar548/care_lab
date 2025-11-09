import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:sizer/sizer.dart';
import '../Controllers/CaseList/Cubit/case_list_cubit.dart';
import '../Helpers/get_case_list.dart';
import '../Helpers/uiHelper.dart';

class CaseEntryList extends StatefulWidget {
  const CaseEntryList({super.key});

  @override
  State<CaseEntryList> createState() => _CaseEntryListState();
}

class _CaseEntryListState extends State<CaseEntryList> {

  TextEditingController dateCtrl = TextEditingController(text: "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}");

  var amountType = "All".obs;

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
              child: UiHelper.custsidebar(container: "3",context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "CASE ENTRY LIST",widget: Container(width: 300,height: 40,
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
                          labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 11.sp),
                          prefixIcon: Icon(Icons.calendar_month),
                          suffixIcon: GestureDetector(
                              onTap: ()async{
                                DateTime? pickedDate = await showOmniDateTimePicker(context: context,type: OmniDateTimePickerType.date,);

                                if (pickedDate != null) {
                                  String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                                  setState(() {
                                    amountType.value = "All";
                                    dateCtrl.text = formattedDate;
                                    context.read<CaseListCubit>().getCaseList(date: formattedDate,type: "All");
                                  });

                                }
                              },
                              child: Icon(Icons.search,))
                      ),
                    ),),),


                    SizedBox(height: 5,),
                    GetCaseList.GetCase(date: dateCtrl.text,context: context),
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
