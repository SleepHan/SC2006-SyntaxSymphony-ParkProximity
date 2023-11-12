import 'package:flutter/material.dart';
import 'package:parking/controller/parkProvider.dart';
import 'package:parking/controller/pinpointController.dart';
import 'package:provider/provider.dart';

class PinPointButtonWidget extends StatefulWidget {
  @override
  State<PinPointButtonWidget> createState() => _PinPointButtonWidgetState();
}

class _PinPointButtonWidgetState extends State<PinPointButtonWidget> {
  PinPointController _pinCon = PinPointController();

  @override
  Widget build(BuildContext context) {
    final notifier = context.watch<ParkedProvider>();

    return Center(
      child: notifier.getParked()
          ? ElevatedButton(
              onPressed: () => _pinCon.showDeleteForm(context),
              child: Icon(Icons.car_rental),
            )
          : Container(),
    );
  }
}
