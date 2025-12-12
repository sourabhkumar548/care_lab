import '../SqfModels/sqf_agent_list_model.dart';
import 'db_helper.dart';

class AgentDb{
  Future<int> insertAgent(SqfAgentListModel user) async {
    final db = await DatabaseHelper().database;
    return await db.insert('agent_list', user.toMap());
  }

  Future<List<SqfAgentListModel>> getAgent() async {
    final db = await DatabaseHelper().database;
    final List<Map<String, dynamic>> result = await db.query('agent_list');
    return result.map((map) => SqfAgentListModel.fromMap(map)).toList();
  }

  Future<int> deleteAgent(int id) async {
    final db = await DatabaseHelper().database;
    return await db.delete(
      'agent_list',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}