import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parking/constants/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:permission_handler/permission_handler.dart'
    as permission_handler;
import 'dart:async';
import 'package:parking/screens/history.dart';
import 'package:parking/controller/historyProvider.dart';
import 'package:provider/provider.dart';
import 'package:parking/widgets/pinpointButton.dart';
import 'package:parking/controller/markers.dart';
import 'package:parking/screens/favorite.dart';
import 'package:parking/controller/favoriteProvider.dart';
import 'package:parking/controller/currentLocation.dart';
import 'package:parking/controller/harvesine.dart';
import 'package:parking/screens/searchPage.dart';
import 'dart:convert';
import 'package:parking/main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Future<void> goToPlace(Map<String, dynamic> place) async {
  //   // var context;
  //   // Get.toNamed('/');

  //   //Completer<GoogleMapController> _controller = Completer();
  //   final double lat = place['geometry']['location']['lat'];
  //   final double lng = place['geometry']['location']['lng'];
  //   //print('lat: $lat');
  //   //print('lat: $lng');
  //   print('goToPlace is running.');
  //   //print('place: $place');
  //   final GoogleMapController controller = await _controller.future;
  //   controller.animateCamera(CameraUpdate.newCameraPosition(
  //     CameraPosition(target: LatLng(lat, lng), zoom: 15),
  //   ));
  // }
  Future<void> goToPlace(double lat, double lng) async {
    // var context;
    // Get.toNamed('/');

    //Completer<GoogleMapController> _controller = Completer();
    // final double lat = place['geometry']['location']['lat'];
    // final double lng = place['geometry']['location']['lng'];
    //print('lat: $lat');
    //print('lat: $lng');
    print('goToPlace is running.');
    //print('place: $place');
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 15),
    ));
  }

  Future<void> goToFavPlace(double? lat, double? lng) async {
    print('Go to favourite location');
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat!, lng!), zoom: 15),
    ));
  }

  Future<void> SharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // PinPointController _pinCon = PinPointController();

    // if (await _pinCon.parkedSet()) {
    //   if (!prefs.containsKey('Parked')) {
    //     prefs.setBool('Parked', true);
    //   }
    // } else {
    //   if (prefs.containsKey('Parked')) {
    //     prefs.remove('Parked');
    //   }
    // }

    //String val = wherePrefs.containsKey('place1');
    //settings.initialiseAttributes();

    //go to searched location via search

    if (prefs.getInt('selector') == 1) {
      if (prefs.containsKey('clickLat') == true) {
        //String loc = await getPlaceFromLocal('place1') as String;
        double? lat = prefs.getDouble('clickLat');
        double? lng = prefs.getDouble('clickLng');
        //print('loc: $loc');
        //print('type of loc:');
        //print(jsonDecode(loc).runtimeType);
        await goToPlace(lat!, lng!);
        await searchLocationUpdates();
        startFetchSearchCarparks();
      }
    }
    if (prefs.getInt('selector') == 0) {
      // go to selected favourite carpark
      await goToFavPlace(prefs.getDouble('favLat'), prefs.getDouble('favLng'));
      await favoriteLocationUpdates(
          prefs.getDouble('favLat'), prefs.getDouble('favLng'));
      await prefs.setInt('selector', 1);
      startFetchFavCarparks();
    }

    settings.initialiseAttributes();
    // print(prefs.containsKey('User ID'));
    await prefs.remove('clickLat');
    await prefs.remove('clickLng');
  }

  Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();

  Timer? locationUpdateTimer, carparkIdTimer;
  LocationData? currentLocation;
  LocationData? searchedLocation;
  LocationData? favLocation;
  LatLng? pinpointLocation;

  bool locationPermissionGranted = false;

  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor selectedLocation =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueYellow);
  BitmapDescriptor pinpointIcon = BitmapDescriptor.defaultMarker;

  List<CustomMarker> allMarkersList = [];
  List<CustomMarker> smallerMarkersList = [];
  List<CustomMarker> searchedMarkersList = [];
  List<CustomMarker> favMarkersList = [];

  String? pinpointNotes;

  List<LatLng> polylineCoordinates = [];

  Future<void> checkLocationPermission() async {
    final status = await permission_handler.Permission.location.status;
    if (status == permission_handler.PermissionStatus.granted) {
      setState(() {
        locationPermissionGranted = true;
      });
    } else {
      final result = await permission_handler.Permission.location.request();
      if (result == permission_handler.PermissionStatus.granted) {
        setState(() {
          locationPermissionGranted = true;
        });
      }
    }
  }

  void startLocationUpdates() {
    locationUpdateTimer =
        Timer.periodic(const Duration(seconds: 5), (timer) async {
      LocationData? newCurrentLocation = await getCurrentLocation();
      setState(() {
        currentLocation = newCurrentLocation;
      });
    });
  }

  Future<void> searchLocationUpdates() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // String loc = await getPlaceFromLocal('place1') as String;
    // //print('loc-- $loc');
    // double? newSearchLocationLat =
    //     (jsonDecode(loc))['geometry']['location']['lat'];
    // double? newSearchLocationLong =
    //     (jsonDecode(loc))['geometry']['location']['lng'];
    double? newSearchLocationLat = prefs.getDouble('clickLat');
    double? newSearchLocationLng = prefs.getDouble('clickLng');

    setState(() {
      searchedLocation = LocationData.fromMap({
        'latitude': newSearchLocationLat,
        'longitude': newSearchLocationLng,
      });
    });
  }

  Future<void> favoriteLocationUpdates(double? lat, double? lng) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      favLocation = LocationData.fromMap({
        'latitude': lat,
        'longitude': lng,
      });
    });
  }

  void updatePolylineCoordinates(List<LatLng> newCoordinates) {
    setState(() {
      polylineCoordinates = newCoordinates;
    });
  }

  List<CustomMarker> addSearchLocationMarker(
      List<CustomMarker> updatedMarkers, double maxDistance) {
    final filteredMarkers = updatedMarkers.where((marker) {
      double distance = calculateDistance(
          LatLng(searchedLocation?.latitude ?? 0.0,
              searchedLocation?.longitude ?? 0.0),
          marker.position);
      return distance < maxDistance;
    });
    return filteredMarkers.toList();
  }

  List<CustomMarker> addCurrentLocationMarker(
      List<CustomMarker> updatedMarkers, double maxDistance) {
    final filteredMarkers = updatedMarkers.where((marker) {
      double distance = calculateDistance(
          LatLng(currentLocation?.latitude ?? 0.0,
              currentLocation?.longitude ?? 0.0),
          marker.position);
      return distance < maxDistance;
    });
    return filteredMarkers.toList();
  }

  List<CustomMarker> addFavLocationMarker(
      List<CustomMarker> updatedMarkers, double maxDistance) {
    final filteredMarkers = updatedMarkers.where((marker) {
      double distance = calculateDistance(
          LatLng(favLocation?.latitude ?? 0.0, favLocation?.longitude ?? 0.0),
          marker.position);
      return distance < maxDistance;
    });
    return filteredMarkers.toList();
  }

  void startFetchCarparks() async {
    print('FetchCarparks is running');

    carparkIdTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      try {
        List<CustomMarker> updatedMarkers = await fetchCarparkData();
        LatLng? coordinates;

        SharedPreferences pref = await SharedPreferences.getInstance();
        if (pref.containsKey('Lat')) {
          coordinates = LatLng(pref.getDouble('Lat') as double,
              pref.getDouble('Long') as double);
        }

        // List<CustomMarker> smallerMarkers =
        //     addCurrentLocationMarker(updatedMarkers, 2.0);
        setState(() {
          allMarkersList = updatedMarkers;
          pinpointLocation = coordinates;
          pinpointNotes = pref.getString('Notes');
          //smallerMarkersList = smallerMarkers;
        });
        startSmallerMarkersTimer();
      } catch (e) {
        print("Error fetching carpark data: $e");
      }
    });
  }

  void startFetchSearchCarparks() async {
    //carparkIdTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    try {
      List<CustomMarker> updatedMarkers = await fetchCarparkData();
      //List<CustomMarker> sMarkers = addSearchLocationMarker(searchedMarkersList, 5.0);
      print('fetchsearch is running');

      setState(() {
        allMarkersList = updatedMarkers;
        //searchedMarkersList = sMarkers;
        //searchedMarkersList = searchMakers;
      });
      startSmallerMarkersTimer();
      startSearchMarkersTimer();
    } catch (e) {
      print("Error fetching carpark data: $e");
    }
  }

  void startFetchFavCarparks() async {
    //carparkIdTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
    try {
      List<CustomMarker> updatedMarkers = await fetchCarparkData();
      //List<CustomMarker> sMarkers = addSearchLocationMarker(searchedMarkersList, 5.0);
      print('fetchsearch is running');

      setState(() {
        allMarkersList = updatedMarkers;
        //searchedMarkersList = sMarkers;
        //searchedMarkersList = searchMakers;
      });
      startFavMarkersTimer();
    } catch (e) {
      print("Error fetching carpark data: $e");
    }
  }

  void startSmallerMarkersTimer() {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      List<CustomMarker> smallerMarkers =
          addCurrentLocationMarker(allMarkersList, settings.radRange);
      setState(() {
        smallerMarkersList = smallerMarkers;
      });
    });
  }

  void startSearchMarkersTimer() {
    //List<CustomMarker> searchMarkers = addSearchLocationMarker(allMarkersList, 2.0);
    List<CustomMarker> searchMarkers =
        addSearchLocationMarker(allMarkersList, settings.radRange);

    setState(() {
      searchedMarkersList = searchMarkers;
      //allMarkersList = searchMarkers;
    });
  }

  void startFavMarkersTimer() {
    //List<CustomMarker> searchMarkers = addSearchLocationMarker(allMarkersList, 2.0);
    List<CustomMarker> favMarkers =
        addFavLocationMarker(allMarkersList, settings.radRange);

    setState(() {
      favMarkersList = favMarkers;
      //allMarkersList = searchMarkers;
    });
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(ImageConfiguration(size: Size(128, 128)),
            "assets/currentLocationPin.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            ImageConfiguration.empty, "assets/pinpointCar.png")
        .then(
      (icon) {
        pinpointIcon = icon;
      },
    );
  }

  @override
  void initState() {
    settings.initialiseAttributes();
    checkLocationPermission();
    setCustomMarkerIcon();
    startLocationUpdates();
    startFetchCarparks();
    SharedPref();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          //Spacer(flex:1),
          SizedBox(
            width: 55,
          ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 0.5), //add margin
              padding: const EdgeInsets.symmetric(vertical: 5.5), //add padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),

              child: TextFormField(
                controller: _searchController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  hintText: 'Tap to Search',
                  border: InputBorder.none,
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SearchPage()));
                },
                onChanged: (value) {
                  print(value);
                },
              ),
            ),
          ),
          IconButton(
            onPressed: () async {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SearchPage()));
            },
            icon: Icon(Icons.search),
          ),
          IconButton(
            onPressed: () async {
              final GoogleMapController controller = await _controller.future;
              controller.animateCamera(CameraUpdate.newCameraPosition(
                CameraPosition(
                    target: LatLng(currentLocation?.latitude ?? 0.0,
                        currentLocation?.longitude ?? 0.0),
                    zoom: 15),
              ));
            },
            icon: Icon(Icons.location_city),
          ),
          PinPointButtonWidget(),
        ],
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueAccent,
              ),
              accountEmail: null,
              accountName: Text("User"),
              currentAccountPicture: CircleAvatar(
                maxRadius: 25,
                backgroundColor: Colors.grey,
                backgroundImage: AssetImage('assets/avatar.png'),
              ),
            ),
            ListTile(
              leading: Icon(
                IconData(0xe318, fontFamily: 'MaterialIcons'),
                size: 30,
              ),
              title: const Text('Home Screen',
                  style: TextStyle(
                    fontSize: 15,
                  )),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
                //Scaffold.of(context).openDrawer();
              },
            ),
            ListTile(
              leading: Icon(
                Icons.bookmarks,
                size: 30,
              ),
              title: const Text('Favourites Page',
                  style: TextStyle(
                    fontSize: 15,
                  )),
              onTap: () {
                // final route = MaterialPageRoute(
                //   builder: (context) => const FavoritePage(),
                // );
                // Navigator.push(context, route);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => InheritedProvider(
                      create: (context) => FavoriteProvider(),
                      builder: (context, child) => FavoritePage(),
                    ),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                IconData(0xe314, fontFamily: 'MaterialIcons'),
                size: 30,
              ),
              title: const Text('History',
                  style: TextStyle(
                    fontSize: 15,
                  )),
              //selected: _selectedIndex == 1,
              onTap: () {
                // Update the state of the app
                //_onItemTapped(1);
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) => InheritedProvider(
                      create: (context) => HistoryProvider(),
                      builder: (context, child) => HistoryPage(),
                    ),
                  ),
                );
                //Navigator.push(context, MaterialPageRoute(builder: (context) => HistoryPage()));
                // Then close the drawer
                //Navigator.pop(context);
              },
            ),
            //Spacer(),
            ListTile(
              leading: Icon(
                IconData(0xf01f5, fontFamily: 'MaterialIcons'),
                size: 30,
              ),
              title: const Text('Customer Support',
                  style: TextStyle(
                    fontSize: 15,
                  )),
              subtitle: const Text(
                  'Contact us via email at app_support@parkingproximity.sg',
                  style: TextStyle(
                    fontSize: 12,
                    //color: Colors.grey,
                  )),
              //selected: _selectedIndex == 2,
              // onTap: () {
              //   // Update the state of the app
              //   //_onItemTapped(2);
              //   // Then close the drawer
              //   Navigator.pop(context);
              // },
            ),
          ],
        ),
      ),
      body: Stack(
        children: <Widget>[
          currentLocation == null
              ? const SpinKitFoldingCube(
                  color: Colors.green,
                  size: 40,
                  duration: (Duration(milliseconds: 1200)),
                )
              : GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(currentLocation?.latitude ?? 0.0,
                        currentLocation?.longitude ?? 0.0),
                    zoom: 14,
                  ),
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                  polylines: {
                    Polyline(
                      polylineId: PolylineId("route"),
                      points: polylineCoordinates,
                      color: Colors.blue,
                      width: 6,
                    )
                  },
                  //Below either use allMarkersList or smallerMarkersList
                  markers: Set<Marker>.from(
                    (smallerMarkersList.map((customMarker) =>
                        customMarkerToMarker(
                            context,
                            customMarker,
                            currentLocation,
                            updatePolylineCoordinates,
                            polylineCoordinates))),
                  )
                    ..add(Marker(
                      markerId: const MarkerId("currentLocation"),
                      icon: currentLocationIcon,
                      position: LatLng(currentLocation?.latitude ?? 0.0,
                          currentLocation?.longitude ?? 0.0),
                    ))
                    ..addAllIf(
                        searchedMarkersList.isNotEmpty,
                        searchedMarkersList.map((customMarker) =>
                            customMarkerToMarker(
                                context,
                                customMarker,
                                currentLocation,
                                updatePolylineCoordinates,
                                polylineCoordinates)))
                    ..add(Marker(
                      markerId: const MarkerId("Searched Location"),
                      icon: selectedLocation,
                      position: LatLng(searchedLocation?.latitude ?? 0.0,
                          searchedLocation?.longitude ?? 0.0),
                    ))
                    ..addAllIf(
                        favMarkersList.isNotEmpty,
                        favMarkersList.map((customMarker) =>
                            customMarkerToMarker(
                                context,
                                customMarker,
                                favLocation,
                                updatePolylineCoordinates,
                                polylineCoordinates)))
                    ..add(Marker(
                      markerId: const MarkerId("Favourite Location"),
                      icon: selectedLocation,
                      position: LatLng(favLocation?.latitude ?? 0.0,
                          favLocation?.longitude ?? 0.0),
                    ))
                    ..addIf(
                        pinpointLocation != null,
                        Marker(
                          markerId: const MarkerId("Pinpoint Location"),
                          icon: pinpointIcon,
                          position: pinpointLocation ?? LatLng(0, 0),
                          infoWindow: InfoWindow(title: pinpointNotes),
                        )),
                  circles: {
                    Circle(
                        circleId: CircleId("1"),
                        center: LatLng(currentLocation?.latitude ?? 0.0,
                            currentLocation?.longitude ?? 0.0),
                        radius: settings.radRange * 1000,
                        strokeWidth: 0,
                        fillColor: Color(0xFF006491).withOpacity(0.125))
                  },
                ),
        ],
      ),
    );
  }
}

void savePlaceLocally(String key, Map<String, dynamic> value) async {
  SharedPreferences wherePrefs = await SharedPreferences.getInstance();
  wherePrefs.setString(key, jsonEncode(value));
}

Future<String?> getPlaceFromLocal(String key) async {
  SharedPreferences wherePrefs = await SharedPreferences.getInstance();
  return wherePrefs.getString(key);
}

void saveSelector(String key, int value) async {
  SharedPreferences wherePrefs = await SharedPreferences.getInstance();
  wherePrefs.setInt(key, value);
}
