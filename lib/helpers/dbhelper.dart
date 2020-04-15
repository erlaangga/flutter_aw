import 'package:sqflite/sqflite.dart';

//bekerja pada file dan directory
import 'package:path/path.dart';
import 'package:flutter_aw/models/contact.dart';
//pubspec.yml

//kelass Dbhelper
class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;

  DbHelper._createObject();

  // factory menginstansi object seperti static
  // tidak dapat mengakses this
  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {
    // untuk menentukan nama database dan lokasi yg dibuat
    // Directory directory = await getApplicationDocumentsDirectory();
    // String path = directory.path + 'contact.db';
    String path = join(await getDatabasesPath(), 'contact.db');

    //create, read databases
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);

    //mengembalikan nilai object sebagai hasil dari fungsinya
    return todoDatabase;
  }

  //buat tabel baru dengan nama contact
  void _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE contact (
        id INTEGER PRIMARY KEY,
        name TEXT,
        phone TEXT
      )
    ''');
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }

  Future<List<Map<String, dynamic>>> select(String table,
      {List<List> where, String orderBy, int limit, int offset}) async {
    Database db = await this.database;
    var mapList = await db.query(table, orderBy: orderBy, limit: limit);
    return mapList;
  }

  // create record
  Future<int> insert(String table, Map<String, dynamic> map) async {
    Database db = await this.database;
    int id  = await db.insert(table, map);
    return id;
  }

  //update record
  Future<int> update(String table, Map values) async {
    if (!values.keys.contains('id')) return 0;
    Database db = await this.database;
    int count = await db
        .update(table, values, where: 'id=?', whereArgs: [values['id']]);
    return count;
  }

  //delete record
  Future<int> delete(int id) async {
    Database db = await this.database;
    int count = await db.delete('contact', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Contact>> getContactList() async {
    var contactMapList = await select('contact', orderBy: 'name');
    int count = contactMapList.length;
    List<Contact> contactList = List<Contact>();
    for (int i = 0; i < count; i++) {
      contactList.add(Contact.fromMap(contactMapList[i]));
    }

    return contactList;
  }
}
