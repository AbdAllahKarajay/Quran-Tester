import  'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_tester/features/general_test/general_test_start_page.dart';
import 'package:quran_tester/providers/students_provider.dart';
import 'student_page.dart';

class LjnaPage extends StatelessWidget {
  const LjnaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final StudentsProvider studentsProvider = Provider.of(context, listen: true);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("الطلاب", style: TextStyle(fontSize: 24)),
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                  style: const ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.white)),
                  onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const GeneralTestStartPage())),
                  child: const Text(
                    ("سبر عام"),
                    style: TextStyle(color: Colors.brown),
                  )),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: SizedBox(
                height: 50,
                child: TextField(
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: 'بحث',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    label: const Icon(Icons.search)
                  ),
                  onChanged: (value) {
                    if(value.isEmpty){
                      studentsProvider.filter = studentsProvider.filter;
                      return;
                    }
                    studentsProvider.search(value);
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: SizedBox(
                height: 30,
                width: 350,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  scrollDirection: Axis.horizontal,
                  itemCount: studentsProvider.gradesCount+1,
                  itemBuilder: (context, index){
                    index = studentsProvider.gradesCount-index;
                    return Ink(
                      width: 60,
                      decoration: BoxDecoration(
                        color: (studentsProvider.filter == index)? Colors.brown.withOpacity(0.3): Colors.brown,
                        borderRadius: BorderRadius.circular(25)
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(25),
                        onTap: () => studentsProvider.filter = index,
                        child: Center(child: Text((index!=0)?"${2001+index}": "الكل", style: const TextStyle(color: Colors.white),)),
                      ),
                    );
                  },
                  separatorBuilder: (context, index)=> const SizedBox(width: 10),
                ),
              ),
            ),
            Expanded(
              child: GridView.builder(
                itemCount: studentsProvider.students.length, gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                itemBuilder: (context, index) {
                  final student = studentsProvider.students[index];
                  return Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: Card(
                      color: (student.isFinished)? Colors.green.shade200: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: InkWell(
                        onTap: () {
                          studentsProvider.currentStudent = student;
                          Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => StudentPage(student))
                        );
                        },
                        child: Center(child: Text(student.shortName, style: const TextStyle(color: Colors.brown, fontSize: 15, fontWeight: FontWeight.bold),)),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget studentsListView(){
    return ListView();
  }
}
