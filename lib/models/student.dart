import 'afif_test.dart';


class Student{
  final String name;
  final String shortName;
  final String mjeezName;
  List<List<AfifTest>> tests = [[],[],[],[],[],[],[],[]]; //8
  bool isFinished;
  String? finishDate;

  Student(this.name, {required this.shortName, required this.tests, required this.mjeezName, required this.isFinished, this.finishDate = "-"});

  @override
  String toString() {
    // TODO: implement toString
    return """ 
    name: $name - short name: $shortName - mjeez: $mjeezName
    tests: ${tests.map((e) => e.toString()).join("\n")}
    finished: $isFinished finish date: $finishDate
    """;
  }
}
