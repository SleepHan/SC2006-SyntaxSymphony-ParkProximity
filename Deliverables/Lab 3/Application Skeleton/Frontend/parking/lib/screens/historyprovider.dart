import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HistoryProvider extends ChangeNotifier {
  List<String> _words = [];
  List<String> get words => _words;

  void addHistory(String word) {
    _words.add(word);
  }

  bool isExist(String word) {
    final isExist = _words.contains(word);
    return isExist;
  }

  void clearHistory() {
    _words = [];
    print(_words);
    notifyListeners();
  }

  static HistoryProvider of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<HistoryProvider>(
      context,
      listen: listen,
    );
  }
}
