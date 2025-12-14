class Book {
  final String id;
  final String title;
  final List<String> authors;
  final String? coverId;
  final String? description;

  Book({
    required this.id,
    required this.title,
    required this.authors,
    this.coverId,
    this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['key'] ?? '', // The book's key is a more reliable ID
      title: json['title'] ?? 'Untitled',
      authors: json['author_name'] != null
          ? List<String>.from(json['author_name'])
          : ['Unknown Author'],
      coverId: json['cover_i']?.toString(),
      description: json['description'] as String?,
    );
  }
}
