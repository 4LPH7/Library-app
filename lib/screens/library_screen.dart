import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/models/author.dart';
import 'package:my_library/services/api_service.dart';
import 'package:provider/provider.dart';

import '../providers/library_provider.dart';
import '../widgets/book_card.dart';
import '../models/book.dart';
import '../screens/book_details_screen.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  bool _isGridView = true;
  final ApiService _apiService = ApiService();

  void _showAddEditBookDialog({Book? book}) {
    final isEditing = book != null;
    final titleController = TextEditingController(text: book?.title ?? '');
    final authorController =
        TextEditingController(text: book?.authors.map((a) => a.name).join(', ') ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Book' : 'Add a Book Manually',
            style: GoogleFonts.lato()),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Title', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: authorController,
              decoration: const InputDecoration(labelText: 'Author(s)', border: OutlineInputBorder()),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          ElevatedButton(
            child: Text(isEditing ? 'Save' : 'Add'),
            onPressed: () {
              final newBook = Book(
                id: book?.id ??
                    'new_book_${DateTime.now().millisecondsSinceEpoch}',
                title: titleController.text,
                authors: authorController.text
                    .split(',')
                    .map((name) => Author(name: name.trim(), key: ''))
                    .toList(),
              );

              final libraryProvider =
                  Provider.of<LibraryProvider>(context, listen: false);
              if (isEditing) {
                libraryProvider.updateBook(newBook);
              } else {
                libraryProvider.addBook(newBook);
              }

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Library'),
          actions: [
            IconButton(
              icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
              onPressed: () {
                setState(() {
                  _isGridView = !_isGridView;
                });
              },
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Currently Reading'),
              Tab(text: 'Already Read'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBookList(
                context, (provider) => provider.readingList, 'reading'),
            _buildBookList(context, (provider) => provider.readList, 'read'),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddEditBookDialog(),
          label: const Text('Add Book'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }

  Widget _buildBookList(BuildContext context,
      List<Book> Function(LibraryProvider) getList, String listName) {
    return Consumer<LibraryProvider>(
      builder: (context, libraryProvider, child) {
        final books = getList(libraryProvider);

        if (books.isEmpty) {
          return Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.book, size: 100, color: Colors.grey),
                  const SizedBox(height: 20),
                  Text(
                    'Your ${listName.replaceAll('_', ' ')} list is empty.',
                    style: GoogleFonts.lato(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Add some books to get started!',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],),);
        }

        return RefreshIndicator(
          onRefresh: () async {
            setState(() {});
          },
          child: _isGridView
              ? _buildGridView(books, listName, libraryProvider)
              : _buildListView(books, listName, libraryProvider),
        );
      },
    );
  }

  GridView _buildGridView(List<Book> books, String listName, LibraryProvider libraryProvider) {
    return GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 0.65,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: books.length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              final book = books[index];
              final uniqueHeroTag = '${listName}_${book.id}';
              return Stack(
                clipBehavior: Clip.none,
                children: [
                  BookCard(
                    book: book,
                    uniqueHeroTag: uniqueHeroTag,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailsScreen(
                              book: book, uniqueHeroTag: uniqueHeroTag),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    top: -12,
                    right: -12,
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        icon: const Icon(Icons.remove_circle, size: 28),
                        color: Colors.red.shade700,
                        onPressed: () {
                          _showRemoveDialog(context, libraryProvider, book);
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          );
  }

  ListView _buildListView(List<Book> books, String listName, LibraryProvider libraryProvider) {
    return ListView.builder(
            itemCount: books.length,
            padding: const EdgeInsets.all(16.0),
            itemBuilder: (context, index) {
              final book = books[index];
              final uniqueHeroTag = '${listName}_${book.id}';
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: book.coverId != null
                      ? CachedNetworkImage(
                          imageUrl: _apiService.getCoverUrl(book.coverId, size: 'M'),
                          width: 50,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Image.asset(
                              'assets/images/placeholder.png',
                              fit: BoxFit.cover),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        )
                      : const Icon(Icons.book, size: 50),
                  title: Text(book.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(book.authors.map((a) => a.name).join(', ')),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BookDetailsScreen(
                            book: book, uniqueHeroTag: uniqueHeroTag),
                      ),
                    );
                  },
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blueGrey),
                        onPressed: () => _showAddEditBookDialog(book: book),
                      ),
                      IconButton(
                        icon: const Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          _showRemoveDialog(context, libraryProvider, book);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }

  void _showRemoveDialog(
      BuildContext context, LibraryProvider libraryProvider, Book book) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Removal'),
        content: Text(
            'Are you sure you want to remove "${book.title}" from your library?'),
        actions: [
          TextButton(
            child: const Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove'),
            onPressed: () {
              libraryProvider.removeBook(book);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('"${book.title}" was removed.')));
            },
          ),
        ],
      ),
    );
  }
}
