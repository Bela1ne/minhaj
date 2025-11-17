class Surah {
  final int id;
  final String name;
  final String frenchName;
  final String arabicName;
  final int verseCount;
  final String revelationType;
  final int pageNumber; // NON NULLABLE !!!!!

  Surah({
    required this.id,
    required this.name,
    required this.frenchName,
    required this.arabicName,
    required this.verseCount,
    required this.revelationType,
    required this.pageNumber,
  });
}
