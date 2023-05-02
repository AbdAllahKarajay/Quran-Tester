import 'dart:io';
import 'dart:math';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;


import 'package:excel/excel.dart';
import 'package:quran/quran_text.dart';

class Bank{
  //[30][3][5]  [juz][diff][question]
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
    return bank;
  }

  static int convertSurahVerseToVerse(int surah, int verse){
    int verseNumber = quranText.indexWhere((element) => element["surah_number"] == surah && element["verse_number"] == verse);
    return verseNumber;
  }

  static randomQuestions(int start, int end,int noQ){
    List juzs = [];
    List questions = [];

    List questionsOrder = [0,2,1,0];
    if(noQ == 5) questionsOrder.add(1);

    for(var o in questionsOrder){
      int juz = Random().nextInt(end - start) + start;
      if(juzs.contains(juz)) continue;
      juzs.add(juz);
      int verse = 0;
      while(verse == 0){
        int q = Random().nextInt(5);
        verse = bank[juz][o][q];
      }
      questions.add(verse);
    }
    return questions;
  }
}
