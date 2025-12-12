import '../SqfModels/doctor_list_model.dart';
import 'db_helper.dart';

class DoctorDb{

  Future<int> insertDoctor(SqfDoctorListModel user) async {
    final db = await DatabaseHelper().database;
    return await db.insert('doctor_list', user.toMap());
  }

  Future<List<SqfDoctorListModel>> getDoctor() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await db.query('doctor_list');
    return result.map((map) => SqfDoctorListModel.fromMap(map)).toList();
  }

  Future<int> deleteDoctor(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      'doctor_list',                // table name
      where: 'id = ?',           // condition
      whereArgs: [id],           // values for condition
    );
  }

}