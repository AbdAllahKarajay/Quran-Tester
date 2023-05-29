import 'dart:convert';

import 'package:csv/csv.dart';
import 'package:quran_tester/models/afif_test.dart';
import 'package:quran_tester/models/constants/afif_tests_names.dart';
import 'dart:io';

import '../models/student.dart';

class StudentCsv {
  static List<Student> getStudents(File file) {
    List<Student> students = [];
    String csvDate = file.readAsStringSync();
    List<List> data = const CsvToListConverter().convert(csvDate);
    for (int i = 1; i < data.length; i++) {
      if (data[i][0].toString().isEmpty) continue;
      students.add(getStudentFromRow(data[i]));
    }
    return students;
  }

  static Student getStudentFromRow(List row) {
    String id = row[0].toString();
    String name = row[1];
    String shortName = row[2];
    List<List<AfifTest>> tests = [[], [], [], [], [], [], [], []];
    if (row[3].toString().isNotEmpty) {
      // جزء عم
      tests.first.add(AfifTest.passed(0,
          date: row[3] == "تم" ? "-" : row[3]));
    }
    for (int i = 1; i <= 6; i++) {
      tests[i].addAll(getAfifTest(row, i * 4));
    }
    if (row[29].toString().isNotEmpty) {
      tests.last.add(AfifTest.passed(7));
    }
    bool isFinished = row[28].toString().isNotEmpty;
    String finishDate = row[28] == "__" ? "-" : row[28];
    String mjeezName = row[30].toString().isEmpty ? "-" : row[30];

    return Student(name, id,
        shortName: shortName,
        tests: tests,
        mjeezName: mjeezName,
        isFinished: isFinished,
        finishDate: finishDate);
  }

  static List<AfifTest> getAfifTest(List row, int index) {
    List<AfifTest> currentTestList = [];
    List<String> oldNotes = [];
    String oldDate = "-";
    if (row[index].toString().isEmpty) {
      if (row[index + 1].toString().isEmpty) return [];
      oldNotes = row[index + 1].toString().split("/");
      oldDate = row[index + 3];
      currentTestList.add(AfifTest.notPassed(
          index ~/ 4,
          notes: oldNotes,
          date: oldDate));
      return currentTestList;
    }
    int mark;
    List<String> notes = [];
    String date = "-";
    String research = "لم يتم";

    mark = row[index];
    research = row[index + 2].toString().length > 3
        ? "تم"
        : row[index + 2].toString().replaceFirst("تم", " ");

    List temp = LineSplitter.split(row[index + 3]).toList();
    if (temp.isNotEmpty) date = temp[0];
    if (temp.length > 1) {
      oldDate = temp[1];
    }

    temp = LineSplitter.split(row[index + 1]).toList();
    notes = temp.isEmpty ? ["-"] : temp[0].split("/");
    if (temp.length > 1) {
      oldNotes = temp[1].split("/");
      currentTestList.add(AfifTest.notPassed(
          index ~/ 4,
          notes: oldNotes,
          date: oldDate));
    }
    currentTestList.add(AfifTest.passed(
        index ~/ 4,
        mark: mark,
        notes: notes,
        date: date,
        research: research));
    return currentTestList;
  }
}
