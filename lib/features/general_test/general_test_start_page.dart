import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quran_tester/choice_chip.dart';
import 'package:quran_tester/providers/user_provider.dart';
import 'package:quran_tester/features/test_page/test_page.dart';

import '../../providers/choice_provider.dart';

class GeneralTestStartPage extends StatelessWidget {
  const GeneralTestStartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of(context, listen: true);
    final ChoiceProvider choiceProvider = Provider.of(context, listen: true);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اختبار الحفظ في القرءان الكريم'),
        ),
        body: SingleChildScrollView(
          child: Column(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: 'الاسم',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onChanged: (value) => userProvider.name = value,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                'اختر الاجزاء المراد سبرها',
                style: TextStyle(
                    color: Colors.brown.shade400,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'البداية',
                style: TextStyle(
                    color: Colors.brown.shade400,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              MyChoiceChips(
                color: Colors.brown,
                whenSelect: (startValue) => choiceProvider.start = startValue,
                selected: choiceProvider.start,
              ),
              const SizedBox(height: 25),
              Text(
                'النهاية',
                style: TextStyle(
                    color: Colors.brown.shade400,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              MyChoiceChips(
                color: Colors.brown,
                whenSelect: (endValue) => choiceProvider.end = endValue,
                startPoint: choiceProvider.start,
                selected: choiceProvider.end,
              ),
              const SizedBox(height: 100),
              ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TestPage(
                      start: choiceProvider.start,
                      end: choiceProvider.end,
                      fullName: userProvider.name,
                      isRandom: true,
                    ),
                  ),
                ),
                child: const Text('ابدأ السبر'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}