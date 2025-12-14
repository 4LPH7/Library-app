import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:my_library/models/author.dart';
import '../models/book.dart';

class ApiService {
  static const String _baseUrl = 'https://openlibrary.org';
  static const String _searchUrl = '$_baseUrl/search.json';
  static const String _coverUrl = 'https://covers.openlibrary.org/b';

  // Optimized search method with the 'fields' parameter.
  Future<List<Book>> searchBooks(String query) async {
    final fields = [
      'key',
      'title',
      'subtitle',
      'author_name',
      'author_key',
      'cover_i',
      'first_publish_year', // For more context.
      'description', // Fetch description upfront.
    ].join(',');

    final url = Uri.parse('$_searchUrl?q=$query&fields=$fields&limit=20');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['docs'] != null) {
          return (data['docs'] as List)
              .map((item) => Book.fromJson(item))
              .toList();
        }
      }
      log('Failed to search books. Status: ${response.statusCode}');
    } catch (e) {
      log('Error during book search: $e');
    }
    return [];
  }

  // New method to get other works by a given author.
  Future<List<Book>> getWorksByAuthor(String authorKey, {int limit = 10}) async {
    if (authorKey.isEmpty) return [];

    final url = Uri.parse('$_baseUrl/authors/$authorKey/works.json?limit=$limit');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['entries'] is List) {
          return (data['entries'] as List)
              .map((item) => Book.fromJson(item))
              .toList();
        }
      }
      log(
          'Failed to fetch works for author $authorKey. Status: ${response.statusCode}');
    } catch (e) {
      log('Error fetching author works: $e');
    }
    return [];
  }

  String getCoverUrl(String? coverId, {String size = 'L'}) {
    if (coverId != null && coverId.isNotEmpty) {
      return '$_coverUrl/id/$coverId-$size.jpg';
    }
    return 'https://cdn.dribbble.com/users/1293587/screenshots/4135599/dribbble.jpg';
  }
}
