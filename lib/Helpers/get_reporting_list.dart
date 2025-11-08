//
// import 'dart:convert';
// import 'package:care_lab_software/Helpers/print_case_entry.dart';
// import 'package:care_lab_software/Helpers/uiHelper.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sizer/sizer.dart';
// import 'package:web/web.dart' as html;
//
// import '../Controllers/CaseList/Cubit/case_list_cubit.dart';
// import '../Controllers/DocCtrl/bloc/doc_bloc.dart';
// import '../Controllers/DocCtrl/doc_ctrl.dart';
//
//
//
// class GetReportingList {
//   static GetReport({required String date,required BuildContext context}) {
//
//     context.read<CaseListCubit>().getCaseList(date: date,type: "Report");
//
//     return Column(
//       children: [
//         SizedBox(height: 10),
//         BlocBuilder<CaseListCubit, CaseListState>(
//           builder: (context, state) {
//             if(state is CaseListLoadingState){
//               return Center(child: CircularProgressIndicator(),);
//             }if(state is CaseListErrorState){
//               return Center(child: UiHelper.CustText(text: state.errorMsg,color: Colors.red,size: 12.sp),);
//             }if(state is CaseListLoadedState){
//
//               return ListView.builder(
//                 shrinkWrap: true,
//                 itemBuilder: (_,index){
//                 var mainData = state.caseListModel.caseList![index];
//                 return ListView.builder(
//                   shrinkWrap: true,
//                   itemBuilder: (_,idx){
//                   var data = mainData.items![idx];
//                   List<String> testName = data.testName!.split(",");
//                   List<String> testDate = data.testDate!.split(",");
//                   List<String> testfile = data.testFile!.split(",");
//
//                   String name = data.patientName!;
//                   String date = data.date!;
//                   String slipno = data.slipNo!;
//                   String age = "${data.year!} Y ${data.month!} M";
//                   String sex = data.gender!;
//                   String referredby = data.doctor!;
//                   String filename = "p_${data.slipNo!}-${data.testName}";
//
//                   return Container(
//                     margin: EdgeInsets.only(bottom: 5),
//                     color: index%2 == 0 ? Colors.grey.shade200 : Colors.white70,
//                     child: ExpansionTile(title:
//                         Table(
//                           columnWidths: {
//                             0: FlexColumnWidth(1),
//                             1: FlexColumnWidth(2),
//                             2: FlexColumnWidth(7),
//                             3: FlexColumnWidth(6),
//                             4: FlexColumnWidth(2),
//                           },
//                           children: [
//                             TableRow(children: [
//                               Center(child: UiHelper.CustText(text: "Case No \n${data.caseNo!}",size: 11.sp)),
//                               Center(child: UiHelper.CustText(text: "Case Date \n${data.caseDate!}",size: 11.sp)),
//                               UiHelper.CustText(text: "Patient Name : \n${data.patientName!}",size: 11.sp),
//                               UiHelper.CustText(text: "Doctor Name : \n${data.doctor!}",size: 11.sp),
//                               Center(child: UiHelper.CustText(text: "Bill Amount \n${data.afterDiscount=="0" ? data.totalAmount : data.afterDiscount!}.00",size: 11.sp)),
//                             ])
//                           ],
//                         ),
//                       children: [
//                         ListView.builder(shrinkWrap: true,itemBuilder: (_,index){
//
//                           String testDateFormatted = PrintCaseEntry.GenerateDate(dateCount: int.parse("${testDate[index].replaceAll('[', "").replaceAll("]", "")}"),casedate: data.caseDate!);
//
//                           return Container(
//                             color: Colors.white,
//                             child: Table(
//                               children: [
//                                 TableRow(children: [
//                                   Center(child: UiHelper.CustText(text: "${index+1}",size: 14,fontfamily: 'font-bold')),
//                                   Center(child: UiHelper.CustText(text: "${data.slipNo}",size: 14,fontfamily: 'font-bold')),
//                                   Center(child: UiHelper.CustText(text: "${testName[index].replaceAll('[', "").replaceAll("]", "")}",size: 14,fontfamily: 'font-bold')),
//                                   Center(child: UiHelper.CustText(text: testDateFormatted,size: 14,fontfamily: 'font-bold')),
//                                   Center(child: UiHelper.CustText(text: "Pending",size: 14,fontfamily: 'font-bold')),
//                                   Row(
//                                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                                     children: [
//
//                                       BlocConsumer<DocBloc, DocState>(
//                                         listener: (context, state) {
//                                           if(state is DocErrorState){
//                                             UiHelper.showErrorToste(message: state.errorMsg);
//                                           }
//                                           if(state is DocLoadedState){
//                                             var json = jsonDecode(state.fileUrl);
//                                             String url = json['url'];
//                                             openInOfficeOnline(url);
//                                           }
//                                         },
//                                         builder: (context, state) {
//                                           if(state is DocLoadingState){
//                                             return Center(child: CircularProgressIndicator(),);
//                                           }
//                                           return Center(
//                                             child: Tooltip(
//                                               message: "Create Report",
//                                               child: IconButton(
//                                                   onPressed: ()async{
//
//                                                 bool? result = await UiHelper.showYesNoDialog(
//                                                   context,
//                                                   "${testName[index].replaceAll("[", "").replaceAll("]", "")}",
//                                                   "Do you really want to create this report?",
//                                                 );
//
//                                                 if (result == true) {
//                                                   String main_file = testfile[index].replaceAll('[', "").replaceAll("]", "");
//                                                   DocCtrl.Doc(context: context,
//                                                       name: name,
//                                                       date: date,
//                                                       slipno: slipno,
//                                                       age: age,
//                                                       sex: sex,
//                                                       referredby: referredby,
//                                                       filename: filename,
//                                                       mainfile: main_file);
//                                                 } else {
//
//                                                 }
//
//
//                                               }, icon: Icon(Icons.list_alt,color: Colors.blue.shade600,)),
//                                             ),
//                                           );
//                                         },
//                                       ),
//
//                                       Center(
//                                         child: Tooltip(
//                                           message: "Download Report",
//                                           child: IconButton(onPressed: (){
//
//                                           }, icon: Icon(Icons.download,color: Colors.green.shade600,)),
//                                         ),
//                                       ),
//                                     ],),
//
//                                 ])
//                               ],
//                               border: TableBorder.all(color: Colors.grey,width: .5), // Add border
//                               defaultVerticalAlignment: TableCellVerticalAlignment.middle,
//                               columnWidths: {
//                                 0: FlexColumnWidth(1),
//                                 1: FlexColumnWidth(1.5),
//                                 2: FlexColumnWidth(7),
//                                 3: FlexColumnWidth(2),
//                                 4: FlexColumnWidth(1),
//                                 6: FlexColumnWidth(1),
//                               },),
//                           );
//
//
//                         },itemCount: testName.length,),
//                         const SizedBox(height: 5,)
//                       ],),
//                   );
//
//                 },
//                   itemCount: 1,);
//               },
//                 itemCount: state.caseListModel.caseList!.length,);
//
//             }
//             return Container();
//           },
//         )
//       ],
//     );
//   }
//
//
// }
