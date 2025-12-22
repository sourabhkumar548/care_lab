
import 'package:care_lab_software/Controllers/RoportCtrl/report_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import '../Helpers/uiHelper.dart';
import 'loginscreen.dart';

class SearchReportScreen extends StatefulWidget {
  const SearchReportScreen({super.key});

  @override
  State<SearchReportScreen> createState() => _SearchReportScreenState();
}

class _SearchReportScreenState extends State<SearchReportScreen> {



  @override
  Widget build(BuildContext context) {

    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    String accessCode = args["code"];

    if(accessCode != "/search_report"){

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
              child: UiHelper.custHorixontalTab(container: "22",context: context),
            ),
            //MAIN CONTENT
            Container(
              height: Adaptive.h(100),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Search Patient Report",),
                    const SizedBox(height: 20,),
                    _reportData()
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
              child: UiHelper.custsidebar(container: "22",context: context),
            ),
            //MAIN CONTENT
            Container(
              width: Adaptive.w(85),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: [
                    UiHelper.CustTopBar(title: "Search Patient Report",),

                    const SizedBox(height: 20,),

                    _reportData()

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _reportData(){

    return Column(
      children: [
        Table(
          border: TableBorder.all(color: Colors.grey.shade400, width: 1),
          columnWidths: const {
            0: FlexColumnWidth(1.0), // Case No
            1: FlexColumnWidth(1), // Case Date
            2: FlexColumnWidth(1.0), // Patient Name
            3: FlexColumnWidth(2), // Patient Mobile
            4: FlexColumnWidth(1), // Test Name
            5: FlexColumnWidth(3), //Test File
            6: FlexColumnWidth(2), //Test File
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: Colors.blueAccent,),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Sl No",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Case No",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Case Date",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Patient Name",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Patient Mobile",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Test Name",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Text("Test File",style: TextStyle(color: Colors.white,fontSize: 11.sp,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                )
              ],
            ),
          ],
        ),
        BlocBuilder<ReportCubit, ReportState>(
          builder: (context, state) {
            if(state is ReportLoadingState){
              return Center(child: CircularProgressIndicator());
            }
            if(state is ReportErrorState){
              return Center(child: UiHelper.CustText(text: state.errorMsg,color: Colors.red,size: 12.sp),);
            }
            if(state is ReportLoadedState){
                return ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (_,index){
                  var data = state.reportModel.report![index];
                  return Column(children: [
                    Table(
                      border: TableBorder.all(color: Colors.grey.shade400, width: 1),
                      columnWidths: const {
                        0: FlexColumnWidth(1.0), // Case No
                        1: FlexColumnWidth(1.0), // Case Date
                        2: FlexColumnWidth(1.0), // Patient Name
                        3: FlexColumnWidth(2), // Patient Mobile
                        4: FlexColumnWidth(1), // Test Name
                        5: FlexColumnWidth(3), //Test File
                        6: FlexColumnWidth(2), //Test File
                      },
                      children: [
                        TableRow(
                          decoration: BoxDecoration(color: index % 2 == 0 ? Colors.green.shade100 : Colors.grey.shade100),
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text("${index+1}",style: TextStyle(color: Colors.black,fontSize: 11.sp,),textAlign: TextAlign.center,),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text("${data.caseNo}",style: TextStyle(color: Colors.black,fontSize: 11.sp,),textAlign: TextAlign.center,),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Text("${data.caseDate}",style: TextStyle(color: Colors.black,fontSize: 11.sp,),textAlign: TextAlign.center,),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8,top: 8),
                              child: Text("${data.patientName}",style: TextStyle(color: Colors.black,fontSize: 11.sp,)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                              child: Text("${data.mobile == "0" ? "Not Mention" : data.mobile}",style: TextStyle(color: Colors.black,fontSize: 11.sp,)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                              child: Text("* ${data.testName!.replaceAll("[", "").replaceAll("]", "").replaceAll(",", "\n*")}",style: TextStyle(color: Colors.black,fontSize: 11.sp,)),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 8),
                              child: Text("* ${data.testFile!.replaceAll("[", "").replaceAll("]", "").replaceAll(",", "\n*")}",style: TextStyle(color: Colors.black,fontSize: 11.sp,)),
                            )
                          ],
                        ),
                      ],
                    ),
                  ],);
                },
                  itemCount: state.reportModel.report!.length,);
            }
            return Container();
          },
        ),
      ],
    );

  }

}
