import 'package:flutter/material.dart';

class ChoiceProvider extends ChangeNotifier {
  int _start = 1;

  int _end = 1;

  int get start => _start;

  int get end => _end;

  final List<int> allJuz = List.generate(30, (index) => index + 1);

  set start(int startValue) {
    _start = startValue;
    notifyListeners();
  }

  set end(int endValue) {
    _end = endValue > start ? endValue : start;
    notifyListeners();
  }
}
