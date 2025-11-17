import 'dart:async';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../data/quran_data.dart';

class QuranPdfScreen extends StatefulWidget {
  final int startPage;
  final String surahName;

  const QuranPdfScreen({
    Key? key,
    required this.startPage,
    required this.surahName,
  }) : super(key: key);

  @override
  State<QuranPdfScreen> createState() => _QuranPdfScreenState();
}

class _QuranPdfScreenState extends State<QuranPdfScreen> {
  late PdfViewerController _pdfController;

  int _currentPage = 1;
  final int _totalPages = 559;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _currentPage = widget.startPage;

    Future.delayed(const Duration(milliseconds: 300), () {
      _pdfController.jumpToPage(widget.startPage);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: const Text(
          'القرآن الكريم',
          style: TextStyle(
            fontFamily: 'Amiri',
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

          // 🔁 NOUVELLE LOGIQUE DU SWIPE :
          onPanEnd: (details) {
            final dx = details.velocity.pixelsPerSecond.dx;

            if (dx < -200) {
              // 👉 Swipe DROITE → GAUCHE = PAGE PRÉCÉDENTE
              if (_currentPage > 1) {
                _currentPage--;
                _pdfController.jumpToPage(_currentPage);
              }
            } else if (dx > 200) {
              // 👈 Swipe GAUCHE → DROITE = PAGE SUIVANTE
              if (_currentPage < _totalPages) {
                _currentPage++;
                _pdfController.jumpToPage(_currentPage);
              }
            }
          },

          child: Stack(
            alignment: Alignment.center,
            children: [
              AbsorbPointer(
                absorbing: true, // 🔒 empêche le scroll natif
                child: SfPdfViewer.asset(
                  'assets/quran/quran_warsh.pdf',
                  controller: _pdfController,
                  initialPageNumber: widget.startPage,

                  scrollDirection: PdfScrollDirection.horizontal,
                  pageLayoutMode: PdfPageLayoutMode.single,

                  canShowScrollHead: false,
                  canShowScrollStatus: false,
                  enableDoubleTapZooming: false,
                  interactionMode: PdfInteractionMode.pan,

                  onPageChanged: (details) {
                    setState(() => _currentPage = details.newPageNumber);
                  },
                ),
              ),

              // Indicateur de page
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
