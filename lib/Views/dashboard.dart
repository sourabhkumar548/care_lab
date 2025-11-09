import 'package:care_lab_software/Controllers/RevenueCtrl/revenue_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:sizer/sizer.dart';

import '../Helpers/monthly_bar_chart.dart';
import '../Helpers/uiHelper.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {


  TextEditingController dateCtrl = TextEditingController(text: "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<RevenueCubit>()..getRevenueDetail(get_today: "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",get_month: DateTime.now().month.toString(),get_year: DateTime.now().year.toString());
  }

  @override
  Widget build(BuildContext context) {

    DateTime now = DateTime.now();
    String month = DateFormat('MMMM').format(now);
    int year = now.year;

    String selectedYear = DateTime.now().year.toString();

    List<DropdownMenuItem<String>> yearList = [
      DropdownMenuItem(value: "2020", child: Text("2020")),
      DropdownMenuItem(value: "2021", child: Text("2021")),
      DropdownMenuItem(value: "2022", child: Text("2022")),
      DropdownMenuItem(value: "2023", child: Text("2023")),
      DropdownMenuItem(value: "2024", child: Text("2024")),
      DropdownMenuItem(value: "2025", child: Text("2025")),
      DropdownMenuItem(value: "2026", child: Text("2026")),
    ];

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Row(
        children: [
          // Sidebar
          UiHelper.custsidebar(container: "1",context: context),

          // Main Content
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lab Info
                        UiHelper.CustTopBar(title: "Care Diagnostics Centre"),
                        const SizedBox(height: 20),

                        // Account Information Cards
                        BlocBuilder<RevenueCubit, RevenueState>(
                          builder: (context, state) {
                            if(state is RevenueLoadingState){
                              return Center(child: CircularProgressIndicator());
                            }
                            if(state is RevenueErrorState){
                              return Center(child: UiHelper.CustText(text: state.errorMsg));
                            }
                            if(state is RevenueLoadedState){
                              return Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                children: [
                                  UiHelper.infoCard("Today’s Patient", "${state.revenueModel.today!.patients}", Colors.blue, Icons.people),
                                  UiHelper.infoCard("Today’s Revenue", "₹${state.revenueModel.today!.totalCollection!.toString()}", Colors.red, Icons.wallet),
                                  UiHelper.infoCard("Patient in ${month}", "${state.revenueModel.selectedMonth!.patients}", Colors.green, Icons.event),
                                  UiHelper.infoCard("Revenue in ${month}", "₹${state.revenueModel.selectedMonth!.revenue}", Colors.orange, Icons.currency_rupee),
                                  UiHelper.infoCard("Patient in ${year}", "${state.revenueModel.selectedYear!.patients}", Colors.blue, Icons.people_alt),
                                  UiHelper.infoCard("Revenue in ${year}", "₹${state.revenueModel.selectedYear!.revenue}",Colors.red, Icons.wallet),
                                  UiHelper.infoCard("Due Amt in ${month}", "₹${state.revenueModel.pendingTotalThisMonth!}",Colors.red, Icons.currency_rupee),
                                  UiHelper.infoCard("Due Amt in ${year}", "₹${state.revenueModel.pendingTotalThisYear!}",Colors.red, Icons.currency_rupee),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),

                        const SizedBox(height: 15),

                        Container(
                          width: Adaptive.w(90),
                          height: 300,
                          child: Row(children: [
                            Expanded(
                              child: Container(
                                width: Adaptive.w(45),
                                height: 300,
                                child: UiHelper.Custcard(title: "Today's Patient",
                                    child: Container(child:
                                    BlocBuilder<RevenueCubit, RevenueState>(
                                      builder: (context, state) {
                                        if(state is RevenueLoadingState){
                                          return Center(child: CircularProgressIndicator());
                                        }
                                        if(state is RevenueErrorState){
                                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                                        }
                                        if (state is RevenueLoadedState) {
                                          var list = state.revenueModel.today!.details!;

                                          return SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: DataTable(
                                              columns: const [
                                                DataColumn(label: Text("Sl.No", style: TextStyle(fontWeight: FontWeight.bold))),
                                                DataColumn(label: Text("Name", style: TextStyle(fontWeight: FontWeight.bold))),
                                                DataColumn(label: Text("Total Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                                                DataColumn(label: Text("Discount", style: TextStyle(fontWeight: FontWeight.bold))),
                                                DataColumn(label: Text("Paid Amount", style: TextStyle(fontWeight: FontWeight.bold))),
                                                DataColumn(label: Text("Balance", style: TextStyle(fontWeight: FontWeight.bold))),
                                              ],

                                              rows: List.generate(list.length, (index) {
                                                var data = list[index];

                                                return DataRow(cells: [
                                                  DataCell(Text("${index + 1}")),
                                                  DataCell(
                                                    Tooltip(
                                                      message: "Mobile: ${data.mobile}\nAdvance: ₹${data.advance}.00",
                                                      padding: EdgeInsets.all(10),
                                                      textStyle: TextStyle(color: Colors.white),
                                                      decoration: BoxDecoration(
                                                        color: Colors.black87,
                                                        borderRadius: BorderRadius.circular(6),
                                                      ),
                                                      child: Text(data.patientName ?? "",style: TextStyle(color: Colors.blue),),
                                                    ),
                                                  ),
                                                  DataCell(Text("₹${data.totalAmount}.00")),
                                                  DataCell(Text("₹${data.discount}.00")),
                                                  DataCell(Text("₹${data.afterDiscount}.00")),
                                                  DataCell(Text("₹${data.balance}.00")),
                                                ]);
                                              }),
                                            ),
                                          );
                                        }

                                        return Container();
                                      },
                                    ),)),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: Adaptive.w(45),
                                height: 300,
                                child: UiHelper.Custcard(title: "Report Chart of ${year}",
                                    trailing:Expanded(
                                      child: Card(
                                        elevation: 5,
                                        color: Colors.grey.shade200,
                                        child: UiHelper.CustDropDown(label: "Year", defaultValue: selectedYear, list: yearList, onChanged: (val){

                                        })
                                      ),
                                    )
                                    , child: Container(
                                  child: Expanded(
                                    child: MonthlyBarChart(
                                      months: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "jul", "Aug", "Sep", "Oct", "Nov", "Dec"],          // Month number → no 09 only 9 ✅
                                      values: [1200, 900, 1500, 1100, 800, 6000, 85000, 45888, 120000, 2000000, 500, 1000],
                                    ),
                                  )
                                  ,
                                )),
                              ),
                            )
                          ],),
                        ),

                        Container(
                          width: Adaptive.w(90),
                          child: Row(children: [
                            Expanded(
                              child: Container(
                                  width : Adaptive.w(45),
                                  height: 350,
                                  child: UiHelper.Custcard(title: "Today's Revenue Details",
                                      trailing: Expanded(
                                        child: Card(
                                          elevation: 5,
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

                                                          String date = formattedDate;
                                                          List<String> parts = date.split('-');

                                                          int month = int.parse(parts[1]);
                                                          int year = int.parse(parts[2]);

                                                          context.read<RevenueCubit>()..getRevenueDetail(get_today: formattedDate,get_month: month.toString(),get_year: year.toString());

                                                        });

                                                      }
                                                    },
                                                    child: Icon(Icons.search,))
                                            ),
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                    child: BlocBuilder<RevenueCubit, RevenueState>(
                                      builder: (context, state) {
                                        if(state is RevenueLoadingState){
                                          return Center(child: CircularProgressIndicator());
                                        }
                                        if(state is RevenueErrorState){
                                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                                        }
                                        if(state is RevenueLoadedState){


                                          return ListView(
                                            shrinkWrap: true,
                                            children: [

                                              Row(children: [
                                                Expanded(
                                                  child: Card(
                                                    color: Colors.grey.shade100,
                                                    child: ListTile(
                                                      title: UiHelper.CustText(text: "Total Patient",color: Colors.green,size: 11.sp),
                                                      trailing: UiHelper.CustText(text: state.revenueModel.today!.patients.toString(),color: Colors.black,size: 11.sp),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Card(
                                                    color: Colors.grey.shade100,
                                                    child: ListTile(
                                                      title: UiHelper.CustText(text: "Total Amount",color: Colors.green,size: 11.sp),
                                                      trailing: UiHelper.CustText(text: "₹${state.revenueModel.today!.totalAmount.toString()}.00",color: Colors.black,size: 11.sp),
                                                    ),
                                                  ),
                                                ),
                                              ],),
                                            Row(children: [
                                              Expanded(
                                                child: Card(
                                                  color: Colors.grey.shade100,
                                                  child: ListTile(
                                                    title: UiHelper.CustText(text: "Total Collection",color: Colors.green,size: 11.sp),
                                                    trailing: UiHelper.CustText(text: "₹${state.revenueModel.today!.totalCollection.toString()}.00",color: Colors.black,size: 11.sp),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Card(
                                                  color: Colors.grey.shade100,
                                                  child: ListTile(
                                                    title: UiHelper.CustText(text: "Total Due",color: Colors.green,size: 11.sp),
                                                    trailing: UiHelper.CustText(text: "₹${state.revenueModel.today!.totalDue.toString()}.00",color: Colors.black,size: 11.sp),
                                                  ),
                                                ),
                                              ),
                                            ],),

                                            BlocBuilder<RevenueCubit, RevenueState>(
                                              builder: (context, state) {
                                                if(state is RevenueLoadingState){
                                                  return Center(child: CircularProgressIndicator());
                                                }
                                                if(state is RevenueErrorState){
                                                  return Center(child: UiHelper.CustText(text: state.errorMsg));
                                                }
                                                if(state is RevenueLoadedState){
                                                  return ListView.builder(
                                                    shrinkWrap: true,
                                                      itemBuilder: (_,index){

                                                        return state.revenueModel.paymentModes![index].payMode!.isNotEmpty ? Expanded(
                                                          child: Card(
                                                            color: Colors.grey.shade100,
                                                            child: ListTile(
                                                              title: UiHelper.CustText(text: "${state.revenueModel.paymentModes![index].payMode} Collection",color: Colors.green,size: 11.sp),
                                                              trailing: UiHelper.CustText(text: "₹${state.revenueModel.paymentModes![index].total}.00",color: Colors.black,size: 11.sp),
                                                            ),
                                                          ),
                                                        ) : Container();

                                                      },itemCount: state.revenueModel.paymentModes!.length,);
                                                }
                                                return Container();
                                              },
                                            ),


                                          ],);
                                        }
                                        return Container();
                                      },
                                    ),
                                  ))),
                            ),
                            Expanded(
                              child: Container(
                                  width : Adaptive.w(45),
                                  height: 350,
                                  child: UiHelper.Custcard(title: "Staff Details", child: Container())),
                            )
                          ],),
                        )


                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
