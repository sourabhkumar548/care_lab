

import 'package:care_lab_software/Controllers/CheckReportCtrl/check_report_cubit.dart';
import 'package:care_lab_software/Controllers/DoctorCtrl/cibit/doctor_cubit.dart';
import 'package:care_lab_software/Controllers/PaymentHistoryCtrl/cubit/payment_history_cubit.dart';
import 'package:care_lab_software/Views/agent_management.dart';
import 'package:care_lab_software/Views/doctor_management.dart';
import 'package:care_lab_software/Views/rate_list_management.dart';
import 'package:care_lab_software/Views/staff_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

import 'Controllers/AgentCtrl/cubit/agent_cubit.dart';
import 'Controllers/CaseEntryCtrl/Bloc/case_entry_bloc.dart';
import 'Controllers/CaseList/Cubit/case_list_cubit.dart';
import 'Controllers/CaseNumberCtrl/Cubit/case_number_cubit.dart';
import 'Controllers/DocCtrl/bloc/doc_bloc.dart';
import 'Controllers/LoginScreenCtrl/LoginBloc/login_bloc.dart';
import 'Controllers/LoginScreenCtrl/UsernameCubit/username_cubit.dart';
import 'Controllers/RateListCtrl/Cubit/rate_list_cubit.dart';
import 'Controllers/StaffCtrl/cubit/staff_cubit.dart';
import 'Helpers/report_page.dart';
import 'Views/case_entry_list.dart';
import 'Views/dashboard.dart';
import 'Views/loginscreen.dart';
import 'Views/new_case_entry.dart';
import 'Views/reporting.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    // Safe to use get_storage
    await GetStorage.init();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
        builder: (context, orientation, screenType){
          return ToastificationWrapper(
            child: MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => UsernameCubit()..getUsername()),
                BlocProvider(create: (context) => LoginBloc()),
                BlocProvider(create: (context) => DocBloc()),
                BlocProvider(create: (_)=>CaseEntryBloc()),
                BlocProvider(create: (_)=>RateListCubit()..GetRateList()),
                BlocProvider(create: (_)=>CaseNumberCubit()..getCaseNumber()),
                BlocProvider(create: (_)=>PaymentHistoryCubit()),
                BlocProvider(create: (_)=>StaffCubit()..GetStaff()),
                BlocProvider(create: (_)=>AgentCubit()..GetAgent()),
                BlocProvider(create: (_)=>DoctorCubit()..GetDoctor()),
                BlocProvider(create: (_)=>CheckReportCubit()),
                BlocProvider(create: (_)=>CaseListCubit()..getCaseList(date: "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}",type: "All")),
              ],
              child: GetMaterialApp(
                initialRoute: "/login_page",
                title: 'Care Diagnostics Center',
                debugShowCheckedModeBanner: false,
                supportedLocales: [const Locale('en', 'US')],
                routes : {
                  "/": (context) => Dashboard(),
                  "/login_page": (context) => LabLoginScreen(),
                  "/case_entry_page": (context) => NewCaseEntry(),
                  "/case_entry_list": (context) => CaseEntryList(),
                  "/reporting_page": (context) => Reporting(),
                  "/report": (context) => ReportPage(),
                  "/rate_list_management": (context) => RateListManagement(),
                  "/staff_list_management": (context) => StaffManagement(),
                  "/agent_list_management": (context) => AgentManagement(),
                  "/doctor_list_management": (context) => DoctorManagement(),
                },
              ),
            ),
          );
        }
    );

  }
}
