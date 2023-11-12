import 'package:flutter/material.dart';
import 'package:parking/controller/pinpoint_controller.dart';

class PinPointButtonWidget extends StatefulWidget {
  @override
  State<PinPointButtonWidget> createState() => _PinPointButtonWidgetState();
}

class _PinPointButtonWidgetState extends State<PinPointButtonWidget> {
  PinPointController _pinCon = PinPointController();

  Future<bool> _checkSet() async { return await _pinCon.parkedSet(); }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FutureBuilder<bool>(
        future: _checkSet(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) { return CircularProgressIndicator(); }
          else if (snapshot.hasError) { return Text('Error: ${snapshot.error}'); }
          else {
            final isSet = snapshot.data;
            Icon buttonIcon = Icon(Icons.error);
            if (isSet != null) { buttonIcon = isSet ? Icon(Icons.car_rental) : Icon(Icons.car_crash); }

            return ElevatedButton(
              onPressed: isSet != null 
                ? () { 
                  print(isSet); 
                  if(isSet) { _pinCon.showDeleteForm(context); } 
                  else { _pinCon.showPinpointForm(context); }
                }
                : () => print('null'),
              child:  buttonIcon,
            );
          }
        }
      ),
    );
  }
}