import "dart:async";

import "package:app/database/database_wrapper.dart";
import "package:app/models/novel.dart";
import "package:app/sources/novel_source.dart";
import "package:meta/meta.dart";

@immutable
class NovelDao implements NovelSource {
  const NovelDao(this._database);

  final DatabaseWrapper _database;

  @override
  Future<Novel> get({String slug}) async {
    final results = await _database.query(
      table: Novel.type,
      where: {"slug": slug},
      limit: 1,
    );

    return results.isEmpty ? null : new Novel.fromJson(results.single);
  }

  @override
  Future<List<Novel>> list({int limit, int offset}) async {
    final results = await _database.query(
      table: Novel.type,
      limit: limit,
      offset: offset,
    );

    return results.map((result) => new Novel.fromJson(result)).toList();
  }

  Future<bool> exists({String slug}) async {
    final count = await _database.count(
      table: Novel.type,
      where: {"slug": slug},
      limit: 1,
    );
    return count > 0;
  }

  Future<Null> upsert(Novel novel) async {
    if (novel == null) {
      return;
    }

    // This creates a Map<String, dynamic> of the attributes
    final attributes = novel.toJson();

    if (await exists(slug: novel.slug)) {
      await _database.update(
        table: Novel.type,
        where: {"slug": novel.slug},
        values: attributes,
      );
    } else {
      await _database.insert(
        table: Novel.type,
        values: attributes,
      );
    }
  }
}
