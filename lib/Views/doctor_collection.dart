import 'package:care_lab_software/Controllers/DoctorCollectionCtrl/doctor_collection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:sizer/sizer.dart';

import '../Helpers/case_entry_data.dart';
import '../Helpers/get_doctor_data.dart';
import '../Helpers/uiHelper.dart';
import 'doctor_sale_report.dart';
import 'loginscreen.dart';
import 'monthly_list.dart';

class DoctorCollection extends StatefulWidget {
  const DoctorCollection({super.key});

  @override
  State<DoctorCollection> createState() => _DoctorCollectionState();
}

class _DoctorCollectionState extends State<DoctorCollection> {

  TextEditingController doctorCtrl = TextEditingController();
  TextEditingController fromdateCtrl = TextEditingController();
  TextEditingController todateCtrl = TextEditingController();


  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String accessCode = args["code"];

    if(accessCode != "/doctor_collection"){

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LabLoginScreen()), (val)=>true);

    }

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Device.width < 1100 ?

      Container(
        child: Column(
          children: [

            Container(
              height: 200,
              child: UiHelper.custHorixontalTab(container: "6",context: context),
            ),

            ListView(
              shrinkWrap: true,
              padding: EdgeInsets.all(8),
              children: [
                UiHelper.CustTopBar(title: "Doctor Collection",),

                const SizedBox(height: 20,),

                ListView(
                  shrinkWrap: true,
                  children: [
                  Expanded(
                    child: TextField(
                      controller: fromdateCtrl,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: "Select From Date",
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
                          labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 16.sp),
                          prefixIcon: Icon(Icons.calendar_month),
                          suffixIcon: GestureDetector(
                              onTap: ()async{
                                DateTime? pickedDate = await showOmniDateTimePicker(context: context,type: OmniDateTimePickerType.date,);

                                if (pickedDate != null) {
                                  String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                                  setState(() {
                                    fromdateCtrl.text = formattedDate;
                                  });

                                }
                              },
                              child: Icon(Icons.calendar_month,))
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
                  Expanded(
                    child: TextField(
                      controller: todateCtrl,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                          labelText: "Select To Date",
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
                          labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 16.sp),
                          prefixIcon: Icon(Icons.calendar_month),
                          suffixIcon: GestureDetector(
                              onTap: ()async{
                                DateTime? pickedDate = await showOmniDateTimePicker(context: context,type: OmniDateTimePickerType.date,);

                                if (pickedDate != null) {
                                  String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                                  setState(() {
                                    todateCtrl.text = formattedDate;
                                  });

                                }
                              },
                              child: Icon(Icons.calendar_month,))
                      ),
                    ),
                  ),
                  const SizedBox(height: 10,),
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
                  const SizedBox(height: 10,),
                  GestureDetector(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>DoctorSaleReport(fromDate: fromdateCtrl.text, toDate: todateCtrl.text, doctorName: doctorCtrl.text,))),
                    child: Container(
                      height: 50,
                      width: 200,
                      decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),color: Colors.green),
                      child: Center(child: UiHelper.CustText(text: "Get Collection",color: Colors.white,size: 16.sp)),
                    ),
                  ),

                ],),
              ],
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
              child: UiHelper.custsidebar(container: "9",context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Doctor Collection",),

                    const SizedBox(height: 20,),

                    Row(children: [
                      Expanded(
                        child: TextField(
                          controller: fromdateCtrl,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Select From Date",
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
                                        fromdateCtrl.text = formattedDate;
                                      });

                                    }
                                  },
                                  child: Icon(Icons.calendar_month,))
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: TextField(
                          controller: todateCtrl,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Select To Date",
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
                                        todateCtrl.text = formattedDate;
                                      });

                                    }
                                  },
                                  child: Icon(Icons.calendar_month,))
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
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
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=>DoctorSaleReport(fromDate: fromdateCtrl.text, toDate: todateCtrl.text, doctorName: doctorCtrl.text,))),
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),color: Colors.green),
                          child: Center(child: UiHelper.CustText(text: "Get Collection",color: Colors.white,size: 11.sp)),
                        ),
                      ),

                    ],),
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
