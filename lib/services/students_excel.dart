// import 'package:flutter/services.dart' show ByteData, rootBundle;
import 'dart:convert';

import 'package:excel/excel.dart';
import 'package:quran_tester/enums/afif_tests_names_enum.dart';
import 'package:quran_tester/models/afif_test.dart';
import 'dart:io';


// class StudentExcel{
//   static getStudentsFromExcel() async {
//     ByteData data = await rootBundle.load('assets/OLdStudents.xlsx');
//     var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//     var excel = Excel.decodeBytes(bytes);
//
//     Sheet sheet = excel[excel.getDefaultSheet()!];
//
//     int currentRow = 2;
//     while(true){
//       String? name = sheet.cell(CellIndex.indexByColumnRow(rowIndex: currentRow, columnIndex: 1)).value;
//       if(name == null) break;
//       List tests = [];
//       for(int t = 0; t < 6; t++){
//           int mark = int.parse(sheet.cell(CellIndex.indexByColumnRow(rowIndex: currentRow, columnIndex: 1 + t*3)).value);
//           if(mark == 0){
//             tests.add(AfifTest.notPassed(AfifTestsNames.values[t]));
//           }
//           tests.add(AfifTest.passed(AfifTestsNames.values[t], mark,
//             notes: getNotes(column: 1+ t*3 + 1, row: currentRow),
//             date: DateTime.parse(sheet.cell(CellIndex.indexByColumnRow(rowIndex: currentRow, columnIndex: 1 + t*3)).value)
//           ));
//       }
//     }
//   }
//
//   static List<String> getNotes({required int column, required int row}) {
//   ByteData data = await rootBundle.load('assets/OLdStudents.xlsx');
//   var bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
//   var excel = Excel.decodeBytes(bytes);
//
//   Sheet sheet = excel[excel.getDefaultSheet()!];
//   String notes = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1)).value.toString();
//   List notesList = const LineSplitter().convert(notes);
//   print(notesList);
//   }
// }

// testing
// Future<void> main() async {
//   File file = File("D:/MINE/RlProjects/Quran Tester/Afif/quran_tester/assets/OLdStudents.xlsx");
//   var excel = Excel.decodeBytes(file.readAsBytesSync());
//
//   Sheet sheet = excel[excel.getDefaultSheet()!];
//
//   String date = sheet.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: 1)).value.toString();
//   List notesList = const LineSplitter().convert(notes);
//   print(date);
// }