import 'dart:async';
import 'dart:io' as io;
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'PlayerList.dart';
import 'SetList.dart';

class DBHelper {
  static Database _db;
  static Database _db2;
  static const String ID = 'id';
  static const String NAME = 'name';
  static const String SETS = 'sets';
  static const String TABLE = 'Players';
  static const String DB_NAME = 'players.db';
  static const String DB_NAME2 = 'sets.db';

  static const String SET_ID = 'set_id';
  static const String GROUP = 'group';
  static const String TSTART = 'tstart';
  static const String TEND = 'tend';//string with the names of the 4 players
  static const String SET_HISTORY = 'set_history'; //tablename for sets

  /*Future<void> deleteDatabase() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    databaseFactory.deleteDatabase(path);
  }*/


  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }
  /*Future<Database> get db2 async {
    if (_db2 != null) {
      return _db2;
    }
    _db2 = await initDb();
    return _db2;
  }*/

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  /*initDb2() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME2);
    var db2 = await openDatabase(path, version: 1, onCreate: _onCreate2);
    return db2;
  }*/


  _onCreate(Database db, int version) async {
   db.execute('CREATE TABLE $TABLE($ID INTEGER PRIMARY KEY, $NAME TEXT, $SETS INTEGER)');
   db.execute('CREATE TABLE $SET_HISTORY($SET_ID INTEGER PRIMARY KEY, $GROUP TEXT, $TSTART TEXT, $TEND TEXT)');
  }

  /*_onCreate2(Database db, int version) async {
    db.execute('CREATE TABLE $SET_HISTORY($SET_ID INTEGER PRIMARY KEY, $GROUP TEXT, $TSTART TEXT, $TEND TEXT)');
  }*/


  //For Player
  Future<Player> save(Player players) async {
    var dbClient = await db;
    players.id = await dbClient.insert(TABLE, players.toMap());
    return players;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }
  //For Sets
  Future<Group> saveSets(Group group) async {
    var dbClient = await db;
   group.setid = await dbClient.insert(SET_HISTORY, group.toMap1());
    return group;
    /*
    await dbClient.transaction((txn) async {
      var query = "INSERT INTO $TABLE ($NAME) VALUES ('" + employee.name + "')";
      return await txn.rawInsert(query);
    });
    */
  }

  //For PlayerTab
  Future<List<Player>> getPlayers() async {
    var dbClient = await db;
    List<Map> maps = await dbClient.query(TABLE, columns: [ID, NAME, SETS]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Player> players = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        players.add(Player.fromMap(maps[i]));
      }
    }
    return players;
  }
  //For SetTab
  Future<List<Group>> getSets() async {
    var dbClient = await db;
    List<Map> maps1 = await dbClient.query(SET_HISTORY, columns: [SET_ID, GROUP]);
    //List<Map> maps = await dbClient.rawQuery("SELECT * FROM $TABLE");
    List<Group> sets = [];
    if (maps1.length > 0) {
      for (int i = 0; i < maps1.length; i++) {
        sets.add(Group.fromMap(maps1[i]));
      }
    }
    return sets;
  }

  //For Players
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE, where: '$ID = ?', whereArgs: [id]);
  }
 //For Sets
  Future<int> deleteSets(int id) async {
    var dbClient = await db;
    return await dbClient.delete(SET_HISTORY, where: '$SET_ID = ?', whereArgs: [id]);
  }
 //For Players
  Future<int> clear() async {
    var dbClient = await db;
    await dbClient.execute("DELETE FROM $TABLE");
    return 1;

  }
  //For Sets
  Future<int> clearSets() async {
    var dbClient = await db;
    await dbClient.execute("DELETE FROM $SET_HISTORY");
    return 1;

  }
  //For Player
  Future<int> update(Player players) async {
    var dbClient = await db;
    return await dbClient.update(TABLE, players.toMap(),
        where: '$ID = ?', whereArgs: [players.id]);
  }
 //For Sets
  Future<int> updateSets(Group sets) async {
    var dbClient = await db;
    return await dbClient.update(SET_HISTORY, sets.toMap1(),
        where: '$SET_ID = ?', whereArgs: [sets.setid]);
  }

  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}