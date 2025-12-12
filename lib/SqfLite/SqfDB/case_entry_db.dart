import 'package:care_lab_software/SqfLite/SqfModels/sqf_case_entry_model.dart';
import 'db_helper.dart';

class CaseEntryDb{

  Future<int> insertCaseEntry(SqfCaseEntryModel user) async {
    final db = await DatabaseHelper().database;
    return await db.insert('case_entry', user.toMap());
  }

  Future<List<SqfCaseEntryModel?>> getCaseList({required String date}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'date = ?',
      whereArgs: [date],
    );

      return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();

  }
  Future<String?> getLastCaseNo() async {
    final db = await DatabaseHelper().database;

    final result = await db.query(
      'case_entry',
      columns: ['case_no'],
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isNotEmpty) {
      return result.first['case_no']?.toString();
    }
    return null;
  }

  Future<List<SqfCaseEntryModel?>> getBilledAmount({required String date}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'case_date = ?',
      whereArgs: [date],
        groupBy: 'case_no'
    );

    return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();

  }

  Future<List<SqfCaseEntryModel?>> getTodayCaseList({required String date}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'date = ?',
      whereArgs: [date],
      groupBy: 'case_no'
    );

    return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();

  }

  Future<List<SqfCaseEntryModel?>> getCaseInMonth({required String month}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'mon = ?',
      whereArgs: [month],
      groupBy: 'case_no'
    );

    return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();

  }

  Future<List<SqfCaseEntryModel?>> getCaseInYear({required String year}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'yer = ?',
      whereArgs: [year],
        groupBy: 'case_no'
    );

    return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();

  }

  Future<List<SqfCaseEntryModel?>> getCaseListByCaseNo({required String case_no}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'case_no = ?',
      whereArgs: [case_no],
    );

    return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();

  }

  Future<List<SqfCaseEntryModel?>> getReportList({required String date}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'case_date = ?',
      whereArgs: [date],
    );

    return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();

  }


  Future<List<SqfCaseEntryModel?>> getRevenueByMode({required String date,required String mode}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'date = ? AND pay_mode = ?',
      whereArgs: [date,mode],
    );
    return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();
  }

  Future<List<SqfCaseEntryModel?>> getMonthRevenue({required String month}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'mon = ?',
      whereArgs: [month],
    );
    return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();
  }

  Future<List<SqfCaseEntryModel?>> getYearRevenue({required String year}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'yer = ?',
      whereArgs: [year],
    );
    return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();
  }

  Future<List<SqfCaseEntryModel?>> getStaffSale({required String staffName,required String date}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'received_by = ? AND date = ?',
      whereArgs: [staffName,date],
    );
    return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();
  }

  Future<List<SqfCaseEntryModel?>> getSaleByDate({required String date}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'date = ?',
      whereArgs: [date],
    );
    return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();
  }

  Future<List<SqfCaseEntryModel?>> getSaleByAgent({required String agent,required String month}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'agent = ? AND mon = ?',
      whereArgs: [agent,month],
    );
    return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();
  }

  Future<List<SqfCaseEntryModel?>> getSaleByDoctor({required String doctor,required String month}) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'case_entry',
      where: 'doctor = ? AND mon = ?',
      whereArgs: [doctor,month],
    );
    return result.map((map) => SqfCaseEntryModel.fromMap(map)).toList();
  }


}