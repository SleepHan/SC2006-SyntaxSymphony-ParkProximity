import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:location/location.dart';
import 'package:parking/screens/home.dart';
import 'package:parking/controller/locationService.dart';
import 'package:parking/screens/FilterPreferences.dart';
import 'dart:async';
import 'package:parking/controller/markers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:parking/constants/constant.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
bool containsSubstringBitByBit(String searchString, List<String> stringList) {
  for (int i = 0; i < searchString.length; i++) {
    for (int j = i + 1; j <= searchString.length; j++) {
      String substring = searchString.substring(i, j);
      if (stringList.any((element) => element.contains(substring))) {
        return true;
      }
    }
  }
  return false;
}
  String? _validateInput(String? value) {
    List<String> towns = [
    'Ang Mo Kio',
    'Bedok',
    'Bishan',
    'Bukit Batok',
    'Bukit Merah',
    'Bukit Panjang',
    'Bukit Timah',
    'Central Water Catchment',
    'Changi',
    'Choa Chu Kang',
    'Clementi',
    'Downtown Core',
    'Geylang',
    'Hougang',
    'Jurong East',
    'Jurong West',
    'Kallang',
    'Lim Chu Kang',
    'Mandai',
    'Marine Parade',
    'Museum',
    'Newton',
    'North-Eastern Islands',
    'Novena',
    'Orchard',
    'Outram',
    'Pasir Ris',
    'Paya Lebar',
    'Pioneer',
    'Punggol',
    'Queenstown',
    'River Valley',
    'Rochor',
    'Seletar',
    'Sembawang',
    'Sengkang',
    'Serangoon',
    'Simpang',
    'Singapore River',
    'Southern Islands',
    'Straits View',
    'Sungei Kadut',
    'Tampines',
    'Tanglin',
    'Tengah',
    'Toa Payoh',
    'Tuas',
    'Western Islands',
    'Western Water Catchment',
    'Woodlands',
    'Yishun',
  ];
      bool inputContain = containsSubstringBitByBit(value!, towns);
    
    if (containsSymbols(value!)) {
      return 'Invalid address keyed (No symbols allowed). Please retry with a valid address';
    }

    else if (value.isEmpty) {
      return 'Invalid address keyed (Empty input given). Please retry with a valid address';
    }
    else if (inputContain==false){
      return 'Invalid address keyed (Not a town of Singapore). Please retry with a valid address';
    }
    // Add more validation logic if needed
    return null;
  }
  bool containsSymbols(String value){
    List<String> symbolList = ['@', '~', '\$', '!', '%', '*', '+', '_', '=', '{', '}', '[', ']' ];
    return symbolList.any((symbol)=>value.contains(symbol));
  }
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          SizedBox(
            width: 55,
          ),
          Flexible(
            child: Container(
              //margin: const EdgeInsets.symmetric(horizontal: 0.5, vertical: 8), //add margin
              //padding: const EdgeInsets.symmetric(vertical: 8.0), //add padding
              //color: Colors.white,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),
              // child: TextFormField(
              //   controller: _searchController,
              //   textCapitalization: TextCapitalization.words,
              //   decoration: InputDecoration(
              //     hintText: 'Search by Address',
              //     border: InputBorder.none,
              //   ),
              //   validator: _validateInput,
              //   onChanged: (value) {
              //     //print(value);
              //   },
              // ),
              child: GooglePlaceAutoCompleteTextField(
                textEditingController:_searchController,
                googleAPIKey: google_api_key,
                inputDecoration: InputDecoration(
                  hintText: "Search your location",
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  iconColor: Colors.white,
                ),
                countries: ['sg'],
                getPlaceDetailWithLatLng: (Prediction prediction) {
                  print("placeDetails" + prediction.lat.toString());
                },
                itemClick: (prediction){
                  _searchController.text= prediction.description!;
                },        
                debounceTime: 300,
              textStyle: TextStyle(color: Colors.black), // Set text color
                 )
            ),
          ),
          IconButton(
            onPressed: () async {
              String? error = _validateInput(_searchController.text);

              if (error == null) {
                // Input is valid, proceed with the search
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var place = await LocationService().getPlace(_searchController.text);
                await prefs.setDouble('clickLat', place['geometry']['location']['lat']);
                await prefs.setDouble('clickLng', place['geometry']['location']['lng']);
                await prefs.setInt('selector', 1);
                savePlaceLocally('place1', place);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));
              } else {
                // Input is not valid, show an error message or take appropriate action
                // For example, show a snackbar with the error message
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Input Error'),
                        content: Text(error),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close the AlertDialog
                            },
                            child: Text('I have noted the error in my input.'),
                          ),
                        ],
                      );
                    },
                  );
                _searchController.clear();

              }
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              //Navigator.push(context,MaterialPageRoute(builder: (context) => FilterPreferences()));
              final route = MaterialPageRoute(
                builder: (context) => const FilterPreferences(),
              );
              Navigator.push(context, route);
            },
            icon: Icon(IconData(0xe976, fontFamily: 'MaterialIcons')),
          ),
        ],
      ),
    );
  }
}


  // Future<void> goToPlace(Map<String, dynamic> place) async {
  //   // var context;
  //   // Get.toNamed('/');

  //   Completer<GoogleMapController> _controller = Completer();
  //   final double lat = place['geometry']['location']['lat'];
  //   final double lng = place['geometry']['location']['lng'];
  //   //print('lat: $lat');
  //   //print('lat: $lng'); 
  //   print('_goToPlace is running.');
  //   //print('place: $place');
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(target: LatLng(lat, lng), zoom: 12),
  //   ));
  // }

//   Future<void> navigateThenPerform(BuildContext context) async {
//   // Navigator.push returns a Future that completes after calling
//   // Navigator.pop on the Selection Screen.
//   final result = await Navigator.push(
//     context,
//     MaterialPageRoute(builder: (context) => const HomeScreen()),
//   );

//   // When a BuildContext is used from a StatefulWidget, the mounted property
//   // must be checked after an asynchronous gap.
//   if (!context.mounted) return;

//   // After the Selection Screen returns a result, hide any previous snackbars
//   // and show the new result.
//   Completer<GoogleMapController> _controller = Completer();
//   TextEditingController _searchController = TextEditingController();
//   var place = await LocationService().getPlace(_searchController.text);
//   _goToPlace(place);

// }
    
  