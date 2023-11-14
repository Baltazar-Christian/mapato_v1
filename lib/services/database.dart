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
    String path = join(await getDatabasesPath(), 'dummy1.db');
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

      await db.execute('''
        CREATE TABLE savings (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          name TEXT,
          amount REAL,
          description TEXT,
          FOREIGN KEY (user_id) REFERENCES users (id)
        )
      ''');

      await db.execute('''
        CREATE TABLE debts (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          user_id INTEGER,
          amount REAL,
          pamount REAL DEFAULT 0,
          description TEXT,
          owner TEXT,
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

  Future<void> updateExpense(Expense updatedExpense) async {
    final db = await database;
    await db.update(
      'expenses',
      updatedExpense.toMap(),
      where: 'id = ?',
      whereArgs: [updatedExpense.id],
    );
  }

  Future<Expense?> getExpense(int expenseId) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [expenseId],
    );

    if (result.isNotEmpty) {
      return Expense.fromMap(result.first);
    } else {
      return null;
    }
  }

  Future<Expense> getExpenseDetails(int expenseId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'expenses',
      where: 'id = ?',
      whereArgs: [expenseId],
    );

    return Expense.fromMap(maps.first);
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

  Future<int> insertSavings(Savings savings) async {
    Database db = await database;
    return await db.insert('savings', savings.toMap());
  }

  Future<List<Savings>> getSavings(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> savingsMaps =
        await db.query('savings', where: 'user_id = ?', whereArgs: [userId]);

    return List.generate(savingsMaps.length, (index) {
      return Savings.fromMap(savingsMaps[index]);
    });
  }

  Future<void> updateSavings(Savings updatedSavings) async {
    final db = await database;
    await db.update(
      'savings',
      updatedSavings.toMap(),
      where: 'id = ?',
      whereArgs: [updatedSavings.id],
    );
  }

  Future<Savings?> getSavingsDetails(int savingsId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'savings',
      where: 'id = ?',
      whereArgs: [savingsId],
    );

    if (maps.isNotEmpty) {
      return Savings.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Savings> getSavingDetails(int savingId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'savings',
      where: 'id = ?',
      whereArgs: [savingId],
    );

    return Savings.fromMap(maps.first);
  }

  Future<int> deleteSavings(int savingsId) async {
    Database db = await database;
    return await db.delete('savings', where: 'id = ?', whereArgs: [savingsId]);
  }

  Future<int> insertDebt(Debt debt) async {
    Database db = await database;
    return await db.insert('debts', debt.toMap());
  }

  Future<List<Debt>> getDebts(int userId) async {
    Database db = await database;
    List<Map<String, dynamic>> debtMaps =
        await db.query('debts', where: 'user_id = ?', whereArgs: [userId]);

    return List.generate(debtMaps.length, (index) {
      return Debt.fromMap(debtMaps[index]);
    });
  }

  Future<void> updateDebt(Debt updatedDebt) async {
    final db = await database;
    await db.update(
      'debts',
      updatedDebt.toMap(),
      where: 'id = ?',
      whereArgs: [updatedDebt.id],
    );
  }

  Future<Debt?> getDebtDetails(int debtId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'debts',
      where: 'id = ?',
      whereArgs: [debtId],
    );

    if (maps.isNotEmpty) {
      return Debt.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<Debt> getDebtDetail(int debtId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'debts',
      where: 'id = ?',
      whereArgs: [debtId],
    );

    return Debt.fromMap(maps.first);
  }

  Future<int> deleteDebt(int debtId) async {
    Database db = await database;
    return await db.delete('debts', where: 'id = ?', whereArgs: [debtId]);
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

class Savings {
  int? id;
  int userId;
  String name;
  double amount;
  String description;

  Savings({
    this.id,
    required this.userId,
    required this.name,
    required this.amount,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'name': name,
      'amount': amount,
      'description': description,
    };
  }

  factory Savings.fromMap(Map<String, dynamic> map) {
    return Savings(
      id: map['id'],
      userId: map['user_id'],
      name: map['name'],
      amount: map['amount'],
      description: map['description'],
    );
  }
}

class Debt {
  int? id;
  int userId;
  double amount;
  double pamount;
  String description;
  String owner;

  Debt({
    this.id,
    required this.userId,
    required this.amount,
    required this.pamount,
    required this.description,
    required this.owner,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'amount': amount,
      'pamount': pamount,
      'description': description,
      'owner': owner,
    };
  }

  factory Debt.fromMap(Map<String, dynamic> map) {
    return Debt(
      id: map['id'],
      userId: map['user_id'],
      amount: map['amount'],
      pamount: map['pamount'],
      description: map['description'],
      owner: map['owner'],
    );
  }
}
