import "dart:async";

import "package:app/database/database_wrapper.dart";
import "package:app/models/chapter.dart";
import "package:app/models/novel.dart";
import "package:flutter/material.dart";
import "package:meta/meta.dart";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";
import "package:sqflite/sqflite.dart";

class DatabaseProvider extends StatefulWidget {
  const DatabaseProvider({@required this.child});

  final Widget child;

  static DatabaseProviderState of(BuildContext context) {
    const matcher = const TypeMatcher<DatabaseProviderState>();
    return context.ancestorStateOfType(matcher);
  }

  @override
  State createState() => new DatabaseProviderState();
}

class DatabaseProviderState extends State<DatabaseProvider> {
  DatabaseWrapper _database;

  DatabaseWrapper get database => _database;

  Future<Null> _setup() async {
    final documents = await getApplicationDocumentsDirectory();
    final path = join(documents.path, "microcosm.db");
    final database = await openDatabase(
      path,
      version: 4,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    // Update the view
    setState(() => _database = new DatabaseWrapper(database));
  }

  Future<Null> _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE IF NOT EXISTS ${Chapter.type} ("
        "slug TEXT PRIMARY KEY,"
        "url TEXT NOT NULL,"
        "previousUrl TEXT,"
        "nextUrl TEXT,"
        "title TEXT,"
        "content TEXT,"
        "createdAt TEXT,"
        "readAt TEXT,"
        "novelSlug TEXT"
        ")");

    await db.execute("CREATE TABLE IF NOT EXISTS ${Novel.type} ("
        "slug TEXT PRIMARY KEY,"
        "name TEXT NOT NULL,"
        "source TEXT,"
        "synopsis TEXT,"
        "posterImage TEXT"
        ")");
  }

  Future<Null> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Recreate the database
    await _onCreate(db, newVersion);

    if (oldVersion == 2) {
      await db.execute("ALTER TABLE ${Novel.type} ADD novelSlug TEXT");
      oldVersion++;
    }
    if (oldVersion == 3) {
      await db.execute("ALTER TABLE ${Chapter.type} ADD createdAt TEXT");
      await db.execute("ALTER TABLE ${Chapter.type} ADD readAt TEXT");
      oldVersion++;
    }
  }

  @override
  void initState() {
    super.initState();

    _setup();
  }

  @override
  Widget build(BuildContext context) {
    if (database == null) {
      return new Container(width: 0.0, height: 0.0);
    }

    return widget.child;
  }
}
