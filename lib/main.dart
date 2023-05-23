import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:provider/provider.dart';
import 'package:quran_tester/providers/user_provider.dart';

import 'features/general_test/general_test_start_page.dart';
import 'package:path_provider/path_provider.dart';
import 'providers/choice_provider.dart';
import 'services/hive_services.dart';

Future<void> main() async {
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
        home: const GeneralTestStartPage(),
      ),
    );
  }
}