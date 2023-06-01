import 'dart:io';

import 'package:flutter_client/admin/models/quote.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalCache {
  static Database? _database;
  static final LocalCache db = LocalCache._();
  LocalCache._();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentDirectory.path, 'quote_database.db');
    return await (openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE Quote('
          'id TEXT PRIMARY KEY,'
          'author TEXT,'
          'body TEXT,'
          'category TEXT'
          ')');

      await db.execute('CREATE TABLE Favorite('
          'id TEXT PRIMARY KEY,'
          'author TEXT,'
          'body TEXT,'
          'category TEXT'
          ')');
    }));
  }

  createQuote(Quote quote, {required String type}) async {
    final db = await database;
    if (type == "favorites") {
      final res = await db.insert('Favorite', quote.toJson());
      return res;
    } else {
      final res = await db.insert('Quote', quote.toJson());
      return res;
    }
  }

  removeFromFavorites(String id) async {
    final db = await database;
    final res = await db.delete("Favorite", where: 'id = ?', whereArgs: [id]);
    return res;
  }

  addToFavorites(Quote quote) async {
    final db = await database;
    final res = await db.insert(
      "Favorite",
      quote.toJson(),
    );
    return res;
  }

  Future<int> deleteAllQuotes({required String type}) async {
    final db = await database;
    if (type == "favorites") {
      final res = await db.rawDelete('DELETE FROM Favorite');
      return res;
    } else {
      final res = await db.rawDelete('DELETE FROM Quote');
      return res;
    }
  }

  Future<List<Quote>> getAllQuotes({required String type}) async {
    final db = await database;
    if (type == "favorites") {
      print("get all Favorites is comming");
      final res = await db.rawQuery('SELECT * FROM Favorite');
      return res.map((quote) {
        var data = Quote.fromJson(quote);
        data.id = quote['id'].toString();
        return data;
      }).toList();
    } else {
      print("get all quotes request is comming");
      final res = await db.rawQuery('SELECT * FROM Quote');
      return res.map((quote) {
        var data = Quote.fromJson(quote);
        data.id = quote['id'].toString();
        return data;
      }).toList();
    }
  }
}
