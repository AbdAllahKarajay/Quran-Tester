import 'dart:io';

import 'package:quran_tester/models/afif_test.dart';
import 'package:quran_tester/services/hive_services.dart';
import 'package:quran_tester/services/students_excel.dart';

Future<void> main() async {
  await StudentsHiveServices.instance.init(dir: "./assets", temp: "./assets");
  // await StudentsHiveServices.instance.studentBox.clear();
  // await StudentsHiveServices.instance.studentBox.addAll(students);
  print("downloading");
  await StudentsHiveServices.instance.download();


  print("loadint");
  StudentsHiveServices.instance.getAll().forEach((student) {
    int index = -1;
    for (int j =0; j< student.tests.length; j++) {
      if(student.tests[j].isNotEmpty) index = j;
      // final attempts = student.tests[j].where((attempt) => attempt.passed == true).toList();
      // if(attempts.length > 1){
      //   for(int i = 0;i<attempts.length-1;i++){
      //     attempts[i].passed = false;
      //   }
      // }
    }

    for (int j = 0; j < index; j++) {
      try{
        student.tests[j].last.passed = true;
      }catch(_){
        student.tests[j].add(AfifTest.notPassed(j));
      }
    }
    student.save();
  });


  // final student = StudentsHiveServices.instance
  //     .getAllGraded()[1][5];
  // student.tests[3][0].passed = false;

  await StudentsHiveServices.instance.upload();
  await StudentsHiveServices.instance.download();

  print("SDKAS");

  final studentt = StudentsHiveServices.instance
      .getAllGraded()[1][5];
  print(studentt.tests[2][0]);
  print(studentt.tests[1]);

  await StudentsHiveServices.instance.download();
  //
  // await StudentsHiveServices.instance.studentBox.clear();
  //
  // await StudentsHiveServices.instance.download();

  // print(StudentsHiveServices.instance.getAll().length);
  // StudentsHiveServices.instance.getAll().forEach((element) {
  //   print(element.tests.map((e) => e.map((el) => [el.nameIndex, el.mark])));
  // });
}