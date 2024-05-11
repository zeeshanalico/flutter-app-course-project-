import 'package:sqflite/sqflite.dart';

class User {
  int? id; // ID for database
  String name;
  String email;
  String phone;
  String password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
  });

  Map<String, dynamic> toJsonMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      password: map['password'],
    );
  }
}

class RegisterHelper {
  final String colID = "id";
  final String colName = "name";
  final String colEmail = "email";
  final String colPassword = "password";
  final String colPhone = "phone";
  final String tableName = "user";

  static Database? db;

  Future<void> init() async {
    String dbPath = "/assets/db";
    db = await openDatabase(dbPath, version: 1, onCreate: _onCreate);
    print(db);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(
        "create table $tableName ($colID integer primary key autoincrement, $colName text, $colEmail text, $colPhone text, $colPassword text)");
  }

  Future<void> register(User user) async {
    await db!.insert(tableName, user.toJsonMap());
  }

  Future<User?> getUserByEmailAndPassword(String email, String password) async {
    List<Map<String, dynamic>> results = await db!.query(
      tableName,
      where: "$colEmail = ? AND $colPassword = ?",
      whereArgs: [email, password],
    );

    if (results.isEmpty) {
      return null; // User not found
    }

    return User.fromMap(results.first); // Return the first user found
  }

  Future<List<User>> getAllUsers() async {
    List<Map<String, dynamic>> results = await db!.query(tableName);
    return results.map((map) => User.fromMap(map)).toList();
  }

  Future<void> updateUser(User user) async {
    await db!.update(
      tableName,
      user.toJsonMap(),
      where: "$colID = ?",
      whereArgs: [user.id],
    );
  }

  Future<void> deleteUser(int userId) async {
    await db!.delete(
      tableName,
      where: "$colID = ?",
      whereArgs: [userId],
    );
  }
}
