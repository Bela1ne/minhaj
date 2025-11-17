import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookReaderScreen extends StatefulWidget {
  final String title;
  final String filePath;
  final int bookId;

  const BookReaderScreen({
    super.key,
    required this.title,
    required this.filePath,
    required this.bookId,
  });

  @override
  State<BookReaderScreen> createState() => _BookReaderScreenState();
}

class _BookReaderScreenState extends State<BookReaderScreen> {
  late PdfViewerController _pdfController;

  int _currentPage = 1;
  int _totalPages = 1;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _loadLastPage();

    // Jump après un petit délai pour éviter le bug d'ouverture
    Future.delayed(const Duration(milliseconds: 300), () {
      _pdfController.jumpToPage(_currentPage);
    });
  }

  // 🔖 Charger la dernière page lue
  Future<void> _loadLastPage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedPage = prefs.getInt("book_${widget.bookId}_page") ?? 1;

    setState(() => _currentPage = savedPage);
  }

  // 🔖 Sauvegarder la page actuelle
  Future<void> _saveLastPage(int page) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt("book_${widget.bookId}_page", page);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? Colors.black : Colors.white,

      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontFamily: "Amiri",
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDark
                ? [Colors.black87, Colors.teal.shade900]
                : [Colors.teal.shade100, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: GestureDetector(
          behavior: HitTestBehavior.opaque,

          // 📌 Swipe horizontal EXACTEMENT comme QuranPdfScreen
          onPanEnd: (details) {
            final dx = details.velocity.pixelsPerSecond.dx;

            if (dx < -200) {
              // 👉 Swipe droite → gauche = page précédente
              if (_currentPage > 1) {
                _currentPage--;
                _pdfController.jumpToPage(_currentPage);
              }
            } else if (dx > 200) {
              // 👈 Swipe gauche → droite = page suivante
              _pdfController.jumpToPage(_currentPage + 1);
            }
          },

          child: Stack(
            children: [
              AbsorbPointer(
                absorbing: true, // 🔒 empêche le scroll natif
                child: SfPdfViewer.asset(
                  widget.filePath,
                  controller: _pdfController,

                  scrollDirection: PdfScrollDirection.horizontal,
                  pageLayoutMode: PdfPageLayoutMode.single,

                  canShowScrollHead: false,
                  canShowScrollStatus: false,
                  enableDoubleTapZooming: false,
                  interactionMode: PdfInteractionMode.pan,

                  onDocumentLoaded: (details) {
                    setState(() => _totalPages = details.document.pages.count);
                  },

                  onPageChanged: (details) {
                    setState(() => _currentPage = details.newPageNumber);
                    _saveLastPage(details.newPageNumber);
                  },
                ),
              ),

              // 📄 Indicateur de page
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    "Page $_currentPage / $_totalPages",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: 'Amiri',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
