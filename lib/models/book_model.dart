class Book {
  final String id;
  final String title;
  final String description;
  final String cover;
  final String filePath;
  final int totalPages;
  final String author;
  final String category;

  // Nouveaux champs pour la progression réelle
  final int lastReadPage;
  final DateTime? lastReadDate;
  final bool isReading;

  const Book({
    required this.id,
    required this.title,
    required this.description,
    required this.cover,
    required this.filePath,
    required this.totalPages,
    required this.author,
    required this.category,
    this.lastReadPage = 0,
    this.lastReadDate,
    this.isReading = false,
  });

  // Getter pour calculer la progression réelle
  double get readingProgress {
    if (totalPages == 0) return 0.0;
    return lastReadPage / totalPages;
  }

  // Getter pour le texte de progression
  String get progressText {
    if (lastReadPage == 0) return 'لم تبدأ القراءة';
    if (lastReadPage >= totalPages) return 'مكتمل ✅';
    return '${(readingProgress * 100).toStringAsFixed(1)}%';
  }

  // Getter pour les pages actuelles
  String get pagesText => '$lastReadPage/$totalPages';

  Book copyWith({
    String? id,
    String? title,
    String? description,
    String? cover,
    String? filePath,
    int? totalPages,
    String? author,
    String? category,
    int? lastReadPage,
    DateTime? lastReadDate,
    bool? isReading,
  }) {
    return Book(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      cover: cover ?? this.cover,
      filePath: filePath ?? this.filePath,
      totalPages: totalPages ?? this.totalPages,
      author: author ?? this.author,
      category: category ?? this.category,
      lastReadPage: lastReadPage ?? this.lastReadPage,
      lastReadDate: lastReadDate ?? this.lastReadDate,
      isReading: isReading ?? this.isReading,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'cover': cover,
      'filePath': filePath,
      'totalPages': totalPages,
      'author': author,
      'category': category,
      'lastReadPage': lastReadPage,
      'lastReadDate': lastReadDate?.millisecondsSinceEpoch,
      'isReading': isReading,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      cover: map['cover'] ?? '',
      filePath: map['filePath'] ?? '',
      totalPages: map['totalPages'] ?? 0,
      author: map['author'] ?? '',
      category: map['category'] ?? '',
      lastReadPage: map['lastReadPage'] ?? 0,
      lastReadDate: map['lastReadDate'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['lastReadDate'])
          : null,
      isReading: map['isReading'] ?? false,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Book && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}