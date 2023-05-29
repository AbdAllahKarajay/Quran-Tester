import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:quran_tester/features/ljna/ljna_page.dart';
import 'package:quran_tester/providers/students_provider.dart';
import 'package:quran_tester/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:path_provider/path_provider.dart';
import 'models/student.dart';
import 'providers/choice_provider.dart';
import 'services/bank.dart';
import 'services/hive_services.dart';

Future<void> main() async {

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  final dir = (await getApplicationDocumentsDirectory()).path;
  final temp = (await getTemporaryDirectory()).path;
  await StudentsHiveServices.instance.init(dir: dir, temp: temp);
  await StudentsHiveServices.instance.download();
  Bank.initialize();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? firstTime = prefs.getBool('first_time');

  // else {// First time
  // prefs.setBool('first_time', false);
  // return new Timer(_duration, navigationPageWel);
  // }

  runApp(const MyApp());
  Timer(
    const Duration(milliseconds: 100),
    () => FlutterNativeSplash.remove(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final allStudents = StudentsHiveServices.instance.getAllGraded();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ChoiceProvider>(
          create: (context) => ChoiceProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => StudentsProvider(allStudents),
        )
      ],
      child: MaterialApp(
        title: 'Quran Tester',
        theme: ThemeData(
          primarySwatch: Colors.brown,
        ),
        home: const LjnaPage(),
      ),
    );
  }
}