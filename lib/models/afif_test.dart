import 'package:hive/hive.dart';
import 'package:quran_tester/models/enums/afif_tests_names.dart';

@HiveType(typeId: 1)
class AfifTest extends HiveObject {
  @HiveField(0)
  final int nameIndex;
  @HiveField(1)
  late bool passed;
  @HiveField(2)
  int? mark;
  @HiveField(3)
  List<String>? notes;
  @HiveField(4)
  String? date;
  @HiveField(5)
  String? research;

  AfifTest({required this.nameIndex,required this.passed, required this.mark, required this.notes, required this.date, required this.research});

  AfifTest.passed(this.nameIndex,
      {this.mark = -1,
      this.notes = const ["-"],
      this.research = "لم يتم",
      this.date = "-"}) {
    passed = true;
  }

  AfifTest.notPassed(this.nameIndex, {this.notes = const ["-"], this.date = "-"}) {
    mark = -1;
    passed = false;
    research = "لم يتم";
  }

  @override
  String toString() {
    return """
    test name index: $nameIndex / passed: $passed / mark: $mark
    notes: ${notes?.join(", ")}
    date: $date / research: $research
    """;
  }
}

class AfifTestAdapter extends TypeAdapter<AfifTest> {
  @override
  final typeId = 1;

  @override
  AfifTest read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AfifTest(
        nameIndex: fields[0] as int,
        passed: fields[1] as bool,
        mark: fields[2] as int,
        notes: fields[3] as List<String>,
        date: fields[4] as String,
        research: fields[5] as String
    );
  }

  @override
  void write(BinaryWriter writer, AfifTest obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.nameIndex)
      ..writeByte(1)
      ..write(obj.passed)
      ..writeByte(2)
      ..write(obj.mark)
      ..writeByte(3)
      ..write(obj.notes)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.research);
  }
}
