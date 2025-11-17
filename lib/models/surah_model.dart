class Surah {
  final int id;
  final String name;
  final String frenchName;
  final String arabicName;
  final int verseCount;
  final String revelationType;
  final int pageNumber; // NON NULL !!

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

class Verse {
  final int id;
  final int surahId;
  final int verseNumber;
  final String arabicText;

  Verse({
    required this.id,
    required this.surahId,
    required this.verseNumber,
    required this.arabicText,
  });
}
