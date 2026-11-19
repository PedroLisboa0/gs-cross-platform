import 'package:sqflite/sqflite.dart';

import '../models/occurrence.dart';

class LocalDatabase {
  LocalDatabase._(this._database);

  final Database _database;

  static Future<LocalDatabase> open() async {
    final database = await openDatabase(
      'territorio_vivo.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE occurrences (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            type TEXT NOT NULL,
            neighborhood TEXT NOT NULL,
            description TEXT NOT NULL,
            urgency TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
    return LocalDatabase._(database);
  }

  Future<List<Occurrence>> getOccurrences() async {
    final rows = await _database.query(
      'occurrences',
      orderBy: 'created_at DESC',
    );
    return rows.map(Occurrence.fromDatabase).toList();
  }

  Future<Occurrence> addOccurrence(Occurrence occurrence) async {
    final id = await _database.insert('occurrences', occurrence.toDatabase());
    return Occurrence(
      id: id,
      type: occurrence.type,
      neighborhood: occurrence.neighborhood,
      description: occurrence.description,
      urgency: occurrence.urgency,
      createdAt: occurrence.createdAt,
    );
  }
}
