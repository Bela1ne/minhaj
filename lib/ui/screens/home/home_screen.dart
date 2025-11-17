// lib/ui/screens/home/home_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
import 'controllers/home_controller.dart';
import 'builders/home_content_builder.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../core/constants/app_colors.dart';
// Les chemins locaux sont corrects
import 'controllers/home_controller.dart';
import 'builders/home_content_builder.dart';
import '../../widgets/widget_selector_dialog.dart';
import '../../widgets/custom_fab.dart';
import 'controllers/home_controller.dart';
import 'builders/home_content_builder.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // --- Méthodes de construction de l'interface ---

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppColors.primaryDark,
      // Bouton Menu (Trois barres)
      leading: Builder(builder: (context) => IconButton(
        icon: const Icon(Icons.menu, color: AppColors.textLight),
        onPressed: () => Scaffold.of(context).openDrawer(),
      )),
      // Titre de l'application
      title: const Text(
          'منهاج',
          style: TextStyle(
              color: AppColors.textLight,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiri'
          )
      ),
      centerTitle: true,
      // Bouton d'ajout (+) qui apparaît en mode édition
      actions: [
        Consumer<HomeController>(
          builder: (context, controller, child) {
            if (controller.isEditMode) {
              return IconButton(
                icon: const Icon(Icons.add, color: AppColors.textLight),
                onPressed: () => _openWidgetSelector(context, controller),
                tooltip: 'إضافة عناصر',
              );
            }
            return const SizedBox();
          },
        ),
      ],
    );
  }

  Widget _buildDrawer(BuildContext context) {
    // Le tiroir latéral contient la liste de navigation
    return Drawer(
      backgroundColor: AppColors.primaryDark,
      width: MediaQuery.of(context).size.width * 0.8,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // En-tête du Drawer
          DrawerHeader(
            decoration: const BoxDecoration(color: Colors.teal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // (Logo ou icône)
                Container(
                  width: 60, height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 3))],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/ic_launcher.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.white,
                        child: const Icon(Icons.mosque, size: 40, color: Colors.teal),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                // Nom de l'application
                const Text('تطبيق منهاج', style: TextStyle(color: Colors.white, fontSize: 20, fontFamily: 'Amiri', fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          // Liste des éléments de navigation
          ..._buildDrawerItems(),
        ],
      ),
    );
  }

  List<Widget> _buildDrawerItems() {
    // La liste des destinations de votre application
    final items = [
      {'icon': Icons.menu_book, 'title': 'القرآن', 'route': '/quran'},
      {'icon': Icons.access_time, 'title': 'أوقات الصلاة', 'route': '/prayers'},
      {'icon': Icons.explore, 'title': 'اتجاه القبلة', 'route': '/qibla'},
      {'icon': Icons.favorite, 'title': 'الأذكار', 'route': '/adhkar'},
      {'icon': Icons.brightness_low, 'title': 'المسبحة', 'route': '/tasbih'},
      {'icon': Icons.library_books, 'title': 'الكتب', 'route': '/books'},
      {'icon': Icons.person, 'title': 'الأنبياء', 'route': '/prophets'},
      {'icon': Icons.settings, 'title': 'الإعدادات', 'route': '/settings'},
    ];

    return items.map((item) => ListTile(
      leading: Icon(item['icon'] as IconData, color: Colors.white70),
      title: Text(item['title'] as String, style: const TextStyle(color: Colors.white, fontFamily: 'Amiri', fontSize: 16)),
      trailing: const Icon(Icons.arrow_left, color: Colors.white70),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, item['route'] as String);
      },
    )).toList();
  }

  void _openWidgetSelector(BuildContext context, HomeController controller) {
    showDialog(
      context: context,
      builder: (context) => WidgetSelectorDialog(
        availableWidgets: controller.availableWidgets,
        selectedWidgets: controller.selectedWidgets,
        onWidgetsUpdated: controller.updateSelectedWidgets,
      ),
    );
  }

  // --- Fonction Build principale ---

  @override
  Widget build(BuildContext context) {
    // Le ChangeNotifierProvider injecte l'état du HomeController dans l'arbre de widgets
    return ChangeNotifierProvider(
      create: (context) => HomeController(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: _buildDrawer(context),
        drawerEdgeDragWidth: 0,
        drawerEnableOpenDragGesture: false,

        // La barre d'application avec le bouton menu
        appBar: _buildAppBar(context),

        // Le corps de l'écran qui affiche les widgets dynamiques
        body: Consumer<HomeController>(
          builder: (context, controller, child) {
            // HomeContentBuilder construit la liste des widgets sélectionnables
            return HomeContentBuilder.buildContent(controller);
          },
        ),

        // Le bouton flottant qui active/désactive le mode édition
        floatingActionButton: Consumer<HomeController>(
          builder: (context, controller, child) {
            return CustomFAB(
              onEditPressed: controller.toggleEditMode,
              isEditMode: controller.isEditMode,
            );
          },
        ),
      ),
    );
  }
}