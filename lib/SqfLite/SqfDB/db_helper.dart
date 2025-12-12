
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('care_lab.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    // ✅ Initialize FFI for Windows/Linux
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;

    // ✅ Use writable user directory (AppData/Roaming)
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, fileName);

    // ✅ Open or create the database
    return await databaseFactory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: 2,
        onCreate: (db, version) async {
          await db.execute('''
            CREATE TABLE users (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT,
              username TEXT,
              password TEXT,
              post TEXT
            )
          ''');

          await db.execute('''
            CREATE TABLE case_entry (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              case_date TEXT,
              time TEXT,
              date TEXT,
              case_no TEXT,
              slip_no TEXT,
              received_by TEXT,
              patient_name TEXT,
              year TEXT,
              month TEXT,
              gender TEXT,
              mobile TEXT,
              child_male TEXT,
              child_female TEXT,
              address TEXT,
              agent TEXT,
              doctor TEXT,
              test_name TEXT,
              test_rate TEXT,
              total_amount TEXT,
              discount TEXT,
              after_discount TEXT,
              advance TEXT,
              balance TEXT,
              paid_amount TEXT,
              pay_status TEXT,
              pay_mode TEXT,
              discount_type TEXT,
              test_date TEXT,
              test_file TEXT,
              narration TEXT,
              name_title TEXT,
              mon TEXT,
              yer TEXT,
              status TEXT DEFAULT 'Active'
            )
          ''');

          await db.execute('''
            CREATE TABLE rate_list (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              test_name TEXT,
              rate TEXT,
              delivery_after TEXT,
              department TEXT,
              test_file TEXT,
              status TEXT DEFAULT 'Active'
            )
          ''');

          await db.execute('''
            CREATE TABLE doctor_list (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              doctor_name TEXT,
              post TEXT,
              mobile TEXT,
              status TEXT DEFAULT 'Active'
            )
          ''');

          await db.execute('''
            CREATE TABLE agent_list (
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              agent_name TEXT,
              mobile TEXT,
              address TEXT,
              shop_name TEXT,
              status TEXT DEFAULT 'Active'
            )
          ''');
        },
      ),
    );
  }
}
