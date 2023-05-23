import 'dart:math';
import 'package:flutter/services.dart' show ByteData, rootBundle;


import 'package:excel/excel.dart';
import 'package:quran/quran_text.dart';

class Bank{
  //[30][3][5]  [juz][diff][question]
  static bool _isInit = false;
  static get isInit => _isInit;
  static List<List<List<int>>> bank  = List.generate(30, (index) => [[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]]);
  static initialize() async {
    // var dir = await getExternalStorageDirectory();
    // var file = 'dir/bank.xlsx';
    // var bytes = File(file).readAsBytesSync();
    // var excel = Excel.decodeBytes(bytes);

    ByteData data = await rootBundle.load('assets/bank.xlsx');
    var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    var excel = Excel.decodeBytes(bytes);

    Sheet sheet = excel[excel.getDefaultSheet()!];
    for (int row = 0;row < 30; row++) {
      for(int i = 0;i<3;i++){
        for(int j=0;j < 5;j++){
          SharedString? value = sheet.cell(CellIndex.indexByColumnRow(rowIndex: row, columnIndex: i*5 + j)).value;
          if(value == null) continue;
          int surah = int.parse(value.toString().substring(0,value.toString().indexOf(',')));
          int verse = int.parse(value.toString().substring(value.toString().indexOf(',')+1, value.toString().length));
          int verseNumber = convertSurahVerseToVerse(surah, verse);
          bank[row][i][j] = verseNumber;
        }
      }
    }
    _isInit = true;
    return bank;
  }

  static int convertSurahVerseToVerse(int surah, int verse){
    int verseNumber = quranText.indexWhere((element) => element["surah_number"] == surah && element["verse_number"] == verse);
    return verseNumber;
  }

  static randomQuestions(int start, int end,int noQ){
    List questions = [];
    // List juzs = [];

    // List quePerDiff = (noQ == 5)? [2,2,1]: [2,1,1];
    // for(int d = 0; d<3; d++) {
    //   for (int i = 0; i < quePerDiff[d]; i++) {
    //     int juz = Random().nextInt(end - start) + start;
    //     if(juzs.contains(juz)) {
    //       i--;
    //       continue;
    //     }
    //     juzs.add(juz);
    //     int q = Random().nextInt(quePerDiff[d]);
    //     int verse = bank[juz][d][q];
    //
    //     questions.add(verse);
    //   }
    // }
    int q;
    do{
      int juz = Random().nextInt(end - start) + start;
      q = questionFromDiffJuz(0, juz);
    }while(questions.contains(q));
    questions.add(q);
    do{
      int juz = Random().nextInt(end - start) + start;
      q = questionFromDiffJuz(2, juz);
    }while(questions.contains(q));
    questions.add(q);
    do{
      int juz = Random().nextInt(end - start) + start;
      q = questionFromDiffJuz(1, juz);
    }while(questions.contains(q));
    questions.add(q);
    do{
      int juz = Random().nextInt(end - start) + start;
      q = questionFromDiffJuz(0, juz);
    }while(questions.contains(q));
    questions.add(q);
    if(noQ == 5){
      do{
        int juz = Random().nextInt(end - start) + start;
        q = questionFromDiffJuz(1, juz);
      }while(questions.contains(q));
      questions.add(q);
    }
    return questions;
  }

  static int questionFromDiffJuz(int diff, int juz){
    int q = 0;
    while(q==0){
      int r = Random().nextInt(5);
      q = bank[juz][diff][r];
    }
    return q;
  }
}
