import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Student extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String id;
  @HiveField(2)
  final String shortName;
  @HiveField(3)
  List tests = [[], [], [], [], [], [], [], []]; //8
  @HiveField(4)
  String mjeezName;
  @HiveField(5)
  bool isFinished;
  @HiveField(6)
  String? finishDate;
  @HiveField(7)
  String? startDate;

  Student(this.name, this.id,
      {required this.shortName,
      required this.tests,
        this.mjeezName = "-",
        required this.isFinished,
        this.finishDate = "-",
        this.startDate
      });

  @override
  String toString() {
    return """ 
    
    name: $name id:$id / short name: $shortName / mjeez: $mjeezName
    tests: [\n${tests.map((e) => e.join("\n")).join("-------"
        "------\n")}\n]
    finished: $isFinished / finish date: $finishDate
    
    """;
  }

  int get gradeId => int.parse(id.substring(0,id.length-2));
  int get studentId => int.parse(id.substring(id.length-2,id.length));
}

class StudentAdapter extends TypeAdapter<Student> {
  @override
  final typeId = 0;

  @override
  Student read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Student(fields[0] as String,
        fields[1] as String,
        shortName: fields[2] as String,
        tests: fields[3] as List,
        mjeezName: fields[4] as String,
        isFinished: fields[5] as bool,
        finishDate: fields[6] as String,
        startDate: fields[7] as String?
    );
  }

  @override
  void write(BinaryWriter writer, Student obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.id)
      ..writeByte(2)
      ..write(obj.shortName)
      ..writeByte(3)
      ..write(obj.tests)
      ..writeByte(4)
      ..write(obj.mjeezName)
      ..writeByte(5)
      ..write(obj.isFinished)
      ..writeByte(6)
      ..write(obj.finishDate)
      ..writeByte(7)
      ..write(obj.startDate);
  }
}