import 'package:quran_tester/enums/afif_tests_names_enum.dart';

class AfifTest {
  final AfifTestsNames name;
  List<String>? notes;
  DateTime? date;
  late final bool passed;
  int? mark;

  AfifTest.passed(this.name, this.mark,
      {this.notes, this.date}){passed = true;}

  AfifTest.notPassed(this.name){passed = false;}
}
