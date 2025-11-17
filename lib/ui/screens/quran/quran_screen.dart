import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/quran_data.dart';
import '../../../models/quran_model.dart';
import 'quran_pdf_screen.dart';

class QuranScreen extends StatefulWidget {
  const QuranScreen({super.key});

  @override
  State<QuranScreen> createState() => _QuranScreenState();
}

class _QuranScreenState extends State<QuranScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Surah> filteredSurahs = QuranData.getAllSurahs();
  bool _showSearchBar = false;

  void _filterSurahs(String query) {
    final all = QuranData.getAllSurahs();
    if (query.isEmpty) {
      setState(() => filteredSurahs = all);
    } else {
      setState(() {
        final q = query.toLowerCase();
        filteredSurahs = all.where((s) {
          return s.name.toLowerCase().contains(q) ||
              s.frenchName.toLowerCase().contains(q) ||
              s.arabicName.contains(query);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background,

      // 🏷️ AppBar élégante comme HomeScreen
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '📖 القرآن الكريم',
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Amiri',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textLight),
            onPressed: () {
              setState(() => _showSearchBar = !_showSearchBar);
              if (!_showSearchBar) {
                _searchController.clear();
                _filterSurahs('');
              }
            },
          ),
        ],
      ),

      // 🔍 Barre de recherche contextuelle
      body: Column(
        children: [
          // Barre de recherche animée
          if (_showSearchBar)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterSurahs,
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 16,
                    color: Colors.black, // Couleur explicite
                  ),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن سورة...',
                    hintStyle: const TextStyle(
                      fontFamily: 'Amiri',
                      color: Colors.grey,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.teal),
                    filled: true,
                    fillColor: isDark ? Colors.white10 : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            )
                .animate(delay: 50.ms)
                .fade(duration: 200.ms)
                .slideY(
              begin: -0.5,
              end: 0.0,
              curve: Curves.easeOut,
            ),

          // 📊 Indicateur de résultats
          if (_showSearchBar && _searchController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryDark.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: AppColors.primaryDark.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      "${filteredSurahs.length} نتيجة",
                      style: TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 14,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      _filterSurahs('');
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Text(
                            "مسح البحث",
                            style: TextStyle(
                              fontFamily: 'Amiri',
                              fontSize: 12,
                              color: Colors.red,
                            ),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.close, size: 14, color: Colors.red),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fade(duration: 200.ms),

          const SizedBox(height: 8),

          // 📖 Liste des sourates
          Expanded(
            child: filteredSurahs.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 60,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchController.text.isEmpty
                        ? "لا توجد سور متاحة"
                        : "لا توجد نتائج للبحث",
                    style: const TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        _filterSurahs('');
                      },
                      child: const Text(
                        "عرض جميع السور",
                        style: TextStyle(
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ),
                ],
              ),
            )
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredSurahs.length,
              itemBuilder: (context, index) {
                final surah = filteredSurahs[index];
                return _buildSurahCard(surah, isDark, index);
              },
            ),
          ),
        ],
      ),
    );
  }

  // 🎴 Carte de sourate SIMPLIFIÉE et LISIBLE
  Widget _buildSurahCard(Surah surah, bool isDark, int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Card(
        color: isDark ? Colors.white10 : Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuranPdfScreen(
                  surahName: surah.frenchName,
                  startPage: surah.pageNumber,
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Row(
              children: [
                // Badge numéro de sourate
                Container(
                  width: 45,
                  height: 45,
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.primaryDark,
                      width: 1.5,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '${surah.id}',
                      style: const TextStyle(
                        color: AppColors.primaryDark,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Colonne informations françaises
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        surah.frenchName,
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${surah.revelationType} • ${surah.verseCount} آيات',
                        style: TextStyle(
                          color: isDark ? Colors.white70 : Colors.grey[700],
                          fontSize: 13,
                          fontFamily: 'Amiri',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Colonne informations arabes
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      surah.arabicName,
                      style: const TextStyle(
                        fontFamily: 'Uthmanic',
                        fontSize: 24,
                        color: Colors.teal,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.right,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'الصفحة ${surah.pageNumber}',
                      style: TextStyle(
                        color: isDark ? Colors.white54 : Colors.grey[600],
                        fontSize: 12,
                        fontFamily: 'Amiri',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fade(duration: 300.ms).slideX(
      begin: index.isEven ? 0.1 : -0.1,
      curve: Curves.easeOut,
    );
  }
}