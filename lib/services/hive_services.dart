import 'dart:io';

import 'package:hive/hive.dart';

import '../models/afif_test.dart';
import '../models/student.dart';
import 'drive_services.dart';

class StudentsHiveServices{
  late Box studentBox;
  late int _gradesCount;
  final String dir;//"./assets";
  final String temp;//"./assets";
  final fileName = "students";

  StudentsHiveServices({required this.dir,required this.temp});

  init({bool? first}) async {
    if(first == null || first) Hive..init(dir)..registerAdapter(StudentAdapter())..registerAdapter(AfifTestAdapter());
    studentBox = await Hive.openBox('students');
    _gradesCount = studentBox.values.reduce((curr, next) {
      return curr.gradeId > next.gradeId? curr: next;
    }).gradeId;
  }

  int get studentCount => studentBox.length;
  int get gradesCount => _gradesCount;

  //read
  Student getById(int id) {
    return studentBox.values.singleWhere((element) => int.parse(element.id) == id);
  }

  // print(hive.getAll().map((e) => e.map((element) => element.id).join(", ")).join("\n"));
  List<List> getAll() {
    return List.generate(_gradesCount, (index) => studentBox.values.where((element) => element.gradeId == index+1).toList());
  }

  //can be replaced with getAll()[grade-1]
  // print(hive.getGradeStudents(10).map((e) => [e.id, e.name]).join(", "));
  List getGradeStudents(int grade){
    return studentBox.values.where((element) => element.gradeId == grade).toList();
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
  }) async {
    await download();
    var idsInGrade = studentBox.values.where((element) => element.gradeId == grade).map((e) => e.studentId);
    int newStudentId = idsInGrade.isEmpty? 1:  idsInGrade.reduce((value, element) => value>element? value: element) + 1;
    String newId = newStudentId<10?"${grade}0$newStudentId": "$grade$newStudentId";
    Student newStudent = Student(name, newId, shortName: shortName, tests: tests, mjeezName: mjeezName, isFinished: isFinished);
    await studentBox.add(newStudent);
  }

  // hive.studentFinish(1001, date: "2002");
  studentFinish(int id, {required String date}) async {
    await download();
    Student student = getById(id);
    student.isFinished = true;
    student.finishDate = date;
    await student.save();
  }

  // hive.studentAddTest(1001, AfifTest(nameIndex: 0, passed: false, mark: -1 , notes: ["-"], date: "2002", research: "لم يتم"));
  studentAddTest(int id, AfifTest test) async {
    await download();
    Student student = getById(id);
    student.tests[test.nameIndex].add(test);
    await student.save();
  }

  // hive.studentEditTest(1001, 0, oldMark: -1, newMark: 90, newPassed: true);
  studentEditTest(int id, int testNumber ,{required int oldMark, required int newMark, required bool newPassed}) async {
    await download();
    Student student = getById(id);
    AfifTest test = student.tests[testNumber].lastWhere((element) => element.mark == oldMark);
    test.mark = newMark;
    test.passed = newPassed;
    await student.save();
  }

  // hive.studentChangeMjeez(1002, "المجيز");
  studentSetMjeez(int id, String mjeezName) async {
    await download();
    Student student = getById(id);
    student.mjeezName = mjeezName;
    await student.save();
  }

  //hive.studentSetStartDate(1002,"date");
  studentSetStartDate(int id, String? date) async {
    await download();
    Student student = getById(id);
    student.startDate = date;
    await student.save();
  }

  download() async{
    // try{
      await DriveServices.downloadFileFromDrive("$fileName file.txt", '$dir/$fileName.hive');
      await init(first: false);
    // }catch(e){rethrow;}
  }

  upload() async {
    await DriveServices.uploadFileToDrive(File("$dir/$fileName.hive"), "$temp/$fileName file.txt");
  }
}

Future<void> main() async {
  StudentsHiveServices hive = StudentsHiveServices(dir: "./assets", temp: "./assets");
  await hive.init();
  await hive.download();
}
