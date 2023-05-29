import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  String _name = '';

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }
}
