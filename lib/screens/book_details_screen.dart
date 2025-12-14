import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/library_provider.dart';
import '../services/api_service.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;
  final ApiService _apiService = ApiService();

  BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(book.title, style: const TextStyle(fontSize: 16)),
              background: Hero(
                tag: book.id,
                child: Image.network(
                  _apiService.getCoverUrl(book.coverId),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'By ${book.authors.join(', ')}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    book.description ?? 'No description available.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 20),
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Provider.of<LibraryProvider>(context, listen: false).addBook(book, isRead: false);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to your reading list!')),
            );
          },
          icon: const Icon(Icons.bookmark_add_outlined),
          label: const Text('Add to Reading List'),
        ),
        const SizedBox(height: 12),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 50),
            backgroundColor: Theme.of(context).colorScheme.secondary,
            foregroundColor: Theme.of(context).colorScheme.onSecondary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: () {
            Provider.of<LibraryProvider>(context, listen: false).addBook(book, isRead: true);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Added to your read list!')),
            );
          },
          icon: const Icon(Icons.check_circle_outline),
          label: const Text('Mark as Read'),
        ),
      ],
    );
  }
}
