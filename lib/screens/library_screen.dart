import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/library_provider.dart';
import '../widgets/book_card.dart';
import '../models/book.dart';
import '../screens/book_details_screen.dart';

class LibraryScreen extends StatelessWidget {
  const LibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Library'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Reading'),
              Tab(text: 'Read'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookList(context, (provider) => provider.readingList, 'reading'),
            _buildBookList(context, (provider) => provider.readList, 'read'),
          ],
        ),
      ),
    );
  }

  Widget _buildBookList(
      BuildContext context, List<Book> Function(LibraryProvider) getList, String listName) {
    return Consumer<LibraryProvider>(
      builder: (context, libraryProvider, child) {
        final books = getList(libraryProvider);

        if (books.isEmpty) {
          return Center(
            child: Text(
              'Your $listName list is empty.',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          );
        }

        return GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: books.length,
          padding: const EdgeInsets.all(16.0),
          itemBuilder: (context, index) {
            final book = books[index];
            return Stack(
              clipBehavior: Clip.none,
              children: [
                BookCard(
                  book: book,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(book: book),
                      ),
                    );
                  },
                ),
                Positioned(
                  top: -10,
                  right: -10,
                  child: Material(
                    color: Colors.transparent,
                    child: IconButton(
                      icon: const Icon(Icons.remove_circle),
                      color: Colors.red.shade700,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Remove Book'),
                            content: Text(
                                'Are you sure you want to remove "${book.title}" from your library?'),
                            actions: [
                              TextButton(
                                child: const Text('Cancel'),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                              TextButton(
                                child: const Text('Remove'),
                                onPressed: () {
                                  libraryProvider.removeBook(book);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
