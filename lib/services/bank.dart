import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show ByteData, rootBundle;


import 'package:excel/excel.dart';
import 'package:quran/quran_text.dart';

class Bank{
  //[30][5][3]
  static List<List<List<int>>> bank  = List.generate(30, (index) => [[0,0,0],[0,0,0],[0,0,0],[0,0,0],[0,0,0]]);
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
  }

  static int convertSurahVerseToVerse(int surah, int verse){
    int verseNumber = quranText.indexWhere((element) => element["surah_number"] == surah && element["verse_number"] == verse);
    return verseNumber;
  }
}

