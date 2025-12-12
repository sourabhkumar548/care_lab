import 'package:care_lab_software/SqfLite/SqfDB/db_helper.dart';
import 'package:care_lab_software/SqfLite/SqfModels/sqf_login_model.dart';

class UserDb{
  Future<int> insertUser(SQFUserModel user) async {
    final db = await DatabaseHelper().database;
    return await db.insert('users', user.toMap());
  }

  Future<List<SQFUserModel>> getUsers() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await db.query('users');
    return result.map((map) => SQFUserModel.fromMap(map)).toList();
  }

  Future<SQFUserModel?> login(String username, String password) async {
    final db = await DatabaseHelper().database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );

    if (result.isNotEmpty) {
      return SQFUserModel.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<String> fetchUsernames() async {
    final users = await getUsers(); // Returns List<SQFUserModel>
    // Extract usernames from the list
    final usernames = users.map((user) => user.username).toList();

    return usernames.join(', ');

  }

  Future<int> deleteUser(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      'users',                // table name
      where: 'id = ?',           // condition
      whereArgs: [id],           // values for condition
    );
  }


}