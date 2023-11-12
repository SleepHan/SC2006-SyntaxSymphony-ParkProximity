import 'package:flutter/material.dart';
import 'package:parking/screens/history.dart';
import 'package:parking/screens/home.dart';
import 'package:parking/screens/chooseLocation.dart';
import 'package:parking/screens/favorite.dart';
import 'package:parking/screens/markFavorites.dart';
import 'package:parking/controller/favoriteprovider.dart';
import 'package:provider/provider.dart';
import 'package:dcdg/dcdg.dart';


void main() { 
  WidgetsFlutterBinding.ensureInitialized();
  //runApp(const MyApp());

  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoriteProvider(),
      child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => const HomeScreen(),
          '/history': (context) => const HistoryPage(),
          //'/': (context) => const SearchPage(),
          '/location': (context) => const ChooseLocationScreen(),
          '/favPage': (context) => const FavoritePage(),
          '/favSettings': (context) => const MarkFavorites(),
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
    return  MaterialApp(
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

//Setup:
//In AndroidManifest.xml, add API key
//In android build.gradle, put sdkCompilerVersion and minSDK

