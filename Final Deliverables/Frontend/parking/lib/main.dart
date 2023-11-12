import 'package:flutter/material.dart';
import 'package:parking/controller/parkProvider.dart';
import 'package:parking/controller/pinpointController.dart';
import 'package:parking/screens/history.dart';
import 'package:parking/controller/historyProvider.dart';
import 'package:parking/screens/home.dart';
import 'package:parking/screens/chooseLocation.dart';
import 'package:parking/screens/favorite.dart';
import 'package:parking/screens/modalBottomSheet.dart';
import 'package:parking/controller/favoriteProvider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:parking/constants/constant.dart';
import 'package:parking/controller/FilterControllers/preferences.dart';
//import 'package:dcdg/dcdg.dart';

final Preferences settings = Preferences();
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Checking User ID
  SharedPreferences prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('User ID')) {
    print("User ID not found - Creating User");
    http.Response response = await _createUserID();
    final data = jsonDecode(response.body);
    saveUIDLocally('User ID', data["id"].toString());
    // saveUIDLocally('User ID', '9');
  } else {
    print(await getUIDFromLocal('User ID'));
  }

  // // Checking Park Set
  PinPointController _pinCon = PinPointController();
  if (await _pinCon.parkedSet()) {
    prefs.setBool('Parked', true);
  } else {
    prefs.setBool('Parked', false);
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => FavoriteProvider()),
        ChangeNotifierProvider(create: (context) => ParkedProvider()),
        ChangeNotifierProvider<Preferences>(create: (context) => Preferences()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/history': (context) => HistoryPage(),
          //'/': (context) => const SearchPage(),
          '/location': (context) => const ChooseLocationScreen(),
          '/favPage': (context) => FavoritePage(),
          //'/favSettings': (context) => const MarkFavorites(),
          // '/Pinpoint': (context) => PinPointButtonWidget(),
          // '/Point': (context) => PinpointFeaturesStateless(),
        },
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking App',
      //onGenerateRoute: generateRoute,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
    );
  }
}

void saveUIDLocally(String key, String value) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString(key, value);
}

Future<String?> getUIDFromLocal(String key) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString(key);
}

Future<http.Response> _createUserID() {
  return http.post(Uri.parse(userConnect),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'Name': 'New User'}));
}
//Setup:
//In AndroidManifest.xml, add API key
//In android build.gradle, put sdkCompilerVersion and minSDK


