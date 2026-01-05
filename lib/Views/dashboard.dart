import 'package:care_lab_software/Controllers/DuePaidCtrl/due_paid_cubit.dart';
import 'package:care_lab_software/Controllers/RevenueCtrl/revenue_cubit.dart';
import 'package:care_lab_software/Controllers/TodayCollectionCtrl/today_collection_cubit.dart';
import 'package:care_lab_software/Helpers/data_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:sizer/sizer.dart';
import '../Helpers/uiHelper.dart';
import 'loginscreen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {


  TextEditingController dateCtrl = TextEditingController(text: "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}");

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    context.read<RevenueCubit>()..getRevenueDetail(get_today: "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",get_month: DateTime.now().month.toString(),get_year: DateTime.now().year.toString());
  }

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String accessCode = args["code"];

    if(accessCode != "/dashboard"){

      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>LabLoginScreen()), (val)=>true);

    }

    DateTime now = DateTime.now();
    String month = DateFormat('MMMM').format(now);
    int year = now.year;

    GetStorage userBox = GetStorage();
    String? userType = userBox.read("userType");
    String? userName = userBox.read("userName");


    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: Device.width < 1100 ?

      Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    child: UiHelper.custHorixontalTab(container: "1", context: context),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Lab Info
                        UiHelper.CustTopBar(
                          title: "Care Diagnostics Centre",
                        ),
                        const SizedBox(height: 20),

                        // Account Information Cards
                        BlocBuilder<RevenueCubit, RevenueState>(
                          builder: (context, state) {
                            if (state is RevenueLoadingState) {
                              return Center(child: CircularProgressIndicator());
                            }
                            if (state is RevenueErrorState) {
                              return Center(child: UiHelper.CustText(text: state.errorMsg));
                            }
                            if (state is RevenueLoadedState) {
                              return GridView.count(
                                crossAxisCount: 2,
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                                childAspectRatio: 1.5,
                                children: [
                                  UiHelper.infoCardMobile("Today's Patient", "${state.revenueModel.today!.patients}", Colors.blue, Icons.people),
                                  UiHelper.infoCardMobile("Today's Revenue", "₹${state.revenueModel.today!.totalCollection!.toString()}", Colors.red, Icons.wallet),
                                  UiHelper.infoCardMobile("Patient in ${month}", "${userType == "Admin" ? state.revenueModel.selectedMonth!.patients : ""}", Colors.green, Icons.event),
                                  UiHelper.infoCardMobile("Revenue in ${month}", "${userType == "Admin" ? "₹${state.revenueModel.selectedMonth!.revenue}" : ""}", Colors.orange, Icons.currency_rupee),
                                  UiHelper.infoCardMobile("Patient in ${year}", "${userType == "Admin" ? state.revenueModel.selectedYear!.patients : ""}", Colors.blue, Icons.people_alt),
                                  UiHelper.infoCardMobile("Revenue in ${year}", "${userType == "Admin" ? "₹${state.revenueModel.selectedYear!.revenue}" : ""}", Colors.red, Icons.wallet),
                                  UiHelper.infoCardMobile("Due Amt in ${month}", "${userType == "Admin" ? "₹${state.revenueModel.pendingTotalThisMonth!}" : ""}", Colors.red, Icons.currency_rupee),
                                  UiHelper.infoCardMobile("Due Amt in ${year}", "${userType == "Admin" ? "₹${state.revenueModel.pendingTotalThisYear!}" : ""}", Colors.red, Icons.currency_rupee),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),

                        const SizedBox(height: 15),

                        // Today's Patient Table
                        UiHelper.Custcard(
                          title: "Today's Patient",
                          child: BlocBuilder<RevenueCubit, RevenueState>(
                            builder: (context, state) {
                              if (state is RevenueLoadingState) {
                                return Center(child: CircularProgressIndicator());
                              }
                              if (state is RevenueErrorState) {
                                return Center(child: UiHelper.CustText(text: state.errorMsg));
                              }
                              if (state is RevenueLoadedState) {
                                var list = state.revenueModel.today!.details!;
                                return ScrollableTable(list: list);
                              }
                              return Container();
                            },
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Today's Revenue Details
                        UiHelper.CustcardMobile(
                          title: "Today's Revenue Details",
                          trailing: SizedBox(
                            width: double.infinity,
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
                                  labelStyle: TextStyle(
                                    color: Colors.black,
                                    fontFamily: 'font-bold',
                                    fontSize: 16.sp,
                                  ),
                                  prefixIcon: Icon(Icons.calendar_month),
                                  suffixIcon: GestureDetector(
                                    onTap: () async {
                                      DateTime? pickedDate = await showOmniDateTimePicker(
                                        context: context,
                                        type: OmniDateTimePickerType.date,
                                      );

                                      if (pickedDate != null) {
                                        String formattedDate = "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                                        setState(() {
                                          dateCtrl.text = formattedDate;
                                          String date = formattedDate;
                                          List<String> parts = date.split('-');
                                          int month = int.parse(parts[1]);
                                          int year = int.parse(parts[2]);
                                          context.read<RevenueCubit>().getRevenueDetail(
                                            get_today: formattedDate,
                                            get_month: month.toString(),
                                            get_year: year.toString(),
                                          );
                                        });
                                      }
                                    },
                                    child: Icon(Icons.search),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          child: BlocBuilder<RevenueCubit, RevenueState>(
                            builder: (context, state) {
                              if (state is RevenueLoadingState) {
                                return Center(child: CircularProgressIndicator());
                              }
                              if (state is RevenueErrorState) {
                                return Center(child: UiHelper.CustText(text: state.errorMsg));
                              }
                              if (state is RevenueLoadedState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Total Patient & Total Amount
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            color: Colors.grey.shade100,
                                            child: ListTile(
                                              title: UiHelper.CustText(
                                                text: "Total Patient",
                                                color: Colors.green,
                                                size: 15.sp,
                                              ),
                                              subtitle: UiHelper.CustText(
                                                text: state.revenueModel.today!.patients.toString(),
                                                color: Colors.black,
                                                size: 15.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: Colors.grey.shade100,
                                            child: ListTile(
                                              title: UiHelper.CustText(
                                                text: "Total Amount",
                                                color: Colors.green,
                                                size: 15.sp,
                                              ),
                                              subtitle: UiHelper.CustText(
                                                text: "₹${state.revenueModel.today!.totalAmount}.00",
                                                color: Colors.black,
                                                size: 15.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Total Collection & Total Due
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Card(
                                            color: Colors.grey.shade100,
                                            child: ListTile(
                                              title: UiHelper.CustText(
                                                text: "Total Collection",
                                                color: Colors.green,
                                                size: 15.sp,
                                              ),
                                              subtitle: UiHelper.CustText(
                                                text: "₹${state.revenueModel.today!.totalCollection}.00",
                                                color: Colors.black,
                                                size: 15.sp,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: Card(
                                            color: Colors.grey.shade100,
                                            child: Center(
                                              child: ListTile(
                                                title: UiHelper.CustText(
                                                  text: "Total Due",
                                                  color: Colors.green,
                                                  size: 15.sp,
                                                ),
                                                subtitle: UiHelper.CustText(
                                                  text: "₹${state.revenueModel.today!.totalDue}.00",
                                                  color: Colors.black,
                                                  size: 15.sp,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    // Payment Modes
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: state.revenueModel.paymentModes!.length,
                                      itemBuilder: (_, index) {
                                        final mode = state.revenueModel.paymentModes![index];

                                        if (mode.payMode == null || mode.payMode!.isEmpty) {
                                          return SizedBox.shrink();
                                        }

                                        return Card(
                                          color: Colors.grey.shade100,
                                          child: ListTile(
                                            title: Text(
                                              "${mode.payMode} Collection",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                            subtitle: Text(
                                              "₹${mode.total}.00",
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp,
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                );
                              }
                              return Container();
                            },
                          ),
                        ),

                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )
          :
      Row(
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
                        UiHelper.CustTopBar(title: "Care Diagnostics Centre",widget: Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: UiHelper.CustText(text: "Welcome $userName",size: 12.sp,color: Colors.blue.shade900),
                        )),
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
                                  UiHelper.infoCard("Patient in ${month}", "${userType == "Admin" ? state.revenueModel.selectedMonth!.patients : ""}", Colors.green, Icons.event),
                                  UiHelper.infoCard("Revenue in ${month}", "${userType == "Admin" ? "₹${state.revenueModel.selectedMonth!.revenue}" : ""}", Colors.orange, Icons.currency_rupee),
                                  UiHelper.infoCard("Patient in ${year}", "${userType == "Admin" ? state.revenueModel.selectedYear!.patients : ""}", Colors.blue, Icons.people_alt),
                                  UiHelper.infoCard("Revenue in ${year}", "${userType == "Admin" ? "₹${state.revenueModel.selectedYear!.revenue}" : ""}",Colors.red, Icons.wallet),
                                  UiHelper.infoCard("Due Amt in ${month}", "${userType == "Admin" ? "₹${state.revenueModel.pendingTotalThisMonth!}" : ""}",Colors.red, Icons.currency_rupee),
                                  UiHelper.infoCard("Due Amt in ${year}", "${userType == "Admin" ? "₹${state.revenueModel.pendingTotalThisYear!}" : ""}",Colors.red, Icons.currency_rupee),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),

                        const SizedBox(height: 15),

                        ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 500,
                            minWidth: Adaptive.w(100),
                            maxWidth: Adaptive.w(100)
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            children: [
                              Container(
                                width: Adaptive.w(100),
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

                                          return ScrollableTable(list: list);


                                        }

                                        return Container();
                                      },
                                    ),)),
                              ),
                            ],),
                        ),

                        Container(
                          width: Adaptive.w(90),
                          child: Row(children: [

                            //TODAY REVENUE DETAILS

                            Expanded(
                              child: Container(
                                  width : Adaptive.w(45),
                                  height: 300,
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

                                                          context.read<TodayCollectionCubit>().getCollection(date: formattedDate);
                                                          context.read<DuePaidCubit>().getDueCollection(date: formattedDate);

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
                                    child: BlocBuilder<TodayCollectionCubit, TodayCollectionState>(
                                      builder: (context, state) {
                                        if(state is TodayCollectionLoadingState){
                                          return Center(child: CircularProgressIndicator());
                                        }
                                        if(state is TodayCollectionErrorState){
                                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                                        }
                                        if(state is TodayCollectionLoadedState){
                                          return ListView(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            children: [
                                              // ------- TOP SUMMARY ROW 1 -------
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Card(
                                                      color: Colors.grey.shade100,
                                                      child: ListTile(
                                                        title: UiHelper.CustText(
                                                            text: "Total Patient",
                                                            color: Colors.green,
                                                            size: 11.sp),
                                                        trailing: UiHelper.CustText(
                                                            text: state.todayCollectionModel.patientCount.toString(),
                                                            color: Colors.black,
                                                            size: 11.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Card(
                                                      color: Colors.grey.shade100,
                                                      child: ListTile(
                                                        title: UiHelper.CustText(
                                                            text: "Total Amount",
                                                            color: Colors.green,
                                                            size: 11.sp),
                                                        trailing: UiHelper.CustText(
                                                            text: "₹${state.todayCollectionModel.totalAmount}.00",
                                                            color: Colors.black,
                                                            size: 11.sp),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              // ------- TOP SUMMARY ROW 2 -------
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Card(
                                                      color: Colors.grey.shade100,
                                                      child: ListTile(
                                                        title: UiHelper.CustText(
                                                            text: "Total Collection",
                                                            color: Colors.green,
                                                            size: 11.sp),
                                                        trailing: UiHelper.CustText(
                                                            text: "₹${state.todayCollectionModel.paidAmount}.00",
                                                            color: Colors.black,
                                                            size: 11.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Card(
                                                      color: Colors.grey.shade100,
                                                      child: ListTile(
                                                        title: UiHelper.CustText(
                                                            text: "Total Due",
                                                            color: Colors.green,
                                                            size: 11.sp),
                                                        trailing: UiHelper.CustText(
                                                            text: "₹${state.todayCollectionModel.dueAmount}.00",
                                                            color: Colors.black,
                                                            size: 11.sp),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              const SizedBox(height: 20,),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Card(
                                                      color: Colors.grey.shade100,
                                                      child: ListTile(
                                                        title: UiHelper.CustText(
                                                            text: "Cash Collection",
                                                            color: Colors.green,
                                                            size: 11.sp),
                                                        trailing: UiHelper.CustText(
                                                            text: "₹${state.todayCollectionModel.cash}.00",
                                                            color: Colors.black,
                                                            size: 11.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Card(
                                                      color: Colors.grey.shade100,
                                                      child: ListTile(
                                                        title: UiHelper.CustText(
                                                            text: "Online Collection",
                                                            color: Colors.green,
                                                            size: 11.sp),
                                                        trailing: UiHelper.CustText(
                                                            text: "₹${state.todayCollectionModel.online}.00",
                                                            color: Colors.black,
                                                            size: 11.sp),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          );

                                        }
                                        return Container();
                                      },
                                    ),
                                  ))),
                            ),

                            //DUE PAID DETAIL

                            Expanded(
                              child: Container(
                                  width : Adaptive.w(45),
                                  height: 300,
                                  child: UiHelper.Custcard(title: "Due Paid Details",
                                      child: Container(
                                    child: BlocBuilder<DuePaidCubit, DuePaidState>(
                                      builder: (context, state) {
                                        if(state is DuePaidLoadingState){
                                          return Center(child: CircularProgressIndicator());
                                        }
                                        if(state is DuePaidErrorState){
                                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                                        }
                                        if(state is DuePaidLoadedState){
                                          return ListView(
                                            shrinkWrap: true,
                                            physics: NeverScrollableScrollPhysics(),
                                            children: [
                                              // ------- TOP SUMMARY ROW 1 -------
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Card(
                                                      color: Colors.grey.shade100,
                                                      child: ListTile(
                                                        title: UiHelper.CustText(
                                                            text: "Total Patient",
                                                            color: Colors.green,
                                                            size: 11.sp),
                                                        trailing: UiHelper.CustText(
                                                            text: state.dueCollectionModel.patientCount.toString(),
                                                            color: Colors.black,
                                                            size: 11.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Card(
                                                      color: Colors.grey.shade100,
                                                      child: ListTile(
                                                        title: UiHelper.CustText(
                                                            text: "Total Amount",
                                                            color: Colors.green,
                                                            size: 11.sp),
                                                        trailing: UiHelper.CustText(
                                                            text: "₹${state.dueCollectionModel.totalDueCollection}.00",
                                                            color: Colors.black,
                                                            size: 11.sp),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                              // ------- TOP SUMMARY ROW 2 -------

                                              const SizedBox(height: 20,),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Card(
                                                      color: Colors.grey.shade100,
                                                      child: ListTile(
                                                        title: UiHelper.CustText(
                                                            text: "Due Cash Collection",
                                                            color: Colors.green,
                                                            size: 11.sp),
                                                        trailing: UiHelper.CustText(
                                                            text: "₹${state.dueCollectionModel.dueInCash}.00",
                                                            color: Colors.black,
                                                            size: 11.sp),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Card(
                                                      color: Colors.grey.shade100,
                                                      child: ListTile(
                                                        title: UiHelper.CustText(
                                                            text: "Due Online Collection",
                                                            color: Colors.green,
                                                            size: 11.sp),
                                                        trailing: UiHelper.CustText(
                                                            text: "₹${state.dueCollectionModel.dueInOnline}.00",
                                                            color: Colors.black,
                                                            size: 11.sp),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          );

                                        }
                                        return Container();
                                      },
                                    ),
                                  ))),
                            ),

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
