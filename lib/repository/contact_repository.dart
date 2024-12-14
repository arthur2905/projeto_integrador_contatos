import 'package:teste_projeto/models/contact.dart';

import '../db/database_helper.dart';

class ContactRepository {
  final _dbHelper = DatabaseHelper.instance;

  Future<int> insertContact(Contact contact) async {
    final db = await _dbHelper.database;
    return db.insert('contacts', contact.toMap());
  }

  Future<List<Contact>> getAllContacts() async {
    final db = await _dbHelper.database;
    final result = await db.query('contacts');
    return result.map((map) => Contact.fromMap(map)).toList();
  }

  Future<int> updateContact(Contact contact) async {
    final db = await _dbHelper.database;
    return db.update(
      'contacts',
      contact.toMap(),
      where: 'id = ?',
      whereArgs: [contact.id],
    );
  }

  Future<int> deleteContact(int? id) async {
    final db = await _dbHelper.database;
    return db.delete('contacts', where: 'id = ?', whereArgs: [id]);
  }

  Future<Contact> getContact(int? id) async {
    final db = await _dbHelper.database;
    final result = await db.query('contacts', where: 'id = ?', whereArgs: [id]);
    return Contact.fromMap(result.first);
  }
}
