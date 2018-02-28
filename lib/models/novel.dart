import "package:meta/meta.dart";

@immutable
class Novel {
  const Novel({
    this.slug,
    this.name,
    this.source,
    this.synopsis,
    this.posterImage,
  });

  final String slug;
  final String name;
  final String source;
  final String synopsis;
  final String posterImage;

  Novel copyWith({
    String slug,
    String name,
    String source,
    String synopsis,
    String posterImage,
  }) {
    return new Novel(
      slug: this.slug ?? slug,
      name: this.name ?? name,
      source: this.source ?? source,
      synopsis: this.synopsis ?? synopsis,
      posterImage: this.posterImage ?? posterImage,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Novel &&
          runtimeType == other.runtimeType &&
          slug == other.slug &&
          name == other.name &&
          source == other.source &&
          synopsis == other.synopsis &&
          posterImage == other.posterImage;

  @override
  int get hashCode =>
      slug.hashCode ^
      name.hashCode ^
      source.hashCode ^
      synopsis.hashCode ^
      posterImage.hashCode;

  @override
  String toString() {
    return "Novel{"
        "slug: $slug,"
        "name: $name,"
        "source: $source,"
        "synopsis: $synopsis,"
        "posterImage: $posterImage"
        "}";
  }
}