import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/book.dart';

class LibraryProvider with ChangeNotifier {
  List<Book> _readingList = [];
  List<Book> _readList = [];

  List<Book> get readingList => _readingList;
  List<Book> get readList => _readList;

  static const _readingListKey = 'reading_list';
  static const _readListKey = 'read_list';

  LibraryProvider() {
    loadLibrary();
  }

  Future<void> loadLibrary() async {
    final prefs = await SharedPreferences.getInstance();

    final readingListString = prefs.getString(_readingListKey);
    if (readingListString != null) {
      final List<dynamic> readingListJson = jsonDecode(readingListString);
      _readingList = readingListJson.map((json) => Book.fromJson(json)).toList();
    }

    final readListString = prefs.getString(_readListKey);
    if (readListString != null) {
      final List<dynamic> readListJson = jsonDecode(readListString);
      _readList = readListJson.map((json) => Book.fromJson(json)).toList();
    }

    notifyListeners();
  }

  Future<void> _saveLibrary() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_readingListKey, jsonEncode(_readingList));
    prefs.setString(_readListKey, jsonEncode(_readList));
  }

  void addBook(Book book, {bool isRead = false}) {
    if (isRead) {
      _readingList.removeWhere((b) => b.id == book.id);
      if (!_readList.any((b) => b.id == book.id)) {
        _readList.add(book);
      }
    } else {
      if (!_readList.any((b) => b.id == book.id)) {
        if (!_readingList.any((b) => b.id == book.id)) {
          _readingList.add(book);
        }
      }
    }
    notifyListeners();
    _saveLibrary();
  }

  void updateBook(Book book) {
    final readingIndex = _readingList.indexWhere((b) => b.id == book.id);
    if (readingIndex != -1) {
      _readingList[readingIndex] = book;
    }

    final readIndex = _readList.indexWhere((b) => b.id == book.id);
    if (readIndex != -1) {
      _readList[readIndex] = book;
    }

    notifyListeners();
    _saveLibrary();
  }

  void moveToRead(Book book) {
    _readingList.removeWhere((b) => b.id == book.id);
    if (!_readList.any((b) => b.id == book.id)) {
      _readList.add(book);
    }
    notifyListeners();
    _saveLibrary();
  }

  void removeBook(Book book) {
    _readingList.removeWhere((b) => b.id == book.id);
    _readList.removeWhere((b) => b.id == book.id);
    notifyListeners();
    _saveLibrary();
  }
}
