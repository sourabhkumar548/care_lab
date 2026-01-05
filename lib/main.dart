

import 'package:care_lab_software/Controllers/CheckReportCtrl/check_report_cubit.dart';
import 'package:care_lab_software/Controllers/DoctorCollectionCtrl/doctor_collection_cubit.dart';
import 'package:care_lab_software/Controllers/DoctorCtrl/cibit/doctor_cubit.dart';
import 'package:care_lab_software/Controllers/ExpansesCtrl/Cubit/expanses_cubit.dart';
import 'package:care_lab_software/Controllers/GetSingleCase/single_case_cubit.dart';
import 'package:care_lab_software/Controllers/PaymentHistoryCtrl/cubit/payment_history_cubit.dart';
import 'package:care_lab_software/Controllers/RateListCtrl/DeleteRateListCubit/delete_rate_list_cubit.dart';
import 'package:care_lab_software/Controllers/RevenueCtrl/revenue_cubit.dart';
import 'package:care_lab_software/Controllers/RoportCtrl/report_cubit.dart';
import 'package:care_lab_software/Controllers/UpdateCaseCtrl/update_case_bloc.dart';
import 'package:care_lab_software/Controllers/UpdateTestCtrl/Cubit/update_test_cubit.dart';
import 'package:care_lab_software/Controllers/UpdateTestCtrl/UpdateDataCubit/test_data_cubit.dart';
import 'package:care_lab_software/Views/agent_management.dart';
import 'package:care_lab_software/Views/collection_between_date.dart';
import 'package:care_lab_software/Views/doctor_collection.dart';
import 'package:care_lab_software/Views/doctor_management.dart';
import 'package:care_lab_software/Views/edit_case_entry.dart';
import 'package:care_lab_software/Views/expanses.dart';
import 'package:care_lab_software/Views/rate_list_management.dart';
import 'package:care_lab_software/Views/report_upload_screen.dart';
import 'package:care_lab_software/Views/staff_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

import 'Controllers/AgentCollectionCtrl/agent_collection_cubit.dart';
import 'Controllers/AgentCtrl/cubit/agent_cubit.dart';
import 'Controllers/BetweenDateCtrl/between_date_cubit.dart';
import 'Controllers/CaseEntryCtrl/Bloc/case_entry_bloc.dart';
import 'Controllers/CaseList/Cubit/case_list_cubit.dart';
import 'Controllers/CaseNumberCtrl/Cubit/case_number_cubit.dart';
import 'Controllers/DocCtrl/bloc/doc_bloc.dart';
import 'Controllers/DuePaidCtrl/due_paid_cubit.dart';
import 'Controllers/LoginScreenCtrl/LoginBloc/login_bloc.dart';
import 'Controllers/LoginScreenCtrl/UsernameCubit/username_cubit.dart';
import 'Controllers/RateListCtrl/Cubit/rate_list_cubit.dart';
import 'Controllers/StaffCtrl/cubit/staff_cubit.dart';
import 'Controllers/TodayCollectionCtrl/today_collection_cubit.dart';
import 'Helpers/report_page.dart';
import 'Views/agent_collection.dart';
import 'Views/case_entry_list.dart';
import 'Views/dashboard.dart';
import 'Helpers/get_doctor_data.dart';
import 'Views/loginscreen.dart';
import 'Views/monthly_list.dart';
import 'Views/new_case_entry.dart';
import 'Views/reporting.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'Views/search_report_screen.dart';

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
                BlocProvider(create: (_)=>RevenueCubit()..getRevenueDetail(get_today: "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}",get_month: DateTime.now().month.toString(),get_year: DateTime.now().year.toString())),
                BlocProvider(create: (_)=>DoctorCollectionCubit()),
                BlocProvider(create: (_)=>AgentCollectionCubit()),
                BlocProvider(create: (_)=>BetweenDateCubit()),
                BlocProvider(create: (_)=>UpdateTestCubit()),
                BlocProvider(create: (_)=>ExpansesCubit()),
                BlocProvider(create: (_)=>DeleteRateListCubit()),
                BlocProvider(create: (_)=>SingleCaseCubit()),
                BlocProvider(create: (_)=>UpdateCaseBloc()),
                BlocProvider(create: (_)=>TestDataCubit()),
                BlocProvider(create: (_)=>ReportCubit()..getAllReport()),
                BlocProvider(create: (_)=>TodayCollectionCubit()),
                BlocProvider(create: (_)=>DuePaidCubit()),
                BlocProvider(create: (_)=>CaseListCubit()..getCaseList(date: "${DateTime.now().day.toString()}-${DateTime.now().month.toString()}-${DateTime.now().year.toString()}",type: "All")),
              ],
              child: GetMaterialApp(
                initialRoute: "/login_page",
                title: 'Care Diagnostics Centre',
                debugShowCheckedModeBanner: false,
                supportedLocales: [const Locale('en', 'US')],
                routes : {
                  "/dashboard": (context) => DashboardScreen(),
                  "/login_page": (context) => LabLoginScreen(),
                  "/case_entry_page": (context) => NewCaseEntry(),
                  "/case_entry_list": (context) => CaseEntryList(),
                  "/reporting_page": (context) => Reporting(),
                  "/report": (context) => ReportPage(),
                  "/rate_list_management": (context) => RateListManagement(),
                  "/staff_list_management": (context) => StaffManagement(),
                  "/agent_list_management": (context) => AgentManagement(),
                  "/doctor_list_management": (context) => DoctorManagement(),
                  "/doctor_collection": (context) => DoctorCollection(),
                  "/agent_collection": (context) => AgentCollection(),
                  "/collection_between_date": (context) => CollectionBetweenDate(),
                  "/expanses": (context) => Expanses(),
                  "/upload_report": (context) => ReportUploadScreen(),
                  "/search_report": (context) => SearchReportScreen(),
                },
              ),
            ),
          );
        }
    );

  }
}
