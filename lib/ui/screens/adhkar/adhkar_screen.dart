import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
// Chemins d'importation vérifiés
import '../../../core/constants/app_colors.dart';
import '../../../models/adhkar_model.dart';
import '../../../services/adhkar_service.dart';
import 'adhkar_detail_screen.dart'; // Importez l'écran de détail

class AdhkarScreen extends StatefulWidget {
  const AdhkarScreen({super.key});

  @override
  State<AdhkarScreen> createState() => _AdhkarScreenState();
}

class _AdhkarScreenState extends State<AdhkarScreen> {
  final AdhkarService _adhkarService = AdhkarService();
  final TextEditingController _searchController = TextEditingController();

  // La liste affichée est une liste de chapitres (AdhkarModel)
  List<AdhkarModel> filteredChapters = [];

  bool _showSearchBar = false;

  @override
  void initState() {
    super.initState();
    // Afficher tous les chapitres au départ
    filteredChapters = _adhkarService.getAllChapters();
  }

  // Logique de filtrage des chapitres par leur titre
  void _filterChapters(String query) {
    final all = _adhkarService.getAllChapters();
    if (query.isEmpty) {
      setState(() => filteredChapters = all);
    } else {
      setState(() {
        final q = query.toLowerCase();
        // Filtrer uniquement par le titre arabe du chapitre
        filteredChapters = all.where((c) {
          return c.title.contains(query) ||
              c.title.toLowerCase().contains(q);
        }).toList();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // --- Composants UI de Recherche et d'Affichage des Résultats ---

  Widget _buildSearchBar(bool isDark) {
    return Padding(
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
          onChanged: _filterChapters, // Appel de la fonction de filtrage
          style: TextStyle(
            fontFamily: 'Amiri',
            fontSize: 16,
            color: isDark ? Colors.white : Colors.black,
          ),
          decoration: InputDecoration(
            hintText: 'ابحث عن باب الذكر...',
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
    );
  }

  Widget _buildResultIndicator() {
    return Padding(
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
              "${filteredChapters.length} نتيجة",
              style: const TextStyle(
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
              _filterChapters('');
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
              child: const Row(
                children: [
                  Text(
                    "مسح البحث",
                    style: TextStyle(
                      fontFamily: 'Amiri',
                      fontSize: 12,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 4),
                  Icon(Icons.close, size: 14, color: Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 200.ms);
  }

  Widget _buildEmptyState() {
    return Center(
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
                ? "لا توجد أبواب متاحة"
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
                _filterChapters('');
              },
              child: const Text(
                "عرض جميع الأبواب",
                style: TextStyle(
                  fontFamily: 'Amiri',
                ),
              ),
            ),
        ],
      ),
    );
  }

  // --- Widget de construction de carte de chapitre (similaire à votre code original) ---

  Widget _buildChapterCard(AdhkarModel chapter) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      elevation: 3,
      child: ListTile(
        leading: Container(
          width: 30,
          height: 30,
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
              '${chapter.id}',
              style: const TextStyle(
                color: AppColors.primaryDark,
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Amiri',
              ),
            ),
          ),
        ),
        title: Text(
          chapter.title,
          textAlign: TextAlign.right,
          style: const TextStyle(fontFamily: 'Amiri', fontSize: 18),
        ),
        subtitle: Text(
          '${chapter.items.length} ${chapter.items.length > 1 ? 'أذكار' : 'ذكر'}',
          textAlign: TextAlign.right,
          style: const TextStyle(fontFamily: 'Amiri', fontSize: 14, color: Colors.grey),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.primaryDark),
        onTap: () {
          // NAVIGATION : Envoyer l'ID du chapitre sélectionné à l'écran de détail
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AdhkarDetailScreen(chapterId: chapter.id),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.primaryDark,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textLight),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          '📜 أبواب الأذكار',
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
                _filterChapters(''); // Réinitialiser la liste
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Barre de recherche
          if (_showSearchBar)
            _buildSearchBar(isDark)
                .animate(delay: 50.ms)
                .fade(duration: 200.ms)
                .slideY(
              begin: -0.5,
              end: 0.0,
              curve: Curves.easeOut,
            ),

          // Indicateur de résultats
          if (_showSearchBar && _searchController.text.isNotEmpty)
            _buildResultIndicator(),

          const SizedBox(height: 8),

          // Liste des chapitres filtrés
          Expanded(
            child: filteredChapters.isEmpty && _searchController.text.isNotEmpty
                ? _buildEmptyState()
                : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: filteredChapters.length,
              itemBuilder: (context, index) {
                final chapter = filteredChapters[index];
                return _buildChapterCard(chapter);
              },
            ),
          ),
        ],
      ),
    );
  }
}