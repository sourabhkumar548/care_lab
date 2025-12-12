import 'package:care_lab_software/SqfLite/SqfModels/sqf_test_list_model.dart';

import 'db_helper.dart';

class TestListDb{

  Future<int> insertTestList(SqfTestListModel user) async {
    final db = await DatabaseHelper().database;
    return await db.insert('rate_list', user.toMap());
  }

  Future<List<SqfTestListModel>> getTestList() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await db.query('rate_list');
    return result.map((map) => SqfTestListModel.fromMap(map)).toList();
  }

  Future<int> deleteTestList(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      'rate_list',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

}