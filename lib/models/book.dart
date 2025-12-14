import 'package:my_library/models/author.dart';

class Book {
  final String id;
  final String title;
  final String? subtitle;
  final List<Author> authors;
  final String? coverId;
  final String? description;

  Book({
    required this.id,
    required this.title,
    this.subtitle,
    required this.authors,
    this.coverId,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse descriptions, which can be a String or a Map.
    String? parseDescription(dynamic desc) {
      if (desc is String) return desc;
      if (desc is Map<String, dynamic> && desc.containsKey('value')) {
        return desc['value'] as String?;
      }
      return null;
    }

    // Combines author names and keys into a list of Author objects.
    List<Author> getAuthors(Map<String, dynamic> jsonData) {
      final names = jsonData['author_name'] as List?;
      final keys = jsonData['author_key'] as List?;

      if (names == null || keys == null || names.length != keys.length) {
        return [Author.unknown()];
      }

      return List<Author>.generate(
        names.length,
        (i) => Author(key: keys[i].toString(), name: names[i].toString()),
      ).toList();
    }

    return Book(
      id: json['key']?.toString().split('/').last ?? '',
      title: json['title'] ?? 'Untitled',
      subtitle: json['subtitle'],
      authors: getAuthors(json),
      coverId: json['cover_i']?.toString(),
      description: parseDescription(json['description']),
    );
  }

  Map<String, dynamic> toJson() => {
        'key': '/books/$id',
        'title': title,
        'subtitle': subtitle,
        'author_name': authors.map((a) => a.name).toList(),
        'author_key': authors.map((a) => a.key).toList(),
        'cover_i': coverId,
        'description': description,
      };
}
