import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import '../widgets/shimmer_book_card.dart';
import 'book_details_screen.dart';

class HomeScreen extends StatefulWidget {
  final void Function(String) onSearch;

  const HomeScreen({super.key, required this.onSearch});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Book>> _recommendedBooks;
  late Future<List<Book>> _classicBooks;

  static const double _carouselHeight = 380;

  @override
  void initState() {
    super.initState();
    _recommendedBooks =
        _apiService.searchBooks('science fiction');
    _classicBooks = _apiService.searchBooks('classic literature');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset('assets/images/logo.png', height: 40),
            const SizedBox(width: 10),
            const Text('My Library'),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchField(),
            const SizedBox(height: 16),
            _buildSectionTitle('Recommended'),
            _buildTrendingCarousel(),
            const SizedBox(height: 24),
            _buildSectionTitle('Classics'),
            _buildBookGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for books, authors, or genres',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
        onSubmitted: (value) {
          if (value.isNotEmpty) {
            widget.onSearch(value);
          }
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTrendingCarousel() {
    return SizedBox(
      height: _carouselHeight,
      child: FutureBuilder<List<Book>>(
        future: _recommendedBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CarouselSlider.builder(
              itemCount: 3,
              itemBuilder: (_, __, ___) => const ShimmerBookCard(),
              options: _carouselOptions(),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recommendations'));
          }

          final books = snapshot.data!;
          return CarouselSlider.builder(
            itemCount: books.length,
            itemBuilder: (context, index, _) {
              final book = books[index];
              final tag = 'recommended_${book.id}_$index';
              return BookCard(
                book: book,
                uniqueHeroTag: tag,
                onTap: () => _openDetails(book, tag),
              );
            },
            options: _carouselOptions(),
          );
        },
      ),
    );
  }

  CarouselOptions _carouselOptions() {
    return CarouselOptions(
      height: _carouselHeight,
      viewportFraction: 0.55,
      autoPlay: true,
      enlargeCenterPage: true,
      enlargeStrategy: CenterPageEnlargeStrategy.height, // 🔑 HERO SAFE
    );
  }

  Widget _buildBookGrid() {
    return FutureBuilder<List<Book>>(
      future: _classicBooks,
      builder: (context, snapshot) {
        final loading = snapshot.connectionState == ConnectionState.waiting;
        final books = snapshot.data ?? [];

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          itemCount: loading ? 4 : books.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.62,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemBuilder: (context, index) {
            if (loading) return const ShimmerBookCard();
            final book = books[index];
            final tag = 'classic_${book.id}_$index';
            return BookCard(
              book: book,
              uniqueHeroTag: tag,
              onTap: () => _openDetails(book, tag),
            );
          },
        );
      },
    );
  }

  void _openDetails(Book book, String tag) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookDetailsScreen(
          book: book,
          uniqueHeroTag: tag,
        ),
      ),
    );
  }
}
