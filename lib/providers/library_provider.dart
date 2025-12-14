import 'package:flutter/material.dart';
import '../models/book.dart';

class LibraryProvider with ChangeNotifier {
  final List<Book> _readingList = [];
  final List<Book> _readList = [];

  List<Book> get readingList => _readingList;
  List<Book> get readList => _readList;

  void addBook(Book book, {bool isRead = false}) {
    if (isRead) {
      // If the book is in the reading list, remove it.
      _readingList.removeWhere((b) => b.id == book.id);
      // Add it to the read list if it's not already there.
      if (!_readList.any((b) => b.id == book.id)) {
        _readList.add(book);
      }
    } else {
      // If the book is already in the read list, do nothing.
      if (!_readList.any((b) => b.id == book.id)) {
        // Add it to the reading list if it's not already there.
        if (!_readingList.any((b) => b.id == book.id)) {
          _readingList.add(book);
        }
      }
    }
    notifyListeners();
  }

  void moveToRead(Book book) {
    _readingList.removeWhere((b) => b.id == book.id);
    if (!_readList.any((b) => b.id == book.id)) {
      _readList.add(book);
    }
    notifyListeners();
  }

  void removeBook(Book book) {
    _readingList.removeWhere((b) => b.id == book.id);
    _readList.removeWhere((b) => b.id == book.id);
    notifyListeners();
  }
}
