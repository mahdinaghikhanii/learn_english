class DailyWord {
  final String word;
  final String phonetic;
  final String audio;
  final List<Meaning> meanings;

  const DailyWord({
    required this.word,
    required this.phonetic,
    required this.meanings,
    required this.audio,
  });
}

class Meaning {
  final List<Definition> definitions;
  final String partOfSpeech;

  const Meaning({
    required this.definitions,
    required this.partOfSpeech,
  });
}

class Definition {
  final String definition;
  final List<dynamic> synonyms;
  final String? example;

  const Definition({
    required this.definition,
    required this.synonyms,
    this.example,
  });
}
