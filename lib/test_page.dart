import 'dart:io';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:quran/juz_data.dart';
import 'package:quran/quran.dart';
import 'package:quran/quran_text.dart';
import 'package:quran_tester/mushaf_details.dart';

class TestPage extends StatefulWidget {
  const TestPage({Key? key, required this.start, required this.end})
      : super(key: key);
  final int start;
  final int end;

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final assetsAudioPlayer = AssetsAudioPlayer();

  // final List<int> juzStartSurah = MushafDetails().juzStartSurah;
  //
  // final List<int> juzStartAyah = MushafDetails().juzStartAyah;
  //
  // final List<int> juzEndSurah = MushafDetails().juzEndSurah;
  //
  // final List<int> juzEndAyah = MushafDetails().juzEndAyah;
  //
  // final List<int> surahAyahs = MushafDetails().surahAyahs;
  // int surah = 1;
  // int ayah = 1;

  final List<int> juzStartVerse = MushafDetails().juzStartVerse;
  int verse = 1;

  bool isQuestionOn = false;
  bool isPaused = true;
  bool isSoundOn = true;
  bool isInternet = true;
  int questionNumber = 0;

  String currentAyah = 'هنا ستعرض الآية';
  String ayahAudio = '';

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        assetsAudioPlayer.stop();
        if (!assetsAudioPlayer.isPlaying.value) {
          return true;
        }
        return false;
      },
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("قاعة السبر"),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
                assetsAudioPlayer.stop();
              },
            ),
            actions: [
              IconButton(
                  onPressed: () => setState(() => isSoundOn = !isSoundOn),
                  icon: Icon((!isSoundOn ? Icons.volume_off : Icons.volume_up)),
                  color:
                      (
                          isSoundOn ? Colors.white : Colors.red.withOpacity(0.7)))
            ],
          ),
          body: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'سبر الاجزاء من الجزء ${widget.start} الى الجزء ${widget.end}',
                style: const TextStyle(fontSize: 20, color: Colors.brown),
              ),
              const SizedBox(
                height: 40,
              ),
              SizedBox(
                height: 45,
                // width: ,
                child: Center(
                  child: ElevatedButton(
                      onPressed: () => newQuestion(widget.start, widget.end),
                      child: const Text(
                        'سؤال جديد',
                        style: TextStyle(fontSize: 17),
                      )),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 45,
                child: Center(
                  child: Visibility(
                    visible: isQuestionOn,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Ink(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            // color: Colors.green
                          ),
                          child: InkWell(
                            onTap: nextAyah,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            // overlayColor: MaterialStatePropertyAll(Colors.red),
                            splashColor: Colors.green,
                            // radius: 50,
                            child: const Center(
                              child: Icon(
                                Icons.skip_next_rounded,
                                size: 45,
                                color: Colors.brown,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Ink(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            // color: Colors.red
                          ),
                          child: InkWell(
                            onTap: stopAudio,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            // overlayColor: MaterialStatePropertyAll(Colors.red),
                            splashColor: Colors.red,
                            // radius: 50,
                            child: const Center(
                              child: Icon(
                                Icons.stop,
                                size: 45,
                                color: Colors.brown,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Ink(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            // color: Colors.red
                          ),
                          child: InkWell(
                            onTap: pauseAndResume,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(25)),
                            // overlayColor: MaterialStatePropertyAll(Colors.red),
                            splashColor: Colors.yellow,
                            // radius: 50,
                            child: Center(
                              child: Icon(
                                (!isPaused) ? Icons.pause : Icons.play_arrow,
                                size: 45,
                                color: Colors.brown,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Center(
                child: SizedBox(
                  height: 150,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      maxLines: 2,
                      enabled: false,
                      decoration: InputDecoration(
                          hintText: currentAyah,
                          hintStyle: const TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontWeight: FontWeight.bold),
                          border: InputBorder.none),
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }

  newQuestion(int juzStart, int juzEnd) async {
    questionNumber++;
    isPaused = true;
    if (isSoundOn) {
      try {
        final result = await InternetAddress.lookup('example.com');
        if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
          isInternet = true;
        }
      } on SocketException catch (_) {
        isInternet = false;
        Fluttertoast.showToast(
            msg: "لا يمكن تشغيل الصوت لعدم وجود انترنيت",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.grey,
            textColor: Colors.white,
            fontSize: 14.0);
      }
    }

    //text
    // final int surahStart = juzStartSurah[juzStart - 1];
    // final ayahStart = juzStartAyah[juzStart - 1];
    // final int surahEnd = juzEndSurah[juzEnd - 1];
    // final int ayahEnd = juzEndAyah[juzEnd - 1];
    //
    // surah = Random().nextInt(surahEnd - surahStart) + surahStart;
    // ayah = (surah == surahStart)
    //     ? Random().nextInt(surahAyahs[surah - 1] - ayahStart) + ayahStart
    //     : (surah == surahEnd)
    //         ? Random().nextInt(ayahEnd) + 1
    //         : Random().nextInt(surahAyahs[surah - 1]) + 1;

    //audio
    int endVerse = (juzEnd == 30) ? totalVerseCount : juzStartVerse[juzEnd] - 1;
    verse = Random().nextInt(endVerse - juzStartVerse[juzStart - 1]) +
        juzStartVerse[juzStart - 1];
    currentAyah = quranText[verse - 1]['content'];
    ayahAudio = getAudioURLByVerseNumber(verse); //getAudioURLByVerse(surah, ayah);
    setState(() => isQuestionOn = true);

    if (isInternet && isSoundOn) {
      try {
        await assetsAudioPlayer.open(
          Audio.network(ayahAudio),
        );
        assetsAudioPlayer.pause();
      } catch (t) {
        //
      }
    }
  }

  stopAudio() {
    assetsAudioPlayer.stop();
    setState(() {
      isQuestionOn = false;
      currentAyah = '';
    });
  }

  pauseAndResume() async {
    // int currentQuestion = questionNumber;
    if (!(isInternet && isSoundOn)) return;
    setState(() {
      isPaused = !isPaused;
    });
    // await assetsAudioPlayer.playOrPause();
    if(!isPaused) assetsAudioPlayer.play();
    else assetsAudioPlayer.pause();
    // if(questionNumber != currentQuestion) assetsAudioPlayer.stop();
  }

  nextAyah() async {
    // //text
    // if (ayah == surahAyahs[surah - 1]) {
    //   if (surah == 114) surah = 0;
    //   surah++;
    //   ayah = 0;
    // }

    //audio
    if (verse == totalVerseCount) verse = 0;
    String ayahAudio =
        getAudioURLByVerseNumber(++verse); //getAudioURLByVerse(surah, ++ayah);
    currentAyah = quranText[verse - 1]['content'];
    setState(() => isPaused = true);

    if (isInternet && isSoundOn) {
      try {
        await assetsAudioPlayer.open(
          Audio.network(ayahAudio),
        );
        assetsAudioPlayer.pause();
      } catch (t) {
        //TODO
      }
    }
  }
}
