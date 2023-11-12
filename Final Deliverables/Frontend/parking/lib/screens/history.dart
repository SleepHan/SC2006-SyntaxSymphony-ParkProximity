import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:parking/controller/historyProvider.dart';

class HistoryPage extends StatefulWidget {
  @override
  HistoryPageState createState() => HistoryPageState();
}

class HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Parking History'),
      ),
      body: FutureBuilder<void>(
        future: Provider.of<HistoryProvider>(context).fetchParkingHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Consumer<HistoryProvider>(
              builder: (context, provider, child) {
                List<ParkingRecord> parkingRecords = provider.parkingRecords;
                if (parkingRecords.isEmpty) {
                  return Center(
                    child: Text("History is empty"),
                  );
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: parkingRecords.length,
                          itemBuilder: (context, index) {
                            final record = parkingRecords[index];
                            return ListTile(
                              title: Text('Parking ID: ${record.parkingId}'),
                              subtitle: Text(
                                  'Address: ${record.marker}\nTime: ${record.startTime}\nEnd Time: ${record.endTime}\nDuration: ${record.duration}'),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await provider.clearHistory();
                          setState(() {}); // Trigger a rebuild
                        },
                        child: Text('Clear History'),
                      ),
                    ],
                  );
                }
              },
            );
          }
        },
      ),
    );
  }
}
