import 'package:flutter/material.dart';
import 'package:quran_tester/models/student.dart';

import '../services/hive_services.dart';

class StudentsProvider extends ChangeNotifier {
  List<List<Student>> allStudents;
  late List<Student> allStudentsExpanded;

  List<Student> _students = [];
  late Student currentStudent;
  int _filter = 0;

  List<Student> get students => _students;
  int get gradesCount => StudentsHiveServices.instance.gradesCount;
  int get filter => _filter;

  StudentsProvider(this.allStudents){
    _filter = allStudents.length;
    allStudentsExpanded = allStudents.expand((x) => x).toList();
    _students = allStudents.last;
  }

  set filter(int grade){
    _filter = grade;
    if(grade==0){
      _students = allStudentsExpanded;
    }else{
      _students = allStudents[grade- 1];
    }
    notifyListeners();
  }

  search(String search){
    _students = allStudentsExpanded.where((element) => element.name.contains(search)).toList();
    notifyListeners();
  }

  reInit(List<List<Student>> newStudents){
    allStudents = newStudents;
    allStudentsExpanded = allStudents.expand((x) => x).toList();
  }
}
