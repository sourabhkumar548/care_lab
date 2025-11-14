import 'package:care_lab_software/Controllers/StaffCtrl/cubit/staff_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../Helpers/uiHelper.dart';

class StaffManagement extends StatelessWidget {
  const StaffManagement({super.key});

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
              child: UiHelper.custHorixontalTab(container: "5",context: context),
            ),
            //MAIN CONTENT
            Container(
              height: Adaptive.h(100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Staff List Management",widget: ElevatedButton(onPressed: (){}, child: UiHelper.CustText(text: "Add New Staff",size: 12.sp))),

                    const SizedBox(height: 20,),
                    Container(
                      color: Colors.blue.shade200,
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        border: TableBorder.all(width: 0.5, color: Colors.black),
                        columnWidths: {
                          0 : FlexColumnWidth(.5),
                          1 : FlexColumnWidth(4),
                          2 : FlexColumnWidth(2),
                          3 : FlexColumnWidth(1),
                          4 : FlexColumnWidth(1),
                          5 : FlexColumnWidth(2),
                          6 : FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            SizedBox(
                                height: 40,
                                child: Center(child: UiHelper.CustText(text: "Sno",size: 12.sp))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: UiHelper.CustText(text: "Staff Name",size: 12.sp),
                            ),
                            Center(child: UiHelper.CustText(text: "Username",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Password",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Mobile",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Staff Type",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Action",size: 12.sp)),
                          ])
                        ],
                      ),
                    ),

                    BlocBuilder<StaffCubit, StaffState>(
                      builder: (context, state) {
                        if(state is StaffLoadingState){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        if(state is StaffErrorState){
                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                        }
                        if(state is StaffLoadedState){
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (_,index){
                              var data = state.staff.staff![index];
                              return Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                border: TableBorder.all(width: 0.5, color: Colors.grey),
                                columnWidths: {
                                  0 : FlexColumnWidth(.5),
                                  1 : FlexColumnWidth(4),
                                  2 : FlexColumnWidth(2),
                                  3 : FlexColumnWidth(1),
                                  4 : FlexColumnWidth(1),
                                  5 : FlexColumnWidth(2),
                                  6 : FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(children: [
                                    Center(child: UiHelper.CustText(text: "${index+1}",size: 12.sp)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: UiHelper.CustText(text: data.staffName!,size: 12.sp),
                                    ),
                                    Center(child: UiHelper.CustText(text: data.username!,size: 12.sp)),
                                    Center(child: UiHelper.CustText(text: data.password!,size: 12.sp)),
                                    Center(child: UiHelper.CustText(text: data.mobile!,size: 12.sp)),
                                    Center(child: UiHelper.CustText(text: data.staffType!,size: 12.sp)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly  ,
                                      children: [
                                        IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.green,)),
                                        IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.red,)),
                                      ],)
                                  ])
                                ],
                              );
                            },itemCount: state.staff.staff!.length,);
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
              child: UiHelper.custsidebar(container: "7",context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Staff List Management",widget: ElevatedButton(onPressed: (){}, child: UiHelper.CustText(text: "Add New Staff"))),

                    const SizedBox(height: 20,),
                    Container(
                      color: Colors.blue.shade200,
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        border: TableBorder.all(width: 0.5, color: Colors.black),
                        columnWidths: {
                          0 : FlexColumnWidth(.5),
                          1 : FlexColumnWidth(6),
                          2 : FlexColumnWidth(3),
                          3 : FlexColumnWidth(1),
                          4 : FlexColumnWidth(1),
                          5 : FlexColumnWidth(3),
                          6 : FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            SizedBox(
                                height: 40,
                                child: Center(child: UiHelper.CustText(text: "Sno"))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: UiHelper.CustText(text: "Staff Name"),
                            ),
                            Center(child: UiHelper.CustText(text: "Username")),
                            Center(child: UiHelper.CustText(text: "Password")),
                            Center(child: UiHelper.CustText(text: "Mobile")),
                            Center(child: UiHelper.CustText(text: "Staff Type")),
                            Center(child: UiHelper.CustText(text: "Action")),
                          ])
                        ],
                      ),
                    ),

                    BlocBuilder<StaffCubit, StaffState>(
                      builder: (context, state) {
                        if(state is StaffLoadingState){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        if(state is StaffErrorState){
                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                        }
                        if(state is StaffLoadedState){
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (_,index){
                              var data = state.staff.staff![index];
                              return Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                border: TableBorder.all(width: 0.5, color: Colors.grey),
                                columnWidths: {
                                  0 : FlexColumnWidth(.5),
                                  1 : FlexColumnWidth(6),
                                  2 : FlexColumnWidth(3),
                                  3 : FlexColumnWidth(1),
                                  4 : FlexColumnWidth(1),
                                  5 : FlexColumnWidth(3),
                                  6 : FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(children: [
                                    Center(child: UiHelper.CustText(text: "${index+1}")),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: UiHelper.CustText(text: data.staffName!),
                                    ),
                                    Center(child: UiHelper.CustText(text: data.username!)),
                                    Center(child: UiHelper.CustText(text: data.password!)),
                                    Center(child: UiHelper.CustText(text: data.mobile!)),
                                    Center(child: UiHelper.CustText(text: data.staffType!)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly  ,
                                      children: [
                                        IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.green,)),
                                        IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.red,)),
                                      ],)
                                  ])
                                ],
                              );
                            },itemCount: state.staff.staff!.length,);
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
