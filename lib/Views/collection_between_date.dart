import 'package:care_lab_software/Controllers/BetweenDateCtrl/between_date_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:sizer/sizer.dart';

import '../Helpers/uiHelper.dart';
import 'loginscreen.dart';

class CollectionBetweenDate extends StatefulWidget {
  const CollectionBetweenDate({super.key});

  @override
  State<CollectionBetweenDate> createState() => _CollectionBetweenDateState();
}

class _CollectionBetweenDateState extends State<CollectionBetweenDate> {

  TextEditingController startDateCtrl = TextEditingController(text: "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}");
  TextEditingController endDateCtrl = TextEditingController(text: "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}");

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String accessCode = args["code"];

    if(accessCode != "/collection_between_date"){

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
              child: UiHelper.custHorixontalTab(container: "6",context: context),
            ),
            //MAIN CONTENT
            Container(
              height: Adaptive.h(100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Collection Between Dates",),

                    const SizedBox(height: 20,),

                    Row(children: [
                      Expanded(
                        child: TextField(
                          controller: startDateCtrl,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Select Start Date",
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
                                        startDateCtrl.text = formattedDate;
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
                          controller: endDateCtrl,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Select End Date",
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
                                        endDateCtrl.text = formattedDate;
                                      });

                                    }
                                  },
                                  child: Icon(Icons.search,))
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap: ()=>context.read<BetweenDateCubit>().getBetweenDate(startDate: startDateCtrl.text,endDate: endDateCtrl.text,),
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),color: Colors.green),
                          child: Center(child: UiHelper.CustText(text: "Search Collection",color: Colors.white,size: 11.sp)),
                        ),
                      ),

                    ],),

                    BlocBuilder<BetweenDateCubit, BetweenDateState>(
                      builder: (context, state) {
                        if(state is BetweenDateLoadingState){
                          return Center(child: CircularProgressIndicator());
                        }
                        if(state is BetweenDateErrorState){
                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                        }
                        if(state is BetweenDateLoadedState){

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Card(
                              color: Colors.white,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text("Start Date", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                  DataColumn(label: Text("End Date", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                  DataColumn(label: Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                  DataColumn(label: Text("Total Collection", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                  DataColumn(label: Text("Total Due", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                  DataColumn(label: Text("Total Patient", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                  DataColumn(label: Text("Online Collection", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                  DataColumn(label: Text("Cash Collection", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                ],
                                rows: [
                                  DataRow(cells: [
                                    DataCell(UiHelper.CustText(text: state.betweenDatesModel.startDate,size: 12.sp)),
                                    DataCell(UiHelper.CustText(text: state.betweenDatesModel.endDate,size: 12.sp)),
                                    DataCell(UiHelper.CustText(text: state.betweenDatesModel.totalAmount.toString(),size: 12.sp)),
                                    DataCell(UiHelper.CustText(text: state.betweenDatesModel.totalCollection.toString(),size: 12.sp)),
                                    DataCell(UiHelper.CustText(text: state.betweenDatesModel.totalDue.toString(),size: 12.sp)),
                                    DataCell(UiHelper.CustText(text: state.betweenDatesModel.totalPatients.toString(),size: 12.sp)),
                                    DataCell(UiHelper.CustText(text: state.betweenDatesModel.paymentModeWise[0].totalCollection.toString(),size: 12.sp)),
                                    DataCell(UiHelper.CustText(text: state.betweenDatesModel.paymentModeWise[1].totalCollection.toString(),size: 12.sp)),
                                  ])
                                ],
                              ),
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
              child: UiHelper.custsidebar(container: "12",context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Collection Between Dates",),

                    const SizedBox(height: 20,),

                    Row(children: [
                      Expanded(
                        child: TextField(
                          controller: startDateCtrl,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Select Start Date",
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
                                        startDateCtrl.text = formattedDate;
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
                          controller: endDateCtrl,
                          style: TextStyle(color: Colors.black),
                          decoration: InputDecoration(
                              labelText: "Select End Date",
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
                                        endDateCtrl.text = formattedDate;
                                      });

                                    }
                                  },
                                  child: Icon(Icons.search,))
                          ),
                        ),
                      ),
                      const SizedBox(width: 10,),
                      GestureDetector(
                        onTap: ()=>context.read<BetweenDateCubit>().getBetweenDate(startDate: startDateCtrl.text,endDate: endDateCtrl.text,),
                        child: Container(
                          height: 50,
                          width: 200,
                          decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)),color: Colors.green),
                          child: Center(child: UiHelper.CustText(text: "Search Collection",color: Colors.white,size: 11.sp)),
                        ),
                      ),

                    ],),

                    BlocBuilder<BetweenDateCubit, BetweenDateState>(
                      builder: (context, state) {
                        if(state is BetweenDateLoadingState){
                          return Center(child: CircularProgressIndicator());
                        }
                        if(state is BetweenDateErrorState){
                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                        }
                        if(state is BetweenDateLoadedState){

                          return Card(
                            color: Colors.white,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text("Start Date", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                DataColumn(label: Text("End Date", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                DataColumn(label: Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                DataColumn(label: Text("Total Collection", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                DataColumn(label: Text("Total Due", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                DataColumn(label: Text("Total Patient", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                DataColumn(label: Text("Online Collection", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                                DataColumn(label: Text("Cash Collection", style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blueAccent))),
                              ],
                              rows: [
                                DataRow(cells: [
                                  DataCell(UiHelper.CustText(text: state.betweenDatesModel.startDate)),
                                  DataCell(UiHelper.CustText(text: state.betweenDatesModel.endDate)),
                                  DataCell(UiHelper.CustText(text: state.betweenDatesModel.totalAmount.toString())),
                                  DataCell(UiHelper.CustText(text: state.betweenDatesModel.totalCollection.toString())),
                                  DataCell(UiHelper.CustText(text: state.betweenDatesModel.totalDue.toString())),
                                  DataCell(UiHelper.CustText(text: state.betweenDatesModel.totalPatients.toString())),
                                  DataCell(UiHelper.CustText(text: state.betweenDatesModel.paymentModeWise[0].totalCollection.toString())),
                                  DataCell(UiHelper.CustText(text: state.betweenDatesModel.paymentModeWise[1].totalCollection.toString())),
                                ])
                              ],
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
