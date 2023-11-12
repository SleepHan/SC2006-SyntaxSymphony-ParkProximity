import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart' as permission_handler;
import 'dart:async';
import 'package:parking/screens/locationService.dart';
import 'package:parking/screens/history.dart';
import 'package:parking/screens/historyprovider.dart';
import 'package:provider/provider.dart';
import 'package:parking/widgets/pinpoint_button.dart';
import 'package:parking/screens/favorite.dart';
import 'package:parking/controller/favoriteprovider.dart';
import 'package:parking/screens/markFavorites.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final Completer<GoogleMapController> _controller = Completer();
  TextEditingController _searchController = TextEditingController();

  final ImageConfiguration customImageConfiguration =
      const ImageConfiguration(size: Size(128, 128));
  static const LatLng sourceLocation = LatLng(1.3483, 103.6831);
  bool locationPermissionGranted = false;

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

  Timer? locationUpdateTimer;
  LocationData? currentLocation;

  BitmapDescriptor sourceIcon = BitmapDescriptor.defaultMarker;
  BitmapDescriptor currentLocationIcon = BitmapDescriptor.defaultMarker;

  void getCurrentLocation() {
    Location location = Location();

    location.getLocation().then(
      (location) {
        currentLocation = location;
      },
    ).catchError((error) {
      print('Error getting location: $error');
    });
  }

  void startLocationUpdates() {
    locationUpdateTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      getCurrentLocation();
      setState(() {});
    });
  }

  void setCustomMarkerIcon() {
    BitmapDescriptor.fromAssetImage(
            customImageConfiguration, "assets/Pin_source.png")
        .then(
      (icon) {
        sourceIcon = icon;
      },
    );
    BitmapDescriptor.fromAssetImage(
            customImageConfiguration, "assets/Pin_current_location.png")
        .then(
      (icon) {
        currentLocationIcon = icon;
      },
    );
  }

  @override
  void initState() {
    getCurrentLocation();
    setCustomMarkerIcon();
    checkLocationPermission();
    startLocationUpdates();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        //leading: Divider(),
        
        // title: const Text(
        //   'Placeholder AppBar',
        //   style: TextStyle(color: Colors.black, fontSize: 16),
        // ),
        actions:[
          Spacer(),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0), //add margin
              padding: const EdgeInsets.symmetric(vertical: 5.0), //add padding
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
              ),

            child: TextFormField(
            controller: _searchController,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: 'Search by Address',
              border:InputBorder.none,
              ),
            onChanged:(value){
              print(value);
            },
            ),
            ),
          ),
          IconButton(
            onPressed:() async{
              var place = await LocationService().getPlace(_searchController.text);
              _goToPlace(place);
              //Navigator.push(context,MaterialPageRoute(builder: (context) =>SearchPage()));
            },
            icon: Icon(Icons.search),
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
                color: Colors.amber,
              ),
              accountEmail: null,
              accountName: Text("James Lee"),
              currentAccountPicture:  
                CircleAvatar(
                  maxRadius: 25,
                  backgroundColor: Colors.grey,
                  backgroundImage: AssetImage('assets/avatar.png'),
                ) ,
                
            ),
            ListTile(
                leading: Icon(
                  IconData(0xe318, fontFamily: 'MaterialIcons'),
                  size: 30,

                ),
                title: const Text(
                  'Home Screen',
                  style: TextStyle(
                    fontSize: 15,
                  )
                  ),
                onTap:(){
                  Navigator.push(context,MaterialPageRoute(builder: (context) =>HomeScreen()));
                  //Scaffold.of(context).openDrawer();
                },
            ),
            ListTile(
                leading: Icon(
                  Icons.bookmarks,
                  size: 30,
                ),
                title: const Text(
                  'Favourites Page',
                  style: TextStyle(
                    fontSize: 15,
                  )
                  ),
                onTap: () {
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
                  Icons.star,
                  size: 30,
                ),
                title: const Text(
                  'Favourites Settings',
                  style: TextStyle(
                    fontSize: 15,
                  )
                  ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) => InheritedProvider(
                        create: (context) => FavoriteProvider(),
                        builder: (context, child) => MarkFavorites(),
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
                title: const Text(
                  'History',
                  style: TextStyle(
                    fontSize: 15,
                  )
                  ),
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
            ListTile(
                leading: Icon(
                  IconData(0xf01f5, fontFamily: 'MaterialIcons'),
                  size: 30,
                ),
                title: const Text(
                  'Contact Us',
                  style: TextStyle(
                    fontSize: 15,
                  )
                  ),
                //selected: _selectedIndex == 2,
                onTap: () {
                  // Update the state of the app
                  //_onItemTapped(2);
                  // Then close the drawer
                  Navigator.pop(context);
                },
              ),

          Divider(
            color: Colors.white,
            ),
          Spacer(), //fill up any free-space
          ListTile(
            title: Text('Settings'),
            leading: Icon(Icons.settings),
          ),
          ListTile(
            title: Text('Info'),
            leading: Icon(Icons.info),
            )
            ],
            ),
            ),                
      body: Stack(
        children:<Widget>[
          currentLocation == null
          ? const SpinKitFoldingCube(
              color: Colors.green,
              size: 40,
              duration: (Duration(milliseconds: 1200)),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    currentLocation!.latitude!, currentLocation!.longitude!),
                zoom: 15,
              ),
              markers: {
                  Marker(
                    markerId: const MarkerId("currentLocation"),
                    icon: currentLocationIcon,
                    position: LatLng(currentLocation!.latitude!,
                        currentLocation!.longitude!),
                  ),
                  Marker(
                      markerId: const MarkerId("Source"),
                      icon: sourceIcon,
                      position: sourceLocation,
                      infoWindow: const InfoWindow(
                        title: "test",
                        snippet: "this is a test",
                      )),
                }),
            

      ],
      ),
      );
  }


  Future <void> _goToPlace(Map<String,dynamic> place) async {
    final double lat = place['geometry']['location']['lat'];
    final double lng = place['geometry']['location']['lng'];

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: LatLng(lat, lng), zoom: 12),
    ));
  }

}
