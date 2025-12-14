import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/book.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import 'book_details_screen.dart';

class SearchScreen extends StatelessWidget {
  final String query;

  const SearchScreen({super.key, required this.query});

  const SearchScreen.empty({super.key}) : query = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _SearchAppBar(query: query),
      body: query.isEmpty
          ? const _EmptySearchBody()
          : _SearchResults(query: query),
    );
  }
}

class _SearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String query;

  const _SearchAppBar({required this.query});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController(text: query);

    return AppBar(
      automaticallyImplyLeading: false,
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          color:
              Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(128),
          borderRadius: BorderRadius.circular(24),
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: 'Search books, authors, topics...',
            border: InputBorder.none,
            icon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => searchController.clear(),
            ),
          ),
          autofocus: true,
          onSubmitted: (newQuery) {
            if (newQuery.isNotEmpty && newQuery != query) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => SearchScreen(query: newQuery),
                ),
              );
            }
          },
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _EmptySearchBody extends StatelessWidget {
  const _EmptySearchBody();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.search, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          Text(
            'Let\'s find out what\'s on your mind',
            textAlign: TextAlign.center,
            style: GoogleFonts.lato(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchResults extends StatelessWidget {
  final String query;
  final ApiService _apiService = ApiService();

  _SearchResults({required this.query});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Book>>(
      future: _apiService.searchBooks(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                Text(
                  'Searching for "$query"...',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 60),
                const SizedBox(height: 20),
                Text(
                  'An error occurred.',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Please check your connection or try again later.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 100, color: Colors.grey),
                SizedBox(height: 20),
                Text(
                  'No results found for this query.',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Try a different search term.',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ],
            ),
          );
        } else {
          final books = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: books.length,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200, // Responsive grid
              childAspectRatio: 0.65, // Adjusted aspect ratio
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (context, index) {
              final book = books[index];
              final uniqueHeroTag = 'search_${book.id}_$index';
              return BookCard(
                book: book,
                uniqueHeroTag: uniqueHeroTag,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetailsScreen(
                        book: book,
                        uniqueHeroTag: uniqueHeroTag,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}
