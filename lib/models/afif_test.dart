import 'package:quran_tester/models/enums/afif_tests_names_enum.dart';

class AfifTest {
  final AfifTestsNames name;
  late final bool passed;
  int? mark;
  List<String>? notes;
  String? date;
  String? research;


  AfifTest.passed(this.name,
      {this.mark = -1, this.notes = const ["-"], this.research = "لم يتم", this.date = "-"}){passed = true;}

  AfifTest.notPassed(this.name,
      {this.notes = const ["-"], this.date = "-"}){mark = -1; passed = false; research = "لم يتم";}

  @override
  String toString() {
    return """ test name: $name passed: $passed mark: $mark
    notes: ${notes?.join(", ")}
    date: $date research: $research
    """;
  }
}
