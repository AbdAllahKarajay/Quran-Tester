import 'dart:math';

import 'package:hive/hive.dart';

import '../models/afif_test.dart';
import '../models/student.dart';

class StudentsHiveServices{
  late Box _studentBox;
  late int _gradesCount;
  init() async {
    Hive..init("./")..registerAdapter(StudentAdapter())..registerAdapter(AfifTestAdapter());
    _studentBox = await Hive.openBox('students');
    _gradesCount = _studentBox.values.reduce((curr, next) {
      return curr.gradeId > next.gradeId? curr: next;
    }).gradeId;
  }

  int get studentCount => _studentBox.length;
  int get gradesCount => _gradesCount;

  //read
  Student getById(int id){
    return _studentBox.values.singleWhere((element) => int.parse(element.id) == id);
  }

  // print(hive.getAll().map((e) => e.map((element) => element.id).join(", ")).join("\n"));
  List<List> getAll(){
    return List.generate(_gradesCount, (index) => _studentBox.values.where((element) => element.gradeId == index+1).toList());
  }

  //can be replaced with getAll()[grade-1]
  // print(hive.getGradeStudents(10).map((e) => [e.id, e.name]).join(", "));
  List getGradeStudents(int grade){
    return _studentBox.values.where((element) => element.gradeId == grade).toList();
  }


  //write
  // hive.addStudent(name: "محمد", grade: 10, shortName: "م");
  addStudent({
    required String name,
    required int grade,
    required String shortName,
    List tests = const [[],[],[],[],[],[],[],[]],
    String mjeezName = "-",
    bool isFinished = false,
  }){
    var idsInGrade = _studentBox.values.where((element) => element.gradeId == grade).map((e) => e.studentId);
    int newStudentId = idsInGrade.isEmpty? 1:  idsInGrade.reduce((value, element) => value>element? value: element) + 1;
    String newId = newStudentId<10?"${grade}0$newStudentId": "$grade$newStudentId";
    Student newStudent = Student(name, newId, shortName: shortName, tests: tests, mjeezName: mjeezName, isFinished: isFinished);
    _studentBox.add(newStudent);
  }

  // hive.studentFinish(1001, date: "2002");
  studentFinish(int id, {required String date}){
    Student student = getById(id);
    student.isFinished = true;
    student.finishDate = date;
    student.save();
  }

  // hive.studentAddTest(1001, AfifTest(nameIndex: 0, passed: false, mark: -1 , notes: ["-"], date: "2002", research: "لم يتم"));
  studentAddTest(int id, AfifTest test){
    Student student = getById(id);
    student.tests[test.nameIndex].add(test);
    student.save();
  }

  // hive.studentEditTest(1001, 0, oldMark: -1, newMark: 90, newPassed: true);
  studentEditTest(int id, int testNumber ,{required int oldMark, required int newMark, required bool newPassed}){
    Student student = getById(id);
    AfifTest test = student.tests[testNumber].lastWhere((element) => element.mark == oldMark);
    test.mark = newMark;
    test.passed = newPassed;
    student.save();
  }

  // hive.studentChangeMjeez(1002, "المجيز");
  studentChangeMjeez(int id, String mjeezName){
    Student student = getById(id);
    student.mjeezName = mjeezName;
    student.save();
  }
}