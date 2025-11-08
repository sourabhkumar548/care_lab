import 'package:care_lab_software/Controllers/RateListCtrl/Cubit/rate_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../Helpers/uiHelper.dart';

class RateListManagement extends StatelessWidget {
  const RateListManagement({super.key});

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
              child: UiHelper.custsidebar(container: "8",context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                      UiHelper.CustTopBar(title: "Rate List Management",widget: ElevatedButton(onPressed: (){}, child: UiHelper.CustText(text: "Add Test"))),

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
                          child: UiHelper.CustText(text: "Test Name"),
                        ),
                        Center(child: UiHelper.CustText(text: "Department")),
                        Center(child: UiHelper.CustText(text: "Rate")),
                        Center(child: UiHelper.CustText(text: "Report Time")),
                        Center(child: UiHelper.CustText(text: "File")),
                        Center(child: UiHelper.CustText(text: "Action")),
                      ])
                    ],
                  ),
                ),

                    BlocBuilder<RateListCubit, RateListState>(
                      builder: (context, state) {
                        if(state is RateListLoadingState){
                          return Center(child: CircularProgressIndicator(),);
                        }
                        if(state is RateListErrorState){
                          return Center(child: UiHelper.CustText(text: state.errorMsg));
                        }
                        if(state is RateListLoadedState){
                          return ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (_,index){
                            var data = state.rateListModel.rateList![index];
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
                                    child: UiHelper.CustText(text: data.testName!),
                                  ),
                                  Center(child: UiHelper.CustText(text: data.department!)),
                                  Center(child: UiHelper.CustText(text: data.rate!)),
                                  Center(child: UiHelper.CustText(text: data.deliveryAfter!)),
                                  Center(child: UiHelper.CustText(text: data.testFile!)),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly  ,
                                    children: [
                                    IconButton(onPressed: (){}, icon: Icon(Icons.edit,color: Colors.green,)),
                                    IconButton(onPressed: (){}, icon: Icon(Icons.delete,color: Colors.red,)),
                                  ],)
                                ])
                              ],
                            );
                          },itemCount: state.rateListModel.rateList!.length,);
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
