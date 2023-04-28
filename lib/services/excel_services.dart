import 'dart:io';

import 'package:syncfusion_flutter_xlsio/xlsio.dart';
import 'package:open_file_plus/open_file_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quran/surah_data.dart';

class ExcelServices {
  final String name;
  final List<List<int>> faults;
  final List questions;
  final List notes;
  final List juzs;
  final int mark;
  File file = File('');
  String? juzsString;

  ExcelServices(
      {required this.faults,
        required this.notes,
        required this.juzs,
        required this.mark,
        required this.questions,
        required this.name}) {
    juzsString = (juzs[0] == juzs[1])? 'الجزء ${juzs[0]}':'من ${juzs[0]} الى ${juzs[1]}';
    excel = Workbook();
    excelStyle = this;
  }

  static ExcelServices? excelStyle;
  static Workbook excel = Workbook();

  makeExcel() {
    Worksheet sheet = excel.worksheets[0];
    sheet.isRightToLeft = true;

    Style globalStyle = excel.styles.add('style1');
    globalStyle.borders.all.lineStyle = LineStyle.thin;
    globalStyle.hAlign = HAlignType.center;
    Style crossedStyle = excel.styles.add('style2');
    crossedStyle.borders.all.lineStyle = LineStyle.thin;
    crossedStyle.hAlign = HAlignType.center;

    // CellStyle cellStyle = CellStyle(
    //   fontFamily: getFontFamily(FontFamily.Calibri),
    //   topBorder: Border(borderStyle: BorderStyle.Medium),
    //   leftBorder: Border(borderStyle: BorderStyle.Medium),
    //   rightBorder: Border(borderStyle: BorderStyle.Medium),
    //   bottomBorder: Border(borderStyle: BorderStyle.Medium),
    //   horizontalAlign: HorizontalAlign.Center
    // );
    // int rowsCount = (questions.length < 5)? 12: questions.length + notes.length +2;
    // for(int i = 0;i < rowsCount; i++){
    //   for(int j = 0; j<8; j++){
    //       if (j == 0 && i>0) {
    //         sheet.updateCell(
    //             CellIndex.indexByColumnRow(rowIndex: i, columnIndex: j), '',
    //             cellStyle: CellStyle(
    //                 bold: true,
    //                 fontColorHex: '00FF00',
    //                 fontFamily: getFontFamily(FontFamily.Calibri),
    //                 topBorder: Border(borderStyle: BorderStyle.Medium),
    //                 leftBorder: Border(borderStyle: BorderStyle.Medium),
    //                 rightBorder: Border(borderStyle: BorderStyle.Medium),
    //                 bottomBorder: Border(borderStyle: BorderStyle.Medium),
    //                 horizontalAlign: HorizontalAlign.Center
    //             ));
    //       }
    //       else if (j == 6 && i>0) {
    //         sheet.updateCell(
    //             CellIndex.indexByColumnRow(rowIndex: i, columnIndex: j), '',
    //             cellStyle: CellStyle(
    //                 bold: true,
    //                 fontColorHex: 'FF0000',
    //                 fontFamily: getFontFamily(FontFamily.Calibri),
    //                 topBorder: Border(borderStyle: BorderStyle.Medium),
    //                 leftBorder: Border(borderStyle: BorderStyle.Medium),
    //                 rightBorder: Border(borderStyle: BorderStyle.Medium),
    //                 bottomBorder: Border(borderStyle: BorderStyle.Medium),
    //                 horizontalAlign: HorizontalAlign.Center
    //             ));
    //       }
    //     else {
    //       sheet.updateCell(CellIndex.indexByColumnRow(rowIndex: i,columnIndex: j), '', cellStyle: cellStyle);
    //       }
    //   }
    // }

    int rowsCount = (questions.length < 5)? 12: questions.length + notes.length +2;
    rowsCount++;
    sheet.getRangeByName('A1:H$rowsCount').cellStyle = globalStyle;
    sheet.getRangeByName('A2:A${(questions.length<5)? 7: questions.length+2}').cellStyle.fontColor = "#00BB00";




    sheet.setColumnWidthInPixels(1, 130);
    sheet.setColumnWidthInPixels(8, 100);

    for(int j = 2; j<8; j++) {
      sheet.setColumnWidthInPixels(j, 60);
    }

    //header Row
    List headerRow = [
      'الاسم: $name',
      'تلكؤ عام',
      'ردة الحفظ',
      'تلكؤ التشكيل',
      'خطأ التشكيل',
      'خطأ التجويد',
      'المجموع',
      'المقطع المستمع إليه'
    ];
    sheet.importList(headerRow, 1,1,false);
    int currentRow = 2;

    //questions Rows
    List quetionNumber = [
      "الأول",
      "الثاني",
      "الثالث",
      "الرابع",
      "الخامس",
      "السادس",
      "السابع",
      "الثامن",
      "التاسع",
      "العاشر"
    ];
    List<int> Marks = List.generate((questions.length < 5)? 5: questions.length, (index) {
      if(index>questions.length-1) return 20;
      return 20 - faults[index][0] - faults[index][1] * 4 - faults[index][2] * 3 - faults[index][3] * 10 - faults[index][4];
    });
    List<List> questionsRows = List.generate(
        (questions.length < 5)? 5: questions.length,
            (index) {
          if(index>questions.length-1) return ['السؤال ${quetionNumber[index]}','','','','','','20',''];
          return [
            'السؤال ${quetionNumber[index]}',
            '${faults[index][0]}',
            '${faults[index][1]}',
            '${faults[index][2]}',
            '${faults[index][3]}',
            '${faults[index][4]}',
            '${Marks[index]}',
            '${surah[questions[index]['surah_number'] - 1]['arabic']} ${questions[index]['verse_number']}',
          ];
        });
    for (var i in questionsRows) {
      sheet.importList(i, currentRow,1,false);
      sheet.getRangeByName('G$currentRow').cellStyle.fontColor = (Marks[questionsRows.indexOf(i)] >15)? "#009900": "#BB0000";
      currentRow++;
    }

    //Sum Row
    List faultsSum = [0, 0, 0, 0, 0];
    for (var i in faultsSum) {
      faults.map((e) => faultsSum[0] += e[0]);
    }
    List sumRow = [
      'المجموع',
      '${faultsSum[0]}',
      '${faultsSum[1]}',
      '${faultsSum[2]}',
      '${faultsSum[3]}',
      '${faultsSum[4]}',
      '$mark',
    ];
    sheet.importList(sumRow, currentRow, 1, false);
    sheet.getRangeByName('G$currentRow').cellStyle.fontColor = (mark >85)? "#009900": "#BB0000";


    crossedStyle.backColor = '#AAAAAA';

    sheet.getRangeByName('H$currentRow').cellStyle = crossedStyle;


    currentRow++;
    //second header
    Range mergeRange = sheet.getRangeByName('A$currentRow:D$currentRow');
    mergeRange.merge();
    mergeRange.setText('الملاحظات');
    mergeRange.cellStyle = globalStyle;

    mergeRange = sheet.getRangeByName('E$currentRow:F$currentRow');
    mergeRange.merge();
    mergeRange.setText('التاريخ');
    mergeRange.cellStyle = globalStyle;

    mergeRange = sheet.getRangeByName('G$currentRow:H$currentRow');
    mergeRange.merge();
    mergeRange.setText('الأجزاء المحفوظة');
    mergeRange.cellStyle = globalStyle;
    currentRow++;

    // //date juzs
    mergeRange = sheet.getRangeByName('E$currentRow:F$currentRow');
    mergeRange.merge();
    mergeRange.setText("${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}");
    mergeRange.cellStyle = globalStyle;

    mergeRange = sheet.getRangeByName('G$currentRow:H$currentRow');
    mergeRange.merge();
    mergeRange.setText(juzsString);
    mergeRange.cellStyle = globalStyle;

    int notesLength = (notes.length < 5)? 5: notes.length;
    mergeRange = sheet.getRangeByName('E${currentRow+1}:H${currentRow + notesLength - 1}');
    mergeRange.merge();
    mergeRange.cellStyle = crossedStyle;

    // //notes
    for (var i in notes) {
      mergeRange = sheet.getRangeByName('A$currentRow:D$currentRow');
      mergeRange.merge();
      mergeRange.cellStyle = globalStyle;
      mergeRange.setText(i);
      currentRow++;
    }
    if(notes.length<5){
      for(int i =0;i< 5-notes.length; i++){
        mergeRange = sheet.getRangeByName('A$currentRow:D$currentRow');
        mergeRange.merge();
        mergeRange.cellStyle = globalStyle;
        currentRow++;
      }
    }
  }

  Future<bool> saveExcel() async {
    var fileBytes = excel.save();
    var directory = (await getApplicationDocumentsDirectory()).path;

    file = File('$directory/outputFile.xlsx')
      ..create(recursive: true)
      ..writeAsBytes(await fileBytes);
    return true;
  }

  openExcel() async {
    var directory = (await getExternalStorageDirectory())?.path;
    // File newFile = File('$directory/output2.xlsx');
    File newFile = File('$directory/سبر$name, $juzsString.xlsx');
    file.copy(newFile.path);

    var s = await OpenFile.open(newFile.path);
  }
}