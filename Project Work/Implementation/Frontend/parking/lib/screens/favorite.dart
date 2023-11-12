import 'package:flutter/material.dart';
import 'package:parking/controller/favoriteProvider.dart';
import 'package:parking/controller/markers.dart';
import 'package:parking/screens/home.dart';
//import 'package:parking/screens/markFavorites.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritePage extends StatefulWidget {
  @override
  FavoritePageState createState() => FavoritePageState();
}

class FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: Colors.lightGreen,
      ),
      body: FutureBuilder<void>(
          future: Provider.of<FavoriteProvider>(context, listen: true)
              .fetchFavouriteCarparks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error:${snapshot.error}');
            } else {
              return Consumer<FavoriteProvider>(
                builder: (context, provider, child) {
                  //final provider = FavoriteProvider.of(context);
                  final List<CustomMarker> favourites = provider.words;
                  if (favourites.isEmpty) {
                    return Center(
                      child: Text("Favourite is empty"),
                    );
                  } else {
                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                              itemCount: favourites.length,
                              itemBuilder: (context, index) {
                                final favourite = favourites[index];
                                return ListTile(
                                  title: Text(
                                      "Parking Location: [${favourite.markerId.value}]\n${favourite.infoWindow.title}"),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Lots Available: ${favourite.availableLots}"),
                                      Text(
                                          "CarparkID: ${favourite.markerId.value} ${favourite.infoWindow.snippet!.isNotEmpty ? '(' + favourite.infoWindow.snippet! + ')' : ''}"),
                                      Text(
                                          "Type: ${favourite.agency} , ${favourite.lotType}"),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          provider.deleteOneFavouriteCarparks(
                                              favourite.markerId.value);
                                          setState(() {});

                                          //provider.toggleFavorite(favourite);
                                        },
                                        icon: provider.isExist(favourite)
                                            ? const Icon(Icons.star,
                                                color: Color.fromARGB(
                                                    255, 247, 224, 10))
                                            : const Icon(Icons.star_border),
                                      ),
                                      IconButton(
                                          onPressed: () async {
                                            final double lat =
                                                favourite.position.latitude;
                                            final double lng =
                                                favourite.position.longitude;
                                            SharedPreferences prefs =
                                                await SharedPreferences
                                                    .getInstance();
                                            await prefs.setDouble(
                                                'favLat', lat);
                                            await prefs.setDouble(
                                                'favLng', lng);
                                            await prefs.setInt('selector',
                                                0); //select 0 for going to favorite location
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        HomeScreen()));
                                          },
                                          icon:
                                              Icon(Icons.assistant_navigation))
                                    ],
                                  ),
                                );
                              }),
                        ),
                        ElevatedButton(
                            onPressed: (() async {
                              await provider.clearFavouriteCarparks();
                              setState(() {});
                            }),
                            child: Text('Clear All Favourites'))
                      ],
                    );
                  }
                },
              );
            }
          }),
    );
  }
}
