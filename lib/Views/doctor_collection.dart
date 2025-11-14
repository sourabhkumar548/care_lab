import 'package:care_lab_software/Controllers/DoctorCollectionCtrl/doctor_collection_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:sizer/sizer.dart';

import '../Helpers/case_entry_data.dart';
import '../Helpers/uiHelper.dart';

class DoctorCollection extends StatefulWidget {
  const DoctorCollection({super.key});

  @override
  State<DoctorCollection> createState() => _DoctorCollectionState();
}

class _DoctorCollectionState extends State<DoctorCollection> {

  TextEditingController doctorCtrl = TextEditingController(text: "0");
  TextEditingController dateCtrl = TextEditingController(text: "0");

  String Selectedyear="0";
  String Selectedmonth="0";

  List<DropdownMenuItem<String>> yearList = [
    DropdownMenuItem(value: "0", child: Text("None")),
    DropdownMenuItem(value: "2020", child: Text("2020")),
    DropdownMenuItem(value: "2021", child: Text("2021")),
    DropdownMenuItem(value: "2022", child: Text("2022")),
    DropdownMenuItem(value: "2023", child: Text("2023")),
    DropdownMenuItem(value: "2024", child: Text("2024")),
    DropdownMenuItem(value: "2025", child: Text("2025")),
    DropdownMenuItem(value: "2026", child: Text("2026")),
  ];

  List<DropdownMenuItem<String>> monthList = [
    DropdownMenuItem(value: "0", child: Text("None")),
    DropdownMenuItem(value: "1", child: Text("January")),
    DropdownMenuItem(value: "2", child: Text("February")),
    DropdownMenuItem(value: "3", child: Text("March")),
    DropdownMenuItem(value: "4", child: Text("April")),
    DropdownMenuItem(value: "5", child: Text("May")),
    DropdownMenuItem(value: "6", child: Text("June")),
    DropdownMenuItem(value: "7", child: Text("July")),
    DropdownMenuItem(value: "8", child: Text("August")),
    DropdownMenuItem(value: "9", child: Text("September")),
    DropdownMenuItem(value: "10", child: Text("October")),
    DropdownMenuItem(value: "11", child: Text("November")),
    DropdownMenuItem(value: "12", child: Text("December")),
  ];

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
                    UiHelper.CustTopBar(title: "Doctor Collection",),

                    const SizedBox(height: 20,),

