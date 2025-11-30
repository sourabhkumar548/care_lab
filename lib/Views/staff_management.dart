import 'package:care_lab_software/Controllers/StaffCtrl/cubit/staff_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../Helpers/uiHelper.dart';

class StaffManagement extends StatefulWidget {
  const StaffManagement({super.key});

  @override
  State<StaffManagement> createState() => _StaffManagementState();
}

class _StaffManagementState extends State<StaffManagement> {
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
              child: UiHelper.custHorixontalTab(
                  container: "5", context: context),
            ),
            //MAIN CONTENT
            Container(
              height: Adaptive.h(100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Staff List Management",
                        widget: ElevatedButton(onPressed: ()=> saveStaff(),
                            child: UiHelper.CustText(
                                text: "Add New Staff", size: 12.sp))),

                    const SizedBox(height: 20,),
                    Container(
                      color: Colors.blue.shade200,
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment
                            .middle,
                        border: TableBorder.all(
                            width: 0.5, color: Colors.black),
                        columnWidths: {
                          0: FlexColumnWidth(.5),
                          1: FlexColumnWidth(4),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(1),
                          4: FlexColumnWidth(1),
                          5: FlexColumnWidth(2),
                          6: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            SizedBox(
                                height: 40,
                                child: Center(child: UiHelper.CustText(
                                    text: "Sno", size: 12.sp))),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              child: UiHelper.CustText(
                                  text: "Staff Name", size: 12.sp),
                            ),
                            Center(child: UiHelper.CustText(
                                text: "Username", size: 12.sp)),
                            Center(child: UiHelper.CustText(
                                text: "Password", size: 12.sp)),
                            Center(child: UiHelper.CustText(
                                text: "Mobile", size: 12.sp)),
                            Center(child: UiHelper.CustText(
                                text: "Staff Type", size: 12.sp)),
                            Center(child: UiHelper.CustText(
                                text: "Action", size: 12.sp)),
                          ])
                        ],
                      ),
                    ),

                    BlocBuilder<StaffCubit, StaffState>(
                      builder: (context, state) {
                        if (state is StaffLoadingState) {
                          return Center(child: CircularProgressIndicator(),);
                        }
                        if (state is StaffErrorState) {
                          return Center(
                              child: UiHelper.CustText(text: state.errorMsg));
                        }
                        if (state is StaffLoadedState) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (_, index) {
                              var data = state.staff.staff![index];
                              return Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment
                                    .middle,
                                border: TableBorder.all(
                                    width: 0.5, color: Colors.grey),
                                columnWidths: {
                                  0: FlexColumnWidth(.5),
                                  1: FlexColumnWidth(4),
                                  2: FlexColumnWidth(2),
                                  3: FlexColumnWidth(1),
                                  4: FlexColumnWidth(1),
                                  5: FlexColumnWidth(2),
                                  6: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(children: [
                                    Center(child: UiHelper.CustText(
                                        text: "${index + 1}", size: 12.sp)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: UiHelper.CustText(
                                          text: data.staffName!, size: 12.sp),
                                    ),
                                    Center(child: UiHelper.CustText(
                                        text: data.username!, size: 12.sp)),
                                    Center(child: UiHelper.CustText(
                                        text: data.password!, size: 12.sp)),
                                    Center(child: UiHelper.CustText(
                                        text: data.mobile!, size: 12.sp)),
                                    Center(child: UiHelper.CustText(
                                        text: data.staffType!, size: 12.sp)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        IconButton(onPressed: () => deleteStaff(id: data.id.toString()),
                                            icon: Icon(Icons.delete,
                                              color: Colors.red,)),
                                      ],)
                                  ])
                                ],
                              );
                            }, itemCount: state.staff.staff!.length,);
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
              child: UiHelper.custsidebar(container: "7", context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Staff List Management",
                        widget: ElevatedButton(onPressed: () => saveStaff(),
                            child: UiHelper.CustText(text: "Add New Staff"))),

                    const SizedBox(height: 20,),
                    Container(
                      color: Colors.blue.shade200,
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment
                            .middle,
                        border: TableBorder.all(
                            width: 0.5, color: Colors.black),
                        columnWidths: {
                          0: FlexColumnWidth(.5),
                          1: FlexColumnWidth(6),
                          2: FlexColumnWidth(3),
                          3: FlexColumnWidth(1),
                          4: FlexColumnWidth(1),
                          5: FlexColumnWidth(3),
                          6: FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            SizedBox(
                                height: 40,
                                child: Center(
                                    child: UiHelper.CustText(text: "Sno"))),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10),
                              child: UiHelper.CustText(text: "Staff Name"),
                            ),
                            Center(child: UiHelper.CustText(text: "Username")),
                            Center(child: UiHelper.CustText(text: "Password")),
                            Center(child: UiHelper.CustText(text: "Mobile")),
                            Center(
                                child: UiHelper.CustText(text: "Staff Type")),
                            Center(child: UiHelper.CustText(text: "Action")),
                          ])
                        ],
                      ),
                    ),

                    BlocBuilder<StaffCubit, StaffState>(
                      builder: (context, state) {
                        if (state is StaffLoadingState) {
                          return Center(child: CircularProgressIndicator(),);
                        }
                        if (state is StaffErrorState) {
                          return Center(
                              child: UiHelper.CustText(text: state.errorMsg));
                        }
                        if (state is StaffLoadedState) {
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (_, index) {
                              var data = state.staff.staff![index];
                              return Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment
                                    .middle,
                                border: TableBorder.all(
                                    width: 0.5, color: Colors.grey),
                                columnWidths: {
                                  0: FlexColumnWidth(.5),
                                  1: FlexColumnWidth(6),
                                  2: FlexColumnWidth(3),
                                  3: FlexColumnWidth(1),
                                  4: FlexColumnWidth(1),
                                  5: FlexColumnWidth(3),
                                  6: FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(children: [
                                    Center(child: UiHelper.CustText(
                                        text: "${index + 1}")),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: UiHelper.CustText(
                                          text: data.staffName!),
                                    ),
                                    Center(child: UiHelper.CustText(
                                        text: data.username!)),
                                    Center(child: UiHelper.CustText(
                                        text: data.password!)),
                                    Center(child: UiHelper.CustText(
                                        text: data.mobile!)),
                                    Center(child: UiHelper.CustText(
                                        text: data.staffType!)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment
                                          .spaceEvenly,
                                      children: [
                                        IconButton(onPressed: () => deleteStaff(id: data.id.toString()),
                                            icon: Icon(Icons.delete,
                                              color: Colors.red,)),
                                      ],)
                                  ])
                                ],
                              );
                            }, itemCount: state.staff.staff!.length,);
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


  saveStaff() {

    List<DropdownMenuItem<String>> typeList = [
      DropdownMenuItem(value: "Admin", child: Text("Admin")),
      DropdownMenuItem(value: "Lab", child: Text("Lab")),
      DropdownMenuItem(value: "Counter", child: Text("Counter")),
    ];

    String type = "Admin";

    TextEditingController nameCtrl = TextEditingController();
    TextEditingController usernameCtrl = TextEditingController();
    TextEditingController passwordCtrl = TextEditingController();
    TextEditingController mobileCtrl = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: UiHelper.CustText(text: "Add New Staff", size: 11.sp),
          content: SizedBox(
            height: 500,
            width: 500,
            child: ListView(
              shrinkWrap: true,
              children: [

                TextField(
                  controller: nameCtrl,
                  enabled: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      labelText: "Enter Staff Name",
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
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: usernameCtrl,
                  enabled: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      labelText: "Enter Username",
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
                  ),
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: passwordCtrl,
                  obscureText: true,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      labelText: "Enter Password",
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
                      prefixIcon: Icon(Icons.password),
                  ),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField(
                  style: TextStyle(color: Colors.black),
                  decoration:  InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.black45, width: 1.5),
                    ),
                    labelText: "Select Staff Type",
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    labelStyle: TextStyle(color: Colors.black,fontFamily: 'font-bold',fontSize: 11.sp),
                    prefixIcon: Icon(Icons.local_hospital_outlined),
                  ),
                  items: typeList,
                  onChanged: (val){
                    setState(() {
                      type = val!;
                    });
                  },
                  value: "Admin",
                ),
                const SizedBox(height: 15),
                TextField(
                  controller: mobileCtrl,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                      labelText: "Enter Mobile Number",
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
                      prefixIcon: Icon(Icons.phone_android),
                  ),
                ),


              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
                child: const Text("Cancel"),
                onPressed: () {
                  nameCtrl.clear();
                  usernameCtrl.clear();
                  passwordCtrl.clear();
                  mobileCtrl.clear();
                  Navigator.of(context).pop(false);
                }
            ),
            BlocConsumer<StaffCubit, StaffState>(
              listener: (context, state) {
                if (state is StaffSaveState) {
                  Navigator.pushNamed(context, "/staff_list_management");
                  UiHelper.showSuccessToste(message: state.successMsg);
                }
                if (state is StaffErrorState) {
                  UiHelper.showErrorToste(message: state.errorMsg);
                }
              },
              builder: (context, state) {
                if (state is StaffLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  child: const Text("Save"),
                  onPressed: () {
                    context.read<StaffCubit>().SaveStaff(
                        name: nameCtrl.text,
                        username: usernameCtrl.text,
                        password: passwordCtrl.text,
                        type: type,
                        mobile: mobileCtrl.text);
                    nameCtrl.clear();
                    usernameCtrl.clear();
                    passwordCtrl.clear();
                    mobileCtrl.clear();
                  },
                );
              },
            )
          ],
        );
      },
    );
  }

  deleteStaff({required String id}){

    showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap a button
      builder: (BuildContext context) {
        return AlertDialog(
          title: UiHelper.CustText(text: "Delete Staff",size: 10.5.sp),
          content: Text("Are you sure to delete this record ?"),
          actions: <Widget>[
            TextButton(
              child: const Text("No"),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            BlocConsumer<StaffCubit, StaffState>(
              listener: (context, state) {
                if (state is StaffSaveState) {
                  Navigator.pushNamed(context, "/staff_list_management");
                  UiHelper.showSuccessToste(message: state.successMsg);
                }
                if (state is StaffErrorState) {
                  UiHelper.showErrorToste(message: state.errorMsg);
                }
              },
              builder: (context, state) {
                if (state is StaffLoadingState) {
                  return Center(child: CircularProgressIndicator());
                }
                return ElevatedButton(
                  child: const Text("Yes"),
                  onPressed: ()=> context.read<StaffCubit>().DeleteStaff(id: id),
                );
              },
            )

          ],
        );
      },
    );

  }

}