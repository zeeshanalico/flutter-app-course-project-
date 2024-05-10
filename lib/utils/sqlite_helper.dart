import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class User {
  String name;
  String email;
  String phone;
  String password;

  User({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }
}

class RegisterHelper {
  final String colID = "id";
  final String colName = "name";
  final String colEmail = "email";
  final String colPassword = "password";
  final String colPhone = "phone"; // Corrected column name

  final String tableName = "user";

  static Database? db;

  Future<void> init() async {
    var docsPath = await getApplicationDocumentsDirectory();
    String dbPath = "${docsPath.path}/events.db";
    db = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "create table $tableName ($colID integer primary key autoincrement, $colName text, $colEmail text, $colPhone text, $colPassword text)");
  }

  Future<void> register(User user) async {
    await db!.insert(tableName, user.toJsonMap());
  }
}
