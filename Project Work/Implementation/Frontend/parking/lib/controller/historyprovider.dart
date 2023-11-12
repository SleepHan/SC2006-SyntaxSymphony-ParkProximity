import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:parking/constants/constant.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parking/controller/markers.dart';

class ParkingRecord {
  final int parkingId;
  final String carparkId;
  final DateTime startTime;
  final DateTime endTime;
  final double totalCost;
  final Duration duration;
  final String marker;
  ParkingRecord({
    required this.carparkId,
    required this.parkingId,
    required this.startTime,
    required this.endTime,
    required this.totalCost,
    required this.duration,
    required this.marker,
  });
}

class HistoryProvider extends ChangeNotifier {
  List<ParkingRecord> _parkingRecords = [];
  List<ParkingRecord> get parkingRecords => _parkingRecords;

  Future<void> fetchParkingHistory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString('User ID') as String;
    final response = await http.get(
      Uri.parse('$histConnect/$userId'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      for (final item in data) {
        CustomMarker mark = await fetchOneCarparkData(item['carParkId']);
        final record = ParkingRecord(
          carparkId: item['carParkId'],
          parkingId: item['parkingId'],
          startTime: DateTime.parse(item['startTime']),
          endTime: DateTime.parse(item['endTime']),
          totalCost: item['totalCost'].toDouble(),
          duration: parseDuration(item['duration']),
          marker: mark.infoWindow.title ?? "",
        );
        addParkingRecord(record);
      }
    }
  }

  Duration parseDuration(String durationString) {
    final parts = durationString.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final secondsWithMicroseconds = parts[2].split('.');
    final seconds = int.parse(secondsWithMicroseconds[0]);
    final microseconds = int.parse(secondsWithMicroseconds[1]);
    return Duration(
      hours: hours,
      minutes: minutes,
      seconds: seconds,
      microseconds: microseconds,
    );
  }

  void addParkingRecord(ParkingRecord record) {
    _parkingRecords.add(record);
    notifyListeners();
  }

  Future<void> clearHistory() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userId = pref.getString('User ID') as String;
    final response = await http.delete(
        Uri.parse('http://172.21.148.169:8080/api/deleteHistory/$userId'));

    if (response.statusCode == 200) {
      _parkingRecords.clear();
      notifyListeners();
    } else {
      throw Exception("Failed to clear history in database");
    }
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
