// database.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DBHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDB();
    return _database!;
  }

  static Future<Database> initDB() async {
    String path = join(await getDatabasesPath(), 'your_database_name.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute('''
        CREATE TABLE users (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          email TEXT UNIQUE,
          password TEXT
        )
      ''');

      await db.execute('''
        CREATE TABLE earnings (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          source TEXT,
          amount REAL,
          date TEXT,
          FOREIGN KEY (user_id) REFERENCES users (id)
        )
      ''');

      await db.execute('''
        CREATE TABLE expenses (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          name TEXT,
          amount REAL,
          date TEXT,
          FOREIGN KEY (user_id) REFERENCES users (id)
        )
      ''');
    });
  }

  Future<int> insertOrUpdateUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUserByEmail(String email) async {
    Database db = await database;
    List<Map<String, dynamic>> users =
        await db.query('users', where: 'email = ?', whereArgs: [email]);

    if (users.isNotEmpty) {
      return User.fromMap(users.first);
    } else {
      return null;
    }
  }

  Future<List<Earning>> getEarnings(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> earnings =
        await db.query('earnings', where: 'user_id = ?', whereArgs: [userId]);

    return earnings.map((e) => Earning.fromMap(e)).toList();
  }

  Future<List<Expense>> getExpenses(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> expenses =
        await db.query('expenses', where: 'user_id = ?', whereArgs: [userId]);

    return expenses.map((e) => Expense.fromMap(e)).toList();
  }

  Future<int> insertEarning(Earning earning) async {
    Database db = await database;
    return await db.insert('earnings', earning.toMap());
  }

  Future<int> insertExpense(Expense expense) async {
    Database db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<int> updateEarning(Earning earning) async {
    Database db = await database;
    return await db.update(
      'earnings',
      earning.toMap(),
      where: 'id = ?',
      whereArgs: [earning.id],
    );
  }

  Future<int> updateExpense(Expense expense) async {
    Database db = await database;
    return await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  Future<int> deleteEarning(int id) async {
    Database db = await database;
    return await db.delete('earnings', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteExpense(int id) async {
    Database db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [id]);
  }
}

class User {
  int? id;
  String name;
  String email;
  String password;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {'name': name, 'email': email, 'password': password};
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      password: map['password'],
    );
  }
}

class Earning {
  int? id;
  int user_id;
  String source;
  double amount;
  String date;

  Earning({
    this.id,
    required this.user_id,
    required this.source,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'source': source,
      'amount': amount,
      'date': date,
    };
  }

  factory Earning.fromMap(Map<String, dynamic> map) {
    return Earning(
      id: map['id'],
      user_id: map['user_id'],
      source: map['source'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}

class Expense {
  int? id;
  int user_id;
  String name;
  double amount;
  String date;

  Expense({
    this.id,
    required this.user_id,
    required this.name,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': user_id,
      'name': name,
      'amount': amount,
      'date': date,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      user_id: map['user_id'],
      name: map['name'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}
