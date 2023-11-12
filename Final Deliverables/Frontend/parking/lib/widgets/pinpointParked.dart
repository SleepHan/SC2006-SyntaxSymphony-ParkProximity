import 'package:flutter/material.dart';
import 'package:parking/controller/pinpointController.dart';
import 'package:geolocator/geolocator.dart';

class PinPointParked extends StatefulWidget {
  final String carParkId;

  PinPointParked({required this.carParkId});

  @override
  State<PinPointParked> createState() => _PinPointParkedState();
}

class _PinPointParkedState extends State<PinPointParked> {
  TextEditingController _textEditingController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  PinPointController _pinCon = PinPointController();
  late String carParkId;

  @override
  void initState() {
    super.initState();
    carParkId = widget.carParkId;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(color: Colors.black, spreadRadius: 1),
          ],
        ),
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.centerLeft,
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              Icon(Icons.car_crash_rounded),
              Text(
                style: TextStyle(height: 2, fontSize: 20),
                'Pinpoint Your Location',
                overflow: TextOverflow.fade,
              ),
            ]),
            Text(
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
              'Remember where you park your car through this feature',
              overflow: TextOverflow.fade,
            ),
            Container(
              margin: EdgeInsets.only(bottom: 10.0, top: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(color: Colors.black, spreadRadius: 1),
                ],
              ),
              child: TextField(
                maxLines: 4,
                minLines: 4,
                textAlignVertical: TextAlignVertical.center,
                textAlign: TextAlign.left,
                decoration: InputDecoration(
                    hintText: 'Enter details about your parked location...',
                    contentPadding: EdgeInsets.all(10.0),
                    border: InputBorder.none),
                controller: _textEditingController,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _pinCon.processSubmission(
                      _textEditingController.text, carParkId, context);
                }
                Navigator.pop(context);
              },
              child: Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                Icon(Icons.car_repair),
                SizedBox(width: 10),
                Text(
                  style: TextStyle(height: 3),
                  'Save Parked Location',
                  overflow: TextOverflow.fade,
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}

void checkGPS() async {
  bool serviceStatus = await Geolocator.isLocationServiceEnabled();
  bool hasPermission = false;
  if (serviceStatus) {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        print('Location permissions were denied');
      } else if (permission == LocationPermission.deniedForever) {
        print('Location permission were denied permanently');
      } else {
        hasPermission = true;
      }
    } else {
      hasPermission = true;
    }
  }

  if (hasPermission) {
    print('GPS service permission granted');
  } else {
    print('GPS service permission denied');
  }
}