                    Row(children: [
                      Expanded(
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
                                        dateCtrl.text = formattedDate;
                                      });

                                    }
                                  },
                                  child: Icon(Icons.search,))
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: TextField(
                          controller: doctorCtrl,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Select Doctor Name",
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
                              suffixIcon: IconButton(onPressed: ()=>UiHelper.CustEditableDropDown(context, (data)=>doctorCtrl.text=data,CaseEnteryData.doctorList), icon: Icon(Icons.arrow_drop_down_circle_outlined))

                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      UiHelper.CustDropDown(label: "Select Month", defaultValue: "0", list: monthList, onChanged: (val){
                        setState(() {
                          Selectedmonth = val!;
                        });
                      }),
                      const SizedBox(width: 10,),
                      UiHelper.CustDropDown(label: "Select Year", defaultValue: "0", list: yearList, onChanged: (val){
                        setState(() {
                          Selectedyear = val!;
                        });
                      }),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap: ()=>context.read<DoctorCollectionCubit>().getDoctorCollection(date: dateCtrl.text,month: Selectedmonth,year: Selectedyear,doctor: doctorCtrl.text),
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),color: Colors.green),
                          child: Center(child: UiHelper.CustText(text: "Search Doctor",color: Colors.white,size: 11.sp)),
                        ),
                      ),

                    ],),

                    BlocBuilder<DoctorCollectionCubit, DoctorCollectionState>(
                      builder: (context, state) {
                        if(state is DoctorCollectionLoadingState){
                          return Center(child: CircularProgressIndicator());
                        }
                        if(state is DoctorCollectionErrorState){
                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                        }
                        if(state is DoctorCollectionLoadedState){

                          var list = state.doctorCollectionModel.doctorWise;

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                                padding: const EdgeInsets.only(top: 20),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        UiHelper.CustText(
                                            text: "Total Collection : ₹${state.doctorCollectionModel.totalCollection}.00"
                                        )
                                      ],
                                    ),

                                    const SizedBox(height: 10),

                                    Center(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: Card(
                                          color: Colors.white,
                                          child: DataTable(
                                            columns: const [
                                              DataColumn(label: Text("Sl.No", style: TextStyle(fontWeight: FontWeight.bold))),
                                              DataColumn(label: Text("Doctor Name", style: TextStyle(fontWeight: FontWeight.bold))),
                                              DataColumn(label: Text("Patient Count", style: TextStyle(fontWeight: FontWeight.bold))),
                                              DataColumn(label: Text("Collection Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                                            ],
                                            rows: List.generate(list.length, (index) {
                                              var data = list[index];

                                              return DataRow(cells: [
                                                DataCell(Text("${index + 1}")),
                                                DataCell(Text(data.doctor)),
                                                DataCell(Center(child: Text(data.patientCount.toString()))),
                                                DataCell(Center(child: Text("₹${data.totalCollection}.00")))
                                              ]);
                                            }),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )

                            ),
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
                                        dateCtrl.text = formattedDate;
                                       });

                                    }
                                  },
                                  child: Icon(Icons.search,))
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      Expanded(
                        child: TextField(
                          controller: doctorCtrl,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Select Doctor Name",
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
                              suffixIcon: IconButton(onPressed: ()=>UiHelper.CustEditableDropDown(context, (data)=>doctorCtrl.text=data,CaseEnteryData.doctorList), icon: Icon(Icons.arrow_drop_down_circle_outlined))

                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      UiHelper.CustDropDown(label: "Select Month", defaultValue: "0", list: monthList, onChanged: (val){
                        setState(() {
                          Selectedmonth = val!;
                        });
                      }),
                      const SizedBox(width: 10,),
                      UiHelper.CustDropDown(label: "Select Year", defaultValue: "0", list: yearList, onChanged: (val){
                        setState(() {
                          Selectedyear = val!;
                        });
                      }),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap: ()=>context.read<DoctorCollectionCubit>().getDoctorCollection(date: dateCtrl.text,month: Selectedmonth,year: Selectedyear,doctor: doctorCtrl.text),
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),color: Colors.green),
                          child: Center(child: UiHelper.CustText(text: "Search Doctor",color: Colors.white,size: 11.sp)),
                        ),
                      ),

                    ],),
                    
                    BlocBuilder<DoctorCollectionCubit, DoctorCollectionState>(
                      builder: (context, state) {
                        if(state is DoctorCollectionLoadingState){
                          return Center(child: CircularProgressIndicator());
                        }
                        if(state is DoctorCollectionErrorState){
                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                        }
                        if(state is DoctorCollectionLoadedState){

                          var list = state.doctorCollectionModel.doctorWise;

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Column(
                            children: [
                            Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                UiHelper.CustText(
                                    text: "Total Collection : ₹${state.doctorCollectionModel.totalCollection}.00"
                                )
                              ],
                            ),

                            const SizedBox(height: 10),

                            Center(
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Card(
                                  color: Colors.white,
                                  child: DataTable(
                                    columns: const [
                                      DataColumn(label: Text("Sl.No", style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text("Doctor Name", style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text("Patient Count", style: TextStyle(fontWeight: FontWeight.bold))),
                                      DataColumn(label: Text("Collection Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                                    ],
                                    rows: List.generate(list.length, (index) {
                                      var data = list[index];

                                      return DataRow(cells: [
                                        DataCell(Text("${index + 1}")),
                                        DataCell(Text(data.doctor)),
                                        DataCell(Center(child: Text(data.patientCount.toString()))),
                                        DataCell(Center(child: Text("₹${data.totalCollection}.00")))
                                      ]);
                                    }),
                                  ),
                                ),
                              ),
                            ),
                            ],
                          )

                            ),
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
