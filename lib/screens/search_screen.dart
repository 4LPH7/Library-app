import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import 'book_details_screen.dart';

class SearchScreen extends StatelessWidget {
  final String query;
  final ApiService _apiService = ApiService();

  SearchScreen({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController(text: query);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchController,
          decoration: const InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
          ),
          onSubmitted: (newQuery) {
            if (newQuery.isNotEmpty) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => SearchScreen(query: newQuery),
                ),
              );
            }
          },
        ),
      ),
      body: FutureBuilder<List<Book>>(
        future: _apiService.searchBooks(query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books found.'));
          } else {
            return GridView.builder(
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.6,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                return BookCard(
                  book: book,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(book: book),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
