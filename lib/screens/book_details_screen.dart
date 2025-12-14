import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_library/models/author.dart';
import 'package:my_library/widgets/book_card.dart';
import 'package:provider/provider.dart';

import '../models/book.dart';
import '../providers/library_provider.dart';
import '../services/api_service.dart';

class BookDetailsScreen extends StatefulWidget {
  final Book book;
  final String uniqueHeroTag;

  const BookDetailsScreen(
      {super.key, required this.book, required this.uniqueHeroTag});

  @override
  State<BookDetailsScreen> createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends State<BookDetailsScreen> {
  final ApiService _apiService = ApiService();
  List<Book> _recommendations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRecommendations();
  }

  Future<void> _fetchRecommendations() async {
    if (widget.book.authors.isNotEmpty &&
        widget.book.authors.first.key.isNotEmpty) {
      final authorKey = widget.book.authors.first.key;
      try {
        final works = await _apiService.getWorksByAuthor(authorKey);
        if (mounted) {
          setState(() {
            _recommendations =
                works.where((work) => work.id != widget.book.id).toList();
            _isLoading = false;
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(colorScheme),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTitleAndAuthor(textTheme, colorScheme),
                  const SizedBox(height: 24),
                  _buildDescription(textTheme, colorScheme),
                  const SizedBox(height: 32),
                  _buildActionButtons(context),
                  const SizedBox(height: 40),
                  _buildRecommendationsSection(textTheme),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(ColorScheme colorScheme) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      stretch: true,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.onSurface,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 48, vertical: 12),
        centerTitle: true,
        title: Text(
          widget.book.title,
          textAlign: TextAlign.center,
          style: GoogleFonts.oswald(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        background: _buildAppBarBackground(colorScheme),
      ),
    );
  }

  Widget _buildAppBarBackground(ColorScheme colorScheme) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Hero(
          tag: widget.uniqueHeroTag,
          child: CachedNetworkImage(
            imageUrl: _apiService.getCoverUrl(widget.book.coverId, size: 'L'),
            fit: BoxFit.cover,
            placeholder: (context, url) =>
                Container(color: colorScheme.primaryContainer),
            errorWidget: (context, url, error) =>
                Container(color: colorScheme.errorContainer),
          ),
        ),
        const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(0.0, 0.7),
              end: Alignment.center,
              colors: [Color(0x80000000), Color(0x00000000)],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleAndAuthor(
      TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (widget.book.subtitle != null && widget.book.subtitle!.isNotEmpty)
          Text(
            widget.book.subtitle!,
            textAlign: TextAlign.center,
            style: textTheme.titleMedium?.copyWith(
              fontStyle: FontStyle.italic,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        const SizedBox(height: 8),
        Text(
          'By ${widget.book.authors.map((a) => a.name).join(', ')}',
          textAlign: TextAlign.center,
          style: textTheme.titleMedium?.copyWith(
            color: colorScheme.secondary,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(TextTheme textTheme, ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About This Book',
          style: GoogleFonts.roboto(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          widget.book.description ?? 'No description available.',
          style: textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: colorScheme.onSurface.withOpacity(0.85),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final libraryProvider = Provider.of<LibraryProvider>(context, listen: false);
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<LibraryProvider>(
      builder: (context, library, child) {
        final isInReadingList = library.readingList.any((b) => b.id == widget.book.id);
        final isInReadList = library.readList.any((b) => b.id == widget.book.id);

        return Column(
          children: [
            ElevatedButton.icon(
               icon: Icon(isInReadingList || isInReadList
              ? Icons.bookmark_added
              : Icons.bookmark_add_outlined),
              label: Text(
            isInReadingList
                ? 'In Your Reading List'
                : (isInReadList ? 'Already Read' : 'Add to Reading List'),
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
              onPressed: () => libraryProvider.addBook(widget.book, isRead: false),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
               icon: Icon(
              isInReadList ? Icons.check_circle : Icons.check_circle_outline),
          label: Text(
            isInReadList ? 'Already in Read List' : 'Mark as Read',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
              onPressed: () => libraryProvider.addBook(widget.book, isRead: true),
            ),
          ],
        );
      },
    );
  }

  Widget _buildRecommendationsSection(TextTheme textTheme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (_recommendations.isEmpty) {
      return const Text('No other works found for this author.');
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'More by ${widget.book.authors.first.name}',
            style: GoogleFonts.roboto(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 280,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _recommendations.length,
              itemBuilder: (context, index) {
                final recommendedBook = _recommendations[index];
                final uniqueHeroTag = 'recommendation_${recommendedBook.id}';
                return SizedBox(
                  width: 160,
                  child: BookCard(
                    book: recommendedBook,
                    uniqueHeroTag: uniqueHeroTag,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BookDetailsScreen(
                            book: recommendedBook,
                            uniqueHeroTag: uniqueHeroTag,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      );
    }
  }
}
