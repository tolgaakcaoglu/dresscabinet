import 'dart:async';
import 'package:dresscabinet/app/modals/basketmodal.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class LocalDb {
  static final LocalDb instance = LocalDb._init();

  static Database _database;

  LocalDb._init();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await _initDB('dresscabinet.db');
    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    dynamic path = ('$dbPath/$filePath');
    debugPrint(path);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE $basketTable (
  ${BasketField.productId} INTEGER PRIMARY KEY NOT NULL,
  ${BasketField.piece} INTEGER NOT NULL,
  ${BasketField.kdv} INTEGER NOT NULL,
  ${BasketField.productName} TEXT NOT NULL,
  ${BasketField.currencyUnit} VARCHAR(10) NOT NULL,
  ${BasketField.note} TEXT NOT NULL,
  ${BasketField.variant} VARCHAR(30) NOT NULL,
  ${BasketField.brand} VARCHAR(100) NOT NULL,
  ${BasketField.marketPrice} FLOAT NOT NULL,
  ${BasketField.salePrice} FLOAT NOT NULL,
  ${BasketField.basketDiscount} FLOAT,
  ${BasketField.memberDiscount} FLOAT
)
''');
  }

  Future<Basket> create(Basket basket) async {
    final db = await instance.database;
    final id = await db.insert(basketTable, basket.toJson());

    return basket.copy(productId: id);
  }

  Future deleteBasket() async {
    final db = await instance.database;
    await db.delete(basketTable);
  }

  Future<Basket> readBasket(int id) async {
    final db = await instance.database;
    final maps = await db.query(basketTable,
        // columns: BasketField.values,
        where: '${BasketField.productId} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Basket.build(maps.first);
    } else {
      throw ('ID $id bulunamadi');
    }
  }

  Future<bool> isAdded(int id) async {
    final db = await instance.database;
    final maps = await db.query(basketTable,
        // columns: BasketField.values,
        where: '${BasketField.productId} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  Future<List<Basket>> readAllProducts() async {
    final db = await instance.database;
    const orderBy = '${BasketField.productName} ASC';
    final result = await db.query(basketTable, orderBy: orderBy);

    return result.map((json) => Basket.build(json)).toList();
  }

  Future<int> update(Basket basket) async {
    final db = await instance.database;
    return db.update(basketTable, basket.toJson(),
        where: '${BasketField.productId} = ?', whereArgs: [basket.productId]);
  }

  Future<int> remove(int id) async {
    final db = await instance.database;

    return db.delete(basketTable,
        where: '${BasketField.productId} = ?', whereArgs: [id]);
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
