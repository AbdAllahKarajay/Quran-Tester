import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:quran_tester/choice_chip.dart';
import 'package:quran_tester/test_page.dart';

void main() {
  Timer(
      const Duration(milliseconds: 1500),
          () =>
  runApp(const MyApp())
      );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quran Tester',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> parts = List.generate(30, (index) => index + 1);
  SelectedStart start = SelectedStart();

  // int start = 1;
  int end = 1;

  @override
  void initState() {
    start.selected = 1;
    end = 1;
  }


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('اختبار الحفظ في القرءان الكريم'),
        ),
        body: Container(
          // decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //         begin: Alignment.topCenter,
          //         end: Alignment.bottomCenter,
          //         colors: [
          //           Colors.greenAccent,
          //           Colors.greenAccent,
          //           Colors.cyanAccent.shade100
          //     ])),
          child: Column(
            textDirection: TextDirection.rtl,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('اختر الاجزاء المراد سبرها',
                  style: TextStyle(
                      color: Colors.brown.shade400,
                      fontSize: 30,
                      fontWeight: FontWeight.bold)),
              Text('البداية',
                  style: TextStyle(
                      color: Colors.brown.shade400,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
              MyChoiceChips(
                  count: 30,
                  color: Colors.brown,
                  notifyParent: (value) {
                    if(end < value) end = value;
                    return start.selected = value;
                  }),
              const SizedBox(
                height: 25,
              ),
              Text(
                'النهاية',
                style: TextStyle(
                    color: Colors.brown.shade400,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              MyChoiceChips(
                count: 30,
                color: Colors.brown,
                notifyParent: (value) => end = value,
                start: start,
              ),
              const SizedBox(
                height: 100,
              ),
              ElevatedButton(
                onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => TestPage(
                              start: start.selected,
                              end: end,
                            ))),
                child: const Text('ابدا السبر'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SelectedStart extends PropertyChangeNotifier<String> {
  int _selected = 1;

  int get selected => _selected;

  set selected(int newValue) {
    _selected = newValue;
    notifyListeners('tst');
  }
}
