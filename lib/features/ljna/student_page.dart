import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

import 'package:quran_tester/features/ljna/test_details_page.dart';
import 'package:quran_tester/models/afif_test.dart';
import 'package:quran_tester/models/constants/afif_tests_names.dart';

import '../../models/student.dart';
import '../../providers/students_provider.dart';
import '../../services/hive_services.dart';
import '../test_page/test_page.dart';

class StudentPage extends StatefulWidget {
  const StudentPage(this._student, {Key? key}) : super(key: key);
  final Student _student;

  @override
  State<StudentPage> createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  bool isCumulative = false;
  bool isFive = false;

  @override
  Widget build(BuildContext context) {
    final studentt = StudentsHiveServices.instance
        .getAllGraded()[1][5];
    print(studentt.tests[2]);
    print(studentt.tests[1]);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget._student.shortName,
              style: const TextStyle(fontSize: 24)),
          centerTitle: true,
        ),
        body: ListView.builder(
            itemCount: 8,
            itemBuilder: (context, index) {
              final List test = widget._student.tests[index];
              if (index == 0 || index == 7) {
                return Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Card(
                    child: ListTile(
                      leading: (test.isEmpty)?
                        const Icon(Icons.cancel_outlined, color: Colors.transparent,):
                        GestureDetector(
                            onTap: () => showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: SizedBox(
                                    height: 100,
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                            " هل أنت متأكد من إزالة ${afifTestsNames[index]} ل ${widget._student.shortName}"),
                                        ElevatedButton(
                                            onPressed: () {
                                              test.clear();
                                              Navigator.of(context).pop();
                                              setState(() {});
                                            },
                                            child: const Text("نعم"))
                                      ],
                                    ),
                                  ),
                                )),
                            child: const Icon(
                              Icons.check_circle_outline,
                              color: Colors.green)
                        ),
                      title: Text(afifTestsNames[index]),
                      trailing: (test.isNotEmpty)?
                          null:
                          ElevatedButton(
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                        child: SizedBox(
                                          height: 100,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                  " هل أنت متأكد أن ${widget._student.shortName} قام ب${afifTestsNames[index]}"),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    test.add(AfifTest.passed(
                                                        index,
                                                        date: dateFormat(
                                                            DateTime.now())));
                                                    Navigator.of(context).pop();
                                                    setState(() {});
                                                  },
                                                  child: const Text("نعم"))
                                            ],
                                          ),
                                        ),
                                      )),
                              child: const Text("تم السبر")),
                    ),
                  ),
                );
              }
              if (widget._student.isPassed(index)) {
                return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Card(
                        child: ListTile(
                          leading: (test.isNotEmpty)?
                          const Icon(Icons.check_circle_outline, color: Colors.green,): const Icon(Icons.cancel_outlined, color: Colors.transparent,),
                          title: Text(afifTestsNames[index]),
                          subtitle: Text(
                              "${index % 2 == 0 ? (index - 2) * 5 + 1 : (index - 1) * 5 + 1} -> ${index * 5}"),
                          trailing: (test.isNotEmpty && test.last.mark != -1)?
                              Text(
                                  "${test.firstWhere((element) => element.passed == true).mark}"): null,
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  TestDetailsPage(testsIndex: index),
                            ),
                          ),
                        )));
              }
              return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  child: ListTile(
                    leading: (test.isNotEmpty)?
                      const Icon(Icons.cancel_outlined, color: Colors.red,): const Icon(Icons.cancel_outlined, color: Colors.transparent,),
                    minLeadingWidth: 10,
                    title: Text(afifTestsNames[index]),
                    subtitle: Text(
                        "${index % 2 == 0 ? (index - 2) * 5 + 1 : (index - 1) * 5 + 1} -> ${index * 5}"),
                    trailing: ElevatedButton(
                      child: const Text("ابدأ السبر"),
                      onPressed: () {

                        showDialog(
                            context: context,
                            builder: (context) => StartDialog(
                                  index: index,
                                ));
                      },
                    ),
                    onTap: () {
                      if (test.isEmpty) return;
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              TestDetailsPage(testsIndex: index),
                        ),
                      );
                    },
                  ),
                ),
              );
            }),
      ),
    );
  }
}

