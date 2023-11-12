import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParkedProvider extends ChangeNotifier {
  SharedPreferences? _prefs;

  ParkedProvider() {
    _initPrefs();
  }

  Future<void> _initPrefs() async {
    _prefs = await SharedPreferences.getInstance();
  }

  bool getParked() {
    return _prefs?.getBool('Parked') ?? false;
  }

  Future<void> setParked(bool isParked) async {
    await _prefs?.setBool('Parked', isParked);
    notifyListeners();
  }
}