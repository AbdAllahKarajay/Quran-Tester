import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:quran_tester/choice_chip.dart';
import 'package:quran_tester/providers/user_provider.dart';
import 'package:quran_tester/services/bank.dart';
import 'package:quran_tester/test_page.dart';

import 'providers/choice_provider.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  Timer(
    const Duration(milliseconds: 1500),
    () => FlutterNativeSplash.remove(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChoiceProvider>(
          create: (context) => ChoiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Quran Tester',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        home: const MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    Bank.initialize();
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
                      // noQ: 5,
                    ),
                  ),
                ),
                child: const Text('ابدا السبر'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}