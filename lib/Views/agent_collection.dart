import 'package:care_lab_software/Controllers/AgentCollectionCtrl/agent_collection_cubit.dart';
import 'package:care_lab_software/Views/monthly_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:sizer/sizer.dart';

import '../Helpers/case_entry_data.dart';
import '../Helpers/uiHelper.dart';

class AgentCollection extends StatefulWidget {
  const AgentCollection({super.key});

  @override
  State<AgentCollection> createState() => _AgentCollectionState();
}

class _AgentCollectionState extends State<AgentCollection> {

  TextEditingController agentCtrl = TextEditingController();
  TextEditingController fromdateCtrl = TextEditingController();
  TextEditingController todateCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
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
              child: UiHelper.custHorixontalTab(container: "6",context: context),
            ),
            //MAIN CONTENT
            Container(
              height: Adaptive.h(100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Agent Collection",),

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
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=>SaleReport(fromDate: fromdateCtrl.text, toDate: todateCtrl.text, agentName: agentCtrl.text,))),
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
      )
          :
      Center(
        child: Row(
          children: [
            //SIDE BAR
            Container(
              width: Adaptive.w(15),
              child: UiHelper.custsidebar(container: "10",context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Agent Collection",),

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
                      const SizedBox(width: 10,),
                       GestureDetector(
                         onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=>SaleReport(fromDate: fromdateCtrl.text, toDate: todateCtrl.text, agentName: agentCtrl.text,))),
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
