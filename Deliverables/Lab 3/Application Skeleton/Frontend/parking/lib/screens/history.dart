import 'package:flutter/material.dart';
import 'package:parking/screens/historyprovider.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = HistoryProvider.of(context);
    final words = provider.words;
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: ListView.separated(
        itemCount: words.length,
        separatorBuilder: (BuildContext context, index) {
          return const Divider(height: 7);
        },
        itemBuilder: (context, index) {
          final word = words[index];
          return ListTile(
            title: Text(word),
            subtitle: Text("Lots Available:\nPrice:\nDistance:\nOpening Hours"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          provider.clearHistory();
        },
        label: const Text("Clear History"),
      ),
    );
  }
}
