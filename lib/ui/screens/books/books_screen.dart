import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/books_data.dart';
import '../../../models/book_model.dart';
import 'book_reader_screen.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final List<Book> books = BooksData.getAllBooks();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryDark),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '📚 المكتبة الإسلامية',
          style: TextStyle(
            color: AppColors.primaryDark,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Amiri',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildVerticalBookGrid(books),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.primaryDark,
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: AppColors.primaryDark.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            count.toString(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerticalBookGrid(List<Book> books) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: books.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.55,
      ),
      itemBuilder: (context, index) {
        final book = books[index];
        return _BookVerticalCard(book: book);
      },
    );
  }
}

class _BookVerticalCard extends StatelessWidget {
  final Book book;

  const _BookVerticalCard({required this.book});

  void _showBookDetails(BuildContext context, Book book) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => _BookDetailsSheet(book: book),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () => _showBookDetails(context, book), // Clic sur toute la carte affiche les détails
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Image de couverture
          Expanded(
            flex: 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                book.cover,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return _buildDefaultBookCover(book.title);
                },
              ),
            ),
          ),

          const SizedBox(height: 8),

          // Informations du livre
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre
                Text(
                  book.title,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                // Auteur
                Text(
                  book.author,
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark ? Colors.white70 : Colors.grey[600],
                    fontFamily: 'Amiri',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 300.ms).slideY(
      begin: 0.1,
      curve: Curves.easeOut,
    );
  }

  Widget _buildDefaultBookCover(String title) {
    return Container(
      color: AppColors.primaryDark.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.menu_book,
            size: 24,
            color: AppColors.primaryDark,
          ),
          const SizedBox(height: 4),
          Text(
            _getBookInitials(title),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  String _getBookInitials(String title) {
    final words = title.split(' ');
    if (words.length >= 2) {
      return '${words[0][0]}${words[1][0]}';
    } else if (title.isNotEmpty) {
      return title.substring(0, 1);
    }
    return '📖';
  }
}

class _BookDetailsSheet extends StatelessWidget {
  final Book book;

  const _BookDetailsSheet({required this.book});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // En-tête avec image
          Row(
            children: [
              // Image cliquable pour ouvrir directement le PDF
              GestureDetector(
                onTap: () {
                  Navigator.pop(context); // Fermer les détails
                  _openPdf(context, book); // Ouvrir directement le PDF
                },
                child: Container(
                  width: 80,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: AppColors.primaryDark.withOpacity(0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      book.cover,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: AppColors.primaryDark.withOpacity(0.1),
                          child: const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.book, size: 32, color: AppColors.primaryDark),
                              SizedBox(height: 4),
                              Text(
                                'PDF',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primaryDark,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      book.author,
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? Colors.white70 : Colors.grey[600],
                        fontFamily: 'Amiri',
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${book.totalPages} صفحة',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? Colors.white60 : Colors.grey[500],
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Description
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryDark.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              book.description,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? Colors.white70 : Colors.grey[700],
                fontFamily: 'Amiri',
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: 20),

          // Boutons d'action
          Row(
            children: [
              // Bouton pour lire le PDF
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Fermer les détails
                    _openPdf(context, book); // Ouvrir le PDF
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'قراءة الكتاب',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Amiri',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Bouton secondaire pour fermer
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'إغلاق',
                    style: TextStyle(
                      color: isDark ? Colors.white70 : Colors.grey[700],
                      fontFamily: 'Amiri',
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _openPdf(BuildContext context, Book book) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookReaderScreen(
          title: book.title,
          filePath: book.filePath,
          bookId: int.parse(book.id),
        ),
      ),
    );
  }
}