import 'package:note_list_app/models/kategori.dart';
import 'package:note_list_app/models/note.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:typed_data';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static DatabaseHelper? _databaseHelper;
  static Database? _database;

  factory DatabaseHelper() {
    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._internal();
      return _databaseHelper!;
    } else {
      return _databaseHelper!;
    }
  }

  DatabaseHelper._internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database!;
    } else {
      return _database!;
    }
  }

  _initializeDatabase() async {
    Database _db;
    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "mainDB.db");

    var exists = await databaseExists(path);

    if (!exists) {
      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      ByteData data = await rootBundle.load(url.join("assets", "notes.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      await File(path).writeAsBytes(bytes, flush: true);
    } else {}

    _db = await openDatabase(path, readOnly: false);
    return _db;
  }

  Future<List<Map<String, dynamic>>> kategorileriGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query("kategori");
    return sonuc;
  }

  Future<int> kategoriEkle(Kategori kategori) async {
    var db = await _getDatabase();
    var result = await db.insert("kategori", kategori.toMap());
    return result;
  }

  Future<int> kategoriGuncelle(Kategori kategori) async {
    var db = await _getDatabase();
    var result = await db.update("kategori", kategori.toMap(),
        where: "kategoriID = ?", whereArgs: [kategori.kategoriID]);
    return result;
  }

  Future<int> kategoriSil(int kategoriID) async {
    var db = await _getDatabase();
    var result = await db
        .delete("kategori", where: "kategoriID = ?", whereArgs: [kategoriID]);
    return result;
  }

//----------------------
  Future<List<Map<String, dynamic>>> notlariGetir() async {
    var db = await _getDatabase();
    var sonuc = await db.query("not", orderBy: "notID DESC");
    return sonuc;
  }

  Future<int> notEkle(Not not) async {
    var db = await _getDatabase();
    var result = await db.insert("not", not.toMap());
    return result;
  }

  Future<int> notGuncelle(Not not) async {
    var db = await _getDatabase();
    var result = await db
        .update("not", not.toMap(), where: "notID = ?", whereArgs: [not.notID]);
    return result;
  }

  Future<int> notSil(int notID) async {
    var db = await _getDatabase();
    var result = await db.delete("not", where: "notID = ?", whereArgs: [notID]);
    return result;
  }
}
