import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:care_lab_software/SqfLite/SqfDB/case_entry_db.dart';
import 'package:care_lab_software/SqfLite/SqfModels/sqf_case_entry_model.dart';
import 'package:meta/meta.dart';

part 'show_case_state.dart';

class ShowCaseCubit extends Cubit<ShowCaseState> {
  CaseEntryDb db;
  ShowCaseCubit(this.db) : super(ShowCaseInitialState());

  GetOfflineCase({required String date})async{

    emit(ShowCaseLoadingState());

    try{

      final List<SqfCaseEntryModel?> data = await db.getCaseList(date: date);
      final cases = data.whereType<SqfCaseEntryModel>().toList();


      if (cases.isNotEmpty) {

        // Group by case_no
        Map<String, List<SqfCaseEntryModel>> grouped = {};

        for (var entry in cases) {
          final caseNo = entry.case_no;
          if (!grouped.containsKey(caseNo)) {
            grouped[caseNo] = [];
          }
          grouped[caseNo]!.add(entry);
        }

        emit(ShowCaseLoadedState(groupedCases: grouped));
      } else {
        emit(ShowCaseErrorState(errorMsg: "Data not found"));
      }

    }catch(e){
      emit(ShowCaseErrorState(errorMsg: "Error : $e"));
    }

  }

  GetOfflineCaseByCaseNo({required String case_no})async{

    emit(ShowCaseLoadingState());

    try{
      final data = await db.getCaseListByCaseNo(case_no: case_no);

      if (data.isNotEmpty) {
        emit(ShowCaseLoaded2State(sqfcaseentrymodel: data));
      } else {
        emit(ShowCaseErrorState(errorMsg: "Data not found"));
      }

    }catch(e){
      emit(ShowCaseErrorState(errorMsg: "Error : $e"));
    }

  }

  GetOfflineCaseReport({required String date})async{

    emit(ShowCaseLoadingState());

    try{

      final List<SqfCaseEntryModel?> data = await db.getReportList(date: date);
      final cases = data.whereType<SqfCaseEntryModel>().toList();


      if (cases.isNotEmpty) {

        // Group by case_no
        Map<String, List<SqfCaseEntryModel>> grouped = {};

        for (var entry in cases) {
          final caseNo = entry.case_no;
          if (!grouped.containsKey(caseNo)) {
            grouped[caseNo] = [];
          }
          grouped[caseNo]!.add(entry);
        }

        emit(ShowCaseLoadedState(groupedCases: grouped));
      } else {
        emit(ShowCaseErrorState(errorMsg: "Data not found"));
      }

    }catch(e){
      emit(ShowCaseErrorState(errorMsg: "Error : $e"));
    }

  }

  getOfflineStaffSale({required String date,required String staffName})async{

    emit(ShowCaseLoadingState());

    try{

      final List<SqfCaseEntryModel?> data = await CaseEntryDb().getStaffSale(staffName: staffName,date: date);

      if (data.isNotEmpty) {
        emit(ShowCaseLoaded2State(sqfcaseentrymodel: data));
      } else {
        emit(ShowCaseErrorState(errorMsg: "Data not found"));
      }

    }catch(e){
      emit(ShowCaseErrorState(errorMsg: "Error : $e"));
    }

  }

  getOfflineSaleByDate({required String date})async{

    emit(ShowCaseLoadingState());

    try{

      final List<SqfCaseEntryModel?> data = await CaseEntryDb().getSaleByDate(date: date);

      if (data.isNotEmpty) {
        emit(ShowCaseLoaded2State(sqfcaseentrymodel: data));
      } else {
        emit(ShowCaseErrorState(errorMsg: "Data not found"));
      }

    }catch(e){
      emit(ShowCaseErrorState(errorMsg: "Error : $e"));
    }

  }

  getOfflineSaleByAgent({required String agent,required String month})async{

    emit(ShowCaseLoadingState());

    try{

      final List<SqfCaseEntryModel?> data = await CaseEntryDb().getSaleByAgent(agent: agent,month: month);

      if (data.isNotEmpty) {
        emit(ShowCaseLoaded2State(sqfcaseentrymodel: data));
      } else {
        emit(ShowCaseErrorState(errorMsg: "Data not found"));
      }

    }catch(e){
      emit(ShowCaseErrorState(errorMsg: "Error : $e"));
    }

  }

  getOfflineSaleByDoctor({required String doctor,required String month})async{

    emit(ShowCaseLoadingState());

    try{

      final List<SqfCaseEntryModel?> data = await CaseEntryDb().getSaleByDoctor(doctor: doctor,month: month);

      if (data.isNotEmpty) {
        emit(ShowCaseLoaded2State(sqfcaseentrymodel: data));
      } else {
        emit(ShowCaseErrorState(errorMsg: "Data not found"));
      }

    }catch(e){
      emit(ShowCaseErrorState(errorMsg: "Error : $e"));
    }

  }

}
