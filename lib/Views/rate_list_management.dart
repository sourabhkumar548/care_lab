import 'dart:io';

import 'package:care_lab_software/Controllers/RateListCtrl/Cubit/rate_list_cubit.dart';
import 'package:care_lab_software/Controllers/UpdateTestCtrl/Cubit/update_test_cubit.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../Helpers/uiHelper.dart';

class RateListManagement extends StatelessWidget {
  const RateListManagement({super.key});

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
                    UiHelper.CustTopBar(title: "Rate List Management",widget: ElevatedButton(onPressed: (){

                      // pickAndUploadFile();
                      print("click");

                    }, child: UiHelper.CustText(text: "Add Test",size: 12.sp))),

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
                          3 : FlexColumnWidth(1),
                          4 : FlexColumnWidth(1),
                          5 : FlexColumnWidth(3),
                          6 : FlexColumnWidth(1),
                        },
                        children: [
                          TableRow(children: [
                            SizedBox(
                                height: 40,
                                child: Center(child: UiHelper.CustText(text: "Sno",size: 12.sp))),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: UiHelper.CustText(text: "Test Name",size: 12.sp),
                            ),
                            Center(child: UiHelper.CustText(text: "Department",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Rate",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Time\n(days)",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "File",size: 12.sp)),
                            Center(child: UiHelper.CustText(text: "Action",size: 12.sp)),
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
                                  1 : FlexColumnWidth(5),
                                  2 : FlexColumnWidth(2),
                                  3 : FlexColumnWidth(1),
                                  4 : FlexColumnWidth(1),
                                  5 : FlexColumnWidth(3),
                                  6 : FlexColumnWidth(1),
                                },
                                children: [
                                  TableRow(children: [
                                    Center(child: UiHelper.CustText(text: "${index+1}",size: 12.sp)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 10),
                                      child: UiHelper.CustText(text: data.testName!,size: 12.sp),
                                    ),
                                    Center(child: UiHelper.CustText(text: data.department!,size: 12.sp)),
                                    Center(child: UiHelper.CustText(text: data.rate!,size: 12.sp)),
                                    Center(child: UiHelper.CustText(text: data.deliveryAfter!,size: 12.sp)),
                                    Center(child: UiHelper.CustText(text: data.testFile!,size: 12.sp)),
                                    Column(
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
      )

          :
      Center(
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
                                      BlocConsumer<UpdateTestCubit, UpdateTestState>(
                                        listener: (context, state) {
                                          if(state is UpdateTestErrorState){
                                            UiHelper.showErrorToste(message: state.errorMsg);
                                          }
                                          if(state is UpdateTestLoadedState){
                                            UiHelper.showSuccessToste(message: "Updated Successfully");
                                          }
                                        },
                                        builder: (context, state) {
                                          if(state is UpdateTestLoadingState){
                                            return Center(child: CircularProgressIndicator());
                                          }
                                          return IconButton(onPressed: ()=>pickAndUploadWebFile(context: context, id: data.id.toString()),
                                              icon: Icon(Icons.edit,color: Colors.green,));
                                        },
                                      ),

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

Future<void> pickAndUploadWebFile({required BuildContext context, required String id}) async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    withData: true,      // IMPORTANT for web
  );

  if (result == null) {
    print("No file selected");
    return;
  }

  PlatformFile file = result.files.single;

  context.read<UpdateTestCubit>().getUpdateTest(id: id, fileName: file.name, file: file);

  // var uri = Uri.parse("https://dzda.in/upload.php");
  //
  // var request = http.MultipartRequest("POST", uri);
  //
  // request.files.add(
  //   http.MultipartFile.fromBytes(
  //     'file',
  //     file.bytes!,       // Web uses bytes
  //     filename: file.name,
  //   ),
  // );
  //
  // var response = await request.send();
  // var respStr = await response.stream.bytesToString();
  //
  // print("Response: $respStr");
}
