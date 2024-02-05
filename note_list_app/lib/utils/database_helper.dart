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

  Future<List<Kategori>> kategoriList() async {
    var kategoriMapList = await kategorileriGetir();
    var myKategoriList = <Kategori>[];
    for (Map<String, dynamic> map in kategoriMapList) {
      myKategoriList.add(Kategori.fromMap(map));
    }
    return myKategoriList;
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
    var sonuc = await db.rawQuery(
        'select * from "not" inner join kategori on kategori.kategoriID = "not".kategoriID order by notID Desc;');
    return sonuc;
  }

  Future<List<Not>> notList() async {
    var notMapList = await notlariGetir();
    var myNotList = <Not>[];
    for (Map<String, dynamic> map in notMapList) {
      myNotList.add(Not.fromMap(map));
    }
    return myNotList;
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

  String dataFormat(DateTime tm) {
    DateTime today = DateTime.now();
    Duration oneDay = const Duration(days: 1);
    Duration twoDay = const Duration(days: 2);
    Duration oneWeek = const Duration(days: 7);
    String month;

    switch (tm.month) {
      case 1:
        month = "Ocak";
        break;
      case 2:
        month = "Şubat";
        break;
      case 3:
        month = "Mart";
        break;
      case 4:
        month = "Nisan";
        break;
      case 5:
        month = "Mayıs";
        break;
      case 6:
        month = "Haziran";
        break;
      case 7:
        month = "Temmuz";
        break;
      case 8:
        month = "Ağustos";
        break;
      case 9:
        month = "Eylül";
        break;
      case 10:
        month = "Ekim";
        break;
      case 11:
        month = "Kasım";
        break;
      case 12:
        month = "Aralık";
        break;
      default:
        month = "Bilinmeyen Ay";
        break;
    }

    Duration difference = today.difference(tm);
    if (difference.compareTo(oneDay) < 1) {
      return "bugün";
    } else if (difference.compareTo(twoDay) < 1) {
      return "dün";
    } else if (difference.compareTo(oneWeek) < 1) {
      switch (tm.weekday) {
        case 1:
          return "Pazartesi";
        case 2:
          return "Salı";
        case 3:
          return "Çarşamba";
        case 4:
          return "Perşembe";
        case 5:
          return "Cuma";
        case 6:
          return "Cumartesi";
        case 7:
          return "Pazar";
        default:
          return "Bilinmeyen Gün";
      }
    } else if (tm.year == today.year) {
      return "${tm.day} $month";
    } else {
      return "${tm.day} $month ${tm.year}";
    }
  }
}
