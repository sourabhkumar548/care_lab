import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../Controllers/AgentCtrl/cubit/agent_cubit.dart';
import '../Helpers/uiHelper.dart';
import 'loginscreen.dart';

class AgentManagement extends StatelessWidget {
  const AgentManagement({super.key});

  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String accessCode = args["code"];

    if(accessCode != "/agent_list_management"){

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
                    UiHelper.CustTopBar(title: "Agent List Management",widget: ElevatedButton(onPressed: (){}, child: UiHelper.CustText(text: "Add New Agent",size: 12.sp))),

                    const SizedBox(height: 20,),
                    Container(
                      color: Colors.blue.shade200,
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        border: TableBorder.all(width: 0.5, color: Colors.black),
                        columnWidths: {
                          0 : FlexColumnWidth(.5),
                          1 : FlexColumnWidth(5),
                          2 : FlexColumnWidth(2),
                          3 : FlexColumnWidth(5),
                          4 : FlexColumnWidth(2),
                          6 : FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            SizedBox(
                                height: 40,
                                child: Center(child: UiHelper.CustText(text: "Sno",size: 12.sp))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: UiHelper.CustText(text: "Agent Name",size: 12.sp),
                            ),
                            Center(child: UiHelper.CustText(text: "Mobile",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Address",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Sop Name",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Action",size: 12.sp)),
                          ])
                        ],
                      ),
                    ),

                    BlocBuilder<AgentCubit, AgentState>(
                      builder: (context, state) {
                        if(state is AgentLoadingState){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        if(state is AgentErrorState){
                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                        }
                        if(state is AgentLoadedState){
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (_,index){
                              var data = state.agentModel.agent![index];
                              return Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                border: TableBorder.all(width: 0.5, color: Colors.grey),
                                columnWidths: {
                                  0 : FlexColumnWidth(.5),
                                  1 : FlexColumnWidth(5),
                                  2 : FlexColumnWidth(2),
                                  3 : FlexColumnWidth(5),
                                  4 : FlexColumnWidth(2),
                                  6 : FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(children: [
                                    Center(child: UiHelper.CustText(text: "${index+1}",size: 12.sp)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: UiHelper.CustText(text: data.agentName!,size: 12.sp),
                                    ),
                                    Center(child: UiHelper.CustText(text: data.mobile!,size: 12.sp)),
                                    Center(child: UiHelper.CustText(text: data.address!,size: 12.sp)),
                                    Center(child: UiHelper.CustText(text: data.shopName!,size: 12.sp)),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly  ,
                                      children: [
                                        IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.green,)),
                                        IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.red,)),
                                      ],)
                                  ])
                                ],
                              );
                            },itemCount: state.agentModel.agent!.length,);
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
              child: UiHelper.custsidebar(container: "6",context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Agent List Management",widget: ElevatedButton(onPressed: (){}, child: UiHelper.CustText(text: "Add New Agent"))),

                    const SizedBox(height: 20,),
                    Container(
                      color: Colors.blue.shade200,
                      child: Table(
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        border: TableBorder.all(width: 0.5, color: Colors.black),
                        columnWidths: {
                          0 : FlexColumnWidth(.5),
                          1 : FlexColumnWidth(6),
                          2 : FlexColumnWidth(1),
                          3 : FlexColumnWidth(6),
                          4 : FlexColumnWidth(2),
                          6 : FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            SizedBox(
                                height: 40,
                                child: Center(child: UiHelper.CustText(text: "Sno"))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: UiHelper.CustText(text: "Agent Name"),
                            ),
                            Center(child: UiHelper.CustText(text: "Mobile")),
                            Center(child: UiHelper.CustText(text: "Address")),
                            Center(child: UiHelper.CustText(text: "Sop Name")),
                            Center(child: UiHelper.CustText(text: "Action")),
                          ])
                        ],
                      ),
                    ),

                    BlocBuilder<AgentCubit, AgentState>(
                      builder: (context, state) {
                        if(state is AgentLoadingState){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        if(state is AgentErrorState){
                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                        }
                        if(state is AgentLoadedState){
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (_,index){
                              var data = state.agentModel.agent![index];
                              return Table(
                                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                                border: TableBorder.all(width: 0.5, color: Colors.grey),
                                columnWidths: {
                                  0 : FlexColumnWidth(.5),
                                  1 : FlexColumnWidth(6),
                                  2 : FlexColumnWidth(1),
                                  3 : FlexColumnWidth(6),
                                  4 : FlexColumnWidth(2),
                                  6 : FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(children: [
                                    Center(child: UiHelper.CustText(text: "${index+1}")),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: UiHelper.CustText(text: data.agentName!),
                                    ),
                                    Center(child: UiHelper.CustText(text: data.mobile!)),
                                    Center(child: UiHelper.CustText(text: data.address!)),
                                    Center(child: UiHelper.CustText(text: data.shopName!)),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly  ,
                                      children: [
                                        IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.green,)),
                                        IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.red,)),
                                      ],)
                                  ])
                                ],
                              );
                            },itemCount: state.agentModel.agent!.length,);
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
