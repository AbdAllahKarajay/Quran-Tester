import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_tester/models/afif_test.dart';
import 'package:quran_tester/models/constants/afif_tests_names.dart';
import 'package:quran_tester/providers/students_provider.dart';

class TestDetailsPage extends StatelessWidget{
  const TestDetailsPage({Key? key, required this.testsIndex}) : super(key: key);
  final int testsIndex;


  @override
  Widget build(BuildContext context) {
    final StudentsProvider studentsProvider = Provider.of(context);
    final List tests = studentsProvider.currentStudent.tests[testsIndex];
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text("${afifTestsNames[tests.first.nameIndex]} للطالب ${studentsProvider.currentStudent.shortName}"),
        ),
        body: Center(
          child: ListView(
            padding: const EdgeInsets.all(15),
            children: List.generate(tests.length, (index) {
              final AfifTest test = tests[index];
              return Card(
                color: test.passed? Colors.green.withOpacity(0.2): Colors.red.withOpacity(0.2),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const SizedBox(width: 15,),
                          Text("${test.date}"),
                          const Expanded(child: SizedBox()),
                          Text('${test.mark}', style: TextStyle(color: test.passed? Colors.green: Colors.red, fontSize: 20),),
                        ],
                      ),
                      Center(child: Text(" حلفة البحث ${test.research}")),
                      const Divider(),
                      ...?(test.notes?.map((e) => Text(e)).toList()),
                      const Divider(),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
