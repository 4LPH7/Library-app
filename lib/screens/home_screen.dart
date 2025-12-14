import 'dart:async';

import 'package:flutter/material.dart';

import '../models/book.dart';
import '../services/api_service.dart';
import '../widgets/book_card.dart';
import '../widgets/shimmer_book_card.dart';
import 'book_details_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Book>> _scienceFictionBooks;
  late Future<List<Book>> _fantasyBooks;
  late Future<List<Book>> _mysteryBooks;
  late Future<List<Book>> _romanceBooks;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _scienceFictionBooks = _apiService.searchBooks('science fiction');
    _fantasyBooks = _apiService.searchBooks('fantasy');
    _mysteryBooks = _apiService.searchBooks('mystery');
    _romanceBooks = _apiService.searchBooks('romance');

    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  void _startTimer(int pageCount) {
    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < pageCount - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 30,
              width: 30,
            ),
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
            const SizedBox(height: 20),
            _buildSectionTitle('Trending Books'),
            _buildTrendingCarousel(),
            const SizedBox(height: 20),
            _buildSectionTitle('Fantasy'),
            _buildBookGrid(_fantasyBooks),
            const SizedBox(height: 20),
            _buildSectionTitle('Mystery'),
            _buildBookList(_mysteryBooks),
            const SizedBox(height: 20),
            _buildSectionTitle('Romance'),
            _buildBookList(_romanceBooks),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search for books, authors, or genres',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        onSubmitted: (value) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchScreen(query: value),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildTrendingCarousel() {
    return SizedBox(
      height: 350,
      child: FutureBuilder<List<Book>>(
        future: _scienceFictionBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ShimmerBookCard();
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No science fiction books found.'));
          } else {
            if (_timer == null) {
              _startTimer(snapshot.data!.length);
            }
            return PageView.builder(
              controller: _pageController,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                return _buildTrendingBookCard(book, index);
              },
            );
          }
        },
      ),
    );
  }

  Widget _buildTrendingBookCard(Book book, int index) {
    double scale = _currentPage == index ? 1.0 : 0.8;
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: scale, end: scale),
      duration: const Duration(milliseconds: 350),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: GestureDetector(
        onTap: () => _showBookDetails(book),
        child: Hero(
          tag: book.id,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).shadowColor.withAlpha(76),
                  spreadRadius: 2,
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                _apiService.getCoverUrl(book.coverId),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.error),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookGrid(Future<List<Book>> futureBooks) {
    return FutureBuilder<List<Book>>(
      future: futureBooks,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 4,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              return const ShimmerBookCard();
            },
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No books found.'));
        } else {
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.6,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final book = snapshot.data![index];
              return BookCard(book: book, onTap: () => _showBookDetails(book));
            },
          );
        }
      },
    );
  }

  Widget _buildBookList(Future<List<Book>> futureBooks) {
    return SizedBox(
      height: 250,
      child: FutureBuilder<List<Book>>(
        future: futureBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                return const SizedBox(
                  width: 150,
                  child: ShimmerBookCard(),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books found.'));
          } else {
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final book = snapshot.data![index];
                return SizedBox(
                  width: 150,
                  child:
                      BookCard(book: book, onTap: () => _showBookDetails(book)),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _showBookDetails(Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BookDetailsScreen(book: book),
      ),
    );
  }
}
