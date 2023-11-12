// database.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

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
    String path = join(await getDatabasesPath(), 'your_database_name1.db');
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
        CREATE TABLE expenses (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          description TEXT,
          amount REAL,
          date TEXT,
          FOREIGN KEY (user_id) REFERENCES users (id)
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

  Future<int> insertExpense(Expense expense) async {
    Database db = await database;
    return await db.insert('expenses', expense.toMap());
  }

  Future<List<Expense>> getExpenses(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> expenseMaps =
        await db.query('expenses', where: 'user_id = ?', whereArgs: [userId]);

    return List.generate(expenseMaps.length, (index) {
      return Expense.fromMap(expenseMaps[index]);
    });
  }

  Future<int> deleteExpense(int expenseId) async {
    Database db = await database;
    return await db.delete('expenses', where: 'id = ?', whereArgs: [expenseId]);
  }

  Future<int> insertEarning(Earning earning) async {
    Database db = await database;
    return await db.insert('earnings', earning.toMap());
  }

  Future<List<Earning>> getEarnings(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> earningMaps =
        await db.query('earnings', where: 'user_id = ?', whereArgs: [userId]);

    print('Earnings from database: $earningMaps');

    return List.generate(earningMaps.length, (index) {
      return Earning.fromMap(earningMaps[index]);
    });
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

  Future<int> deleteEarning(int earningId) async {
    Database db = await database;
    return await db.delete('earnings', where: 'id = ?', whereArgs: [earningId]);
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

class Expense {
  int? id;
  int userId;
  String description;
  double amount;
  String date;

  Expense({
    this.id,
    required this.userId,
    required this.description,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'description': description,
      'amount': amount,
      'date': date,
    };
  }

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      userId: map['user_id'],
      description: map['description'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}

class Earning {
  int? id;
  int userId;
  String source;
  double amount;
  String date;

  Earning({
    this.id,
    required this.userId,
    required this.source,
    required this.amount,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'source': source,
      'amount': amount,
      'date': date,
    };
  }

  factory Earning.fromMap(Map<String, dynamic> map) {
    return Earning(
      id: map['id'],
      userId: map['user_id'],
      source: map['source'],
      amount: map['amount'],
      date: map['date'],
    );
  }
}
