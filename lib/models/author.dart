class Author {
  final String key;
  final String name;

  Author({required this.key, required this.name});

  // A special representation for when an author is unknown.
  factory Author.unknown() => Author(key: '', name: 'Unknown Author');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Author && runtimeType == other.runtimeType && key == other.key;

  @override
  int get hashCode => key.hashCode;
}
