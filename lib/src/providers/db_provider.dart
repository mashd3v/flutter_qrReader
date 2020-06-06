import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:qr_reader/src/models/scan_model.dart';
export 'package:qr_reader/src/models/scan_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBProvider{
  static Database _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();
  Future<Database> get database async{
    if(_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async{
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'ScansDB');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db){},
      onCreate: (Database db, int version) async{
        await db.execute(
          'CREATE TABLE Scans ('
          'id INTEGER PRIMARY KEY,'
          'type TEXT,'
          'value TEXT'
          ')'
        );
      }
    );
  }

  // CREATE REGISTERS
  newScanRaw(ScanModel newScan) async{
    final db = await database;
    final ans = await db.rawInsert(
      "INSERT Into Scans (id, type, value) "
      "VALUES (${newScan.id}, '${newScan.type}', '${newScan.value}')"
    );
    return ans;
  }

  newScan(ScanModel newScan) async{
    final db = await database;
    final ans = await db.insert('Scans', newScan.toJson());
    return ans;
  }

  //QUERIES
  Future<ScanModel> getScanId(int id) async{
    final db = await database;
    final ans = await db.query(
      'Scans', 
      where: 'id = ?', 
      whereArgs: [id]
    );
    return ans.isNotEmpty ? ScanModel.fromJson(ans.first) : null;
  }

  Future<List<ScanModel>> getAllScans() async{
    final db = await database;
    final ans = await db.query('Scans');
    List<ScanModel> list = ans.isNotEmpty 
      ? ans.map((c) => ScanModel.fromJson(c)).toList() 
      : [];
    return list;
  }

  Future<List<ScanModel>> getScansPerType(String type) async{
    final db = await database;
    final ans = await db.rawQuery("SELECT * FROM Scans WHERE type='$type'");
    List<ScanModel> list = ans.isNotEmpty 
      ? ans.map((c) => ScanModel.fromJson(c)).toList() 
      : [];
    return list;
  }

  //UPDATE
  Future<int> updateScan(ScanModel newScan) async{
    final db = await database;
    final ans = await db.update('Scans', newScan.toJson(), where: 'id = ?', whereArgs: [newScan.id]);
    return ans;
  }

  //DELETE
  Future<int> deleteScan(int id) async{
    final db = await database;
    final ans = await db.delete('Scans', where: 'id = ?', whereArgs: [id]);
    return ans;
  }

  Future<int> deleteAll() async{
    final db = await database;
    final ans = await db.rawDelete('DELETE FROM Scans');
    return ans;
  }

}