class StartDialog extends StatefulWidget {
  const StartDialog({Key? key, required this.index}) : super(key: key);
  final int index;

  @override
  State<StartDialog> createState() => _StartDialogState();
}

class _StartDialogState extends State<StartDialog> {
  get index => widget.index;

  get isTenTest => index % 2 == 0;
  bool isCumulative = false;
  bool isTen = true;

  get start => isTenTest && isTen ? (index - 2) * 5 + 1 : (index - 1) * 5 + 1;

  get end => index * 5;

  @override
  Widget build(BuildContext context) {
    final StudentsProvider studentsProvider = Provider.of(context, listen: true);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Dialog(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.grey.shade100,
            height: isTenTest ? 300 : 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Card(
                  margin: const EdgeInsets.all(15),
                  color: Colors.white,
                  child: SwitchListTile(
                    value: isCumulative,
                    onChanged: (value) => setState(() => isCumulative = value),
                    title: const Text("سبر تراكمي"),
                    // subtitle: Text("عدد الأسئلة: ${isCumulative ? 4 : 5}"),
                  ),
                ),
                // if (isTenTest)
                //   Card(
                //     margin: const EdgeInsets.all(15),
                //     color: Colors.white,
                //     child: SwitchListTile(
                //       value: isTen,
                //       onChanged: (value) => setState(() => isTen = value),
                //       title: Text(isTen ? "عشرة أجزاء" : "خمسة أجزاء"),
                //     ),
                //   ),
                if (isTenTest)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ChoiceChip(
                          label: const Text("عشرة أجزاء",
                              style: TextStyle(color: Colors.white)),
                          selected: isTen,
                          onSelected: (value) => setState(() => isTen = true),
                          backgroundColor: Colors.brown,
                          selectedColor: Colors.brown.withOpacity(0.4)),
                      ChoiceChip(
                        label: const Text("خمسة أجزاء",
                            style: TextStyle(color: Colors.white)),
                        selected: !isTen,
                        onSelected: (value) => setState(() => isTen = false),
                        backgroundColor: Colors.brown,
                        selectedColor: Colors.brown.withOpacity(0.4),
                      ),
                    ],
                  ),
                Text("عدد الأسئلة: ${isCumulative ? 4 : 5}"),
                Text("من $start إالى $end"),
                ElevatedButton(
                    onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => TestPage(
                                    start: start,
                                    end: end,
                                    fullName:
                                        studentsProvider.currentStudent.name,
                                    isRandom: false,
                                    noQ: isCumulative ? 4 : 5,
                                  )),
                        ),
                    child: const Text("ابدأ السبر")),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// fix(StudentsProvider studentsProvider) async {
//   print("loadint");
//   StudentsHiveServices.instance.getAll().forEach((student) {
//     int index = -1;
//     for (int j =0; j< student.tests.length; j++) {
//       if(student.tests[j].isNotEmpty) index = j;
//       final attempts = student.tests[j].where((attempt) => attempt.passed == true).toList();
//       if(attempts.length > 1){
//         for(int i = 0;i<attempts.length-1;i++){
//           attempts[i].passed = false;
//         }
//       }
//     }
//
//     for (int j = 0; j < index; j++) {
//       try{
//         student.tests[j].last.passed = true;
//       }catch(_){
//         student.tests[j].add(AfifTest.notPassed(j));
//       }
//     }
//     student.save();
//   });
//
//
//   final student = StudentsHiveServices.instance
//       .getAllGraded()[1][5];
//   student.tests[3][0].passed = false;
//
//   await StudentsHiveServices.instance.upload();
//   await StudentsHiveServices.instance.download();
//
//   final newStudents = StudentsHiveServices.instance.getAllGraded();
//   studentsProvider.reInit(newStudents);
//   print("SDKAS");
//
// //
// //   // final student = StudentsHiveServices.instance.getAllGraded()[2][5];
// //   // print("sdj");
// //
// //   // StudentsHiveServices.instance.getAll().forEach((element) {
// //   //   print(element.tests.map((e) => e.map((el) => [el.nameIndex, el.mark])));
// //   // });
// }
