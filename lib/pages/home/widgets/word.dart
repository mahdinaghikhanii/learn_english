import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:learn_english/common/extensions/strings.dart';
import 'package:learn_english/model/dayli_word.dart';

class WordOfTheDay extends StatefulWidget {
  const WordOfTheDay({super.key});

  @override
  State<WordOfTheDay> createState() => _WordOfTheDayState();
}

class _WordOfTheDayState extends State<WordOfTheDay> {
  final String _apiUrl = 'https://api.dictionaryapi.dev/api/v2/entries/en';
  final String randomWordUrl = 'https://api.api-ninjas.com/v1/randomword';

  late Future<DailyWord> _getDailyWord;

  Future<String> generateRandomWord() async {
    try {
      final response =
          await Dio().get(randomWordUrl, options: Options(headers: {}));
      if (response.statusCode == 200) {
        return response.data['word'];
      }
      return "serious";
    } catch (e) {
      return "serious";
    }
  }

  Future<DailyWord> getDailyWord() async {
    try {
      final word = await generateRandomWord();
      print(word);
      final response = await Dio().get('$_apiUrl/$word');
      if (response.statusCode == 200) {
        Map<String, dynamic> data = response.data[0];
        List<Meaning> meanings = [];

        // WE WILL LOOP THROUGH THE MEANINGS AND DEFINITIONS
        for (var meaning in data['meanings']) {
          List<Definition> definitions = [];
          for (var definition in meaning['definitions']) {
            // WE WILL ADD THE DEFINITIONS TO THE LIST OF DEFINITIONS
            definitions.add(
              Definition(
                definition: definition['definition'],
                synonyms: definition['synonyms'],
                example: definition['example'],
              ),
            );
          }

          // WE WILL ADD THE MEANINGS TO THE LIST OF MEANINGS
          meanings.add(Meaning(
              partOfSpeech: meaning['partOfSpeech'], definitions: definitions));
        }
        List phonetics = data['phonetics'];
        String audio =
            phonetics.firstWhere((element) => element['audio'] != '')['audio'];
        final dailyWord = DailyWord(
          word: data['word'],
          phonetic: data['phonetic'],
          meanings: meanings,
          audio: audio,
        );
        return dailyWord;
      } else {
        // call the function with a random word if the word is not found
        return await getDailyWord();
      }
    } catch (e) {
      return await getDailyWord();
    }
  }

  final player = AudioPlayer();

  bool isPlaying = false;

  Future<void> playAudio(String url) async {
    try {
      await player.setUrl(url);
      await player.play();
      setState(() {
        isPlaying = true;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> stopAudio() async {
    try {
      await player.stop();
      setState(() {
        isPlaying = false;
      });
    } catch (e) {
      print(e);
    }
  }

  void playOrStop(String url) {
    stopAudio();
    playAudio(url);
  }

  @override
  void initState() {
    super.initState();
    _getDailyWord = getDailyWord();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.black45,
      elevation: 0.4,
      color: Colors.orange.shade200,
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: FutureBuilder(
          future: _getDailyWord,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Padding(
                padding: EdgeInsets.all(15),
                child: Center(
                  child: CircularProgressIndicator.adaptive(),
                ),
              );
            }
            if (snapshot.hasError) {
              return const Padding(
                padding: EdgeInsets.all(15),
                child: Center(
                  child: Text(
                      "We are sorry, we couldn't get the word of the day."),
                ),
              );
            }
            final DailyWord dailyWord = snapshot.data as DailyWord;
            List<String?> examples = dailyWord.meanings
                .map((meaning) => meaning.definitions
                    .map((definition) => definition.example)
                    .toList())
                .expand((element) => element)
                .where((element) => element != null && element != '')
                .toList();

            List<String?> previewExamples = examples;
            if (examples.length > 3) {
              previewExamples = examples.sublist(0, 3);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              dailyWord.word.capitalize(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              dailyWord.phonetic,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    color: Colors.black38,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      IconButton.filledTonal(
                          onPressed: () {
                            playOrStop(dailyWord.audio);
                          },
                          style: IconButton.styleFrom(
                              backgroundColor: Colors.white),
                          icon: const Icon(Icons.volume_up))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    dailyWord.meanings.first.definitions.first.definition,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    "Examples:",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                ...List.generate(previewExamples.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(
                      previewExamples[index] ?? "Nothing here",
                    ),
                  );
                }),
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      icon: const Icon(
                        CupertinoIcons.book,
                        size: 16,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          showDragHandle: true,
                          context: context,
                          isScrollControlled: true,
                          builder: (context) {
                            return SizedBox(
                              height: 420,
                              width: double.infinity,
                              child: SingleChildScrollView(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 20),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  dailyWord.word.capitalize(),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                                Text(
                                                  dailyWord.phonetic,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleMedium
                                                      ?.copyWith(
                                                        color: Colors.black38,
                                                      ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton.filledTonal(
                                            onPressed: () {
                                              playOrStop(dailyWord.audio);
                                            },
                                            icon: const Icon(Icons.volume_up),
                                          )
                                        ],
                                      ),
                                    ),
                                    ...List.generate(dailyWord.meanings.length,
                                        (index) {
                                      final meaning = dailyWord.meanings[index];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              meaning.partOfSpeech.capitalize(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                            const SizedBox(height: 10),
                                            ...List.generate(
                                                meaning.definitions.length,
                                                (index) {
                                              final definition =
                                                  meaning.definitions[index];
                                              return Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      definition.definition,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .titleMedium,
                                                    ),
                                                    const SizedBox(height: 10),
                                                    if (definition
                                                        .synonyms.isNotEmpty)
                                                      Text(
                                                        "Synonyms: ${definition.synonyms.join(', ')}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                              color: Colors
                                                                  .black45,
                                                            ),
                                                      ),
                                                    const SizedBox(height: 10),
                                                    if (definition.example !=
                                                            null &&
                                                        definition.example !=
                                                            '')
                                                      Text(
                                                        "Example: ${definition.example}",
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .titleMedium
                                                            ?.copyWith(
                                                              color: Colors
                                                                  .black38,
                                                            ),
                                                      ),
                                                  ],
                                                ),
                                              );
                                            }),
                                          ],
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      label: const Text(
                        "Learn more",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
