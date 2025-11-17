// lib/ui/widgets/widget_selector_dialog.dart
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class WidgetSelectorDialog extends StatefulWidget {
  final List<String> availableWidgets;
  final List<String> selectedWidgets;
  final Function(List<String>) onWidgetsUpdated;

  const WidgetSelectorDialog({
    super.key,
    required this.availableWidgets,
    required this.selectedWidgets,
    required this.onWidgetsUpdated,
  });

  @override
  State<WidgetSelectorDialog> createState() => _WidgetSelectorDialogState();
}

class _WidgetSelectorDialogState extends State<WidgetSelectorDialog> {
  late List<String> _tempSelectedWidgets;

  @override
  void initState() {
    super.initState();
    _tempSelectedWidgets = List.from(widget.selectedWidgets);
  }

  void _toggleWidget(String widgetName) {
    setState(() {
      if (_tempSelectedWidgets.contains(widgetName)) {
        _tempSelectedWidgets.remove(widgetName);
      } else {
        _tempSelectedWidgets.add(widgetName);
      }
    });
  }

  void _saveSelection() {
    widget.onWidgetsUpdated(_tempSelectedWidgets);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.primaryDark,
      title: const Text(
        'تخصيص الصفحة الرئيسية',
        style: TextStyle(
          color: Colors.white,
          fontFamily: 'Amiri',
          fontSize: 18,
        ),
        textAlign: TextAlign.center,
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView(
          shrinkWrap: true,
          children: [
            const Text(
              'اختر العناصر التي تريد عرضها:',
              style: TextStyle(
                color: Colors.white70,
                fontFamily: 'Amiri',
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            ...widget.availableWidgets.map((widgetName) {
              final isSelected = _tempSelectedWidgets.contains(widgetName);
              return Card(
                color: AppColors.primaryDark.withOpacity(0.8),
                child: CheckboxListTile(
                  title: Text(
                    _getWidgetDisplayName(widgetName),
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Amiri',
                      fontSize: 14,
                    ),
                  ),
                  value: isSelected,
                  onChanged: (value) => _toggleWidget(widgetName),
                  activeColor: Colors.teal,
                  checkColor: Colors.white,
                ),
              );
            }).toList(),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text(
            'إلغاء',
            style: TextStyle(
              color: Colors.white70,
              fontFamily: 'Amiri',
            ),
          ),
        ),
        ElevatedButton(
          onPressed: _saveSelection,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
          ),
          child: const Text(
            'حفظ',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Amiri',
            ),
          ),
        ),
      ],
    );
  }

  String _getWidgetDisplayName(String widgetName) {
    switch (widgetName) {
      case 'date':
        return 'التاريخ الهجري والميلادي';
      case 'prayer_times':
        return 'أوقات الصلاة';
      case 'adhkar':
        return 'الأذكار اليومية';
      case 'qibla':
        return 'اتجاه القبلة';
      case 'quran_verse':
        return 'آية اليوم';
      case 'hadith':
        return 'حديث اليوم';
      default:
        return widgetName;
    }
  }
}