import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/book.dart';

class ApiService {
  static const String _baseUrl = 'https://openlibrary.org';
  static const String _searchUrl = '$_baseUrl/search.json';
  static const String _coverUrl = 'https://covers.openlibrary.org/b';

  Future<List<Book>> searchBooks(String query) async {
    final response = await http.get(Uri.parse('$_searchUrl?q=$query'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['docs'] != null) {
        final List<Book> books = (data['docs'] as List)
            .map((item) => Book.fromJson(item))
            .toList();
        return books;
      }
    }
    return [];
  }

  Future<Book> fetchBookDetails(String bookId) async {
    final response = await http.get(Uri.parse('$_baseUrl$bookId.json'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Book.fromJson(data);
    } else {
      throw Exception('Failed to load book details');
    }
  }

  String getCoverUrl(String? coverId, {String size = 'L'}) {
    if (coverId != null) {
      return '$_coverUrl/id/$coverId-$size.jpg';
    }
    return 'https://via.placeholder.com/150'; // Return a placeholder if no cover is available
  }
}
