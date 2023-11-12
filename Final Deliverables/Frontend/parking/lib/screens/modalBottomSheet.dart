import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parking/controller/polylineProvider.dart';
import 'package:parking/screens/favorite.dart';
import 'package:parking/controller/favoriteProvider.dart';
import 'package:parking/controller/pinpointController.dart';
import 'package:provider/provider.dart';
import 'package:parking/controller/markers.dart';
import 'package:parking/constants/harvesine.dart';

// class MarkFavorites extends StatelessWidget {
//   const MarkFavorites({Key? key}) : super(key: key);

//   //
//   //CAN DELETE THE BELOW BUILD CONTEXT, NOT USED ANYMORE
//   //
//   @override
//   Widget build(BuildContext context) {
//     //get listofwordshere
//     final words = nouns.take(50).toList();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('English Words'),
//       ),
//       body: ListView.builder(
//         itemCount: words.length,
//         itemBuilder: (context, index) {
//           final word = words[index];
//           return ListTile(
//             title: Text(word),
//             trailing: ElevatedButton(
//               child: Text("Click Here"),
//               onPressed: () {
//                 //favouriteModalBottomSheet(context, word);
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton.extended(
//         onPressed: () {
//           final route = MaterialPageRoute(
//             builder: (context) => FavoritePage(),
//           );
//           Navigator.push(context, route);
//         },
//         label: const Text('Favorites'),
//       ),
//     );
//   }
// }

// class ModalBottomSheet extends StatefulWidget {
//   final CustomMarker customMarker;
//   LocationData? currentLocation;
//   void Function(List<LatLng> newCoordinates) updatePolylineCallback;
//   List<LatLng> polylineCoordinates;

//   ModalBottomSheet(
//       {required this.customMarker,
//       required this.currentLocation,
//       required this.updatePolylineCallback,
//       required this.polylineCoordinates});
//   @override
//   State<ModalBottomSheet> createState() => _ModalBottomSheetState();
// }

// class _ModalBottomSheetState extends State<ModalBottomSheet> {
//   late CustomMarker customMarker;
//   late LocationData? currentLocation;
//   late void Function(List<LatLng> newCoordinates) updatePolylineCallback;
//   late List<LatLng> polylineCoordinates;

//   bool _showBottomSheet = true;

//   @override
//   void initState() {
//     super.initState();
//     customMarker = widget.customMarker;
//     currentLocation = widget.currentLocation;
//     updatePolylineCallback = widget.updatePolylineCallback;
//     polylineCoordinates = widget.polylineCoordinates;
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (!_showBottomSheet) {
//       return Container();
//     } else {
//       return showModalBottomSheet(context: context, builder: (BuildContext (context) {

//       }));
//     }
//     // return showModalBottomSheet<void>(context: context, builder: (BuildContext (context) {
//     //   return Consumer<FavoriteProvider>(builder: (context, value, child) {
//     //     return SizedBox(

//     //     );
//     //   },);
//     // }));
//   }
// }

buildModalBottomSheet(
    BuildContext context,
    CustomMarker customMarker,
    LocationData? currentLocation,
    void Function(List<LatLng> newCoordinates) updatePolylineCallback,
    List<LatLng> polylineCoordinates) {
  PinPointController _pinCon = PinPointController();

  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    backgroundColor: Color.fromARGB(255, 219, 255, 178),
    isDismissible: true,
    enableDrag: true,
    builder: (BuildContext context) {
      return Consumer<FavoriteProvider>(
        builder: (context, provider, child) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * .30,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("(Area) ${customMarker.infoWindow.title}",
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 22,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold)),
                          Text(""),
                          Text(
                            "Slots Available: ${customMarker.availableLots}",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            "Carpark ID: ${customMarker.markerId.value} ${customMarker.infoWindow.snippet!.isNotEmpty ? '(${customMarker.infoWindow.snippet!})' : ''}",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            "Distance: ${calculateDistance(customMarker.position, LatLng(currentLocation?.latitude ?? 0.0, currentLocation?.longitude ?? 0.0)).toStringAsFixed(2)}km",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                          Text(
                            "Type: ${customMarker.agency} , ${customMarker.lotType}",
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              List<String> favorites =
                                  await provider.fetchListFavouriteCarparks();
                              final isFavorite = favorites.any((favorite) =>
                                  favorite == customMarker.markerId.value);
                              if (isFavorite) {
                                provider.deleteOneFavouriteCarparks(
                                    customMarker.markerId.value);
                              } else {
                                provider.storeFavouriteCarparks(
                                    customMarker.markerId.value);
                              }
                              // if (FavoriteProvider.of(context)
                              //     .isExist(customMarker)) {
                              //   provider.deleteOneFavouriteCarparks(
                              //       9, customMarker.markerId.value);
                              // } else {
                              //   FavoriteProvider.of(context)
                              //       .storeFavouriteCarparks(
                              //           9, customMarker.markerId.value);
                              // }
                              //FavoriteProvider.of(context).toggleFavorite(customMarker);
                            },
                            child: FutureBuilder<List<String>>(
                              future: provider.fetchListFavouriteCarparks(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return const Icon(Icons
                                      .star_border); // Display an empty star icon on error.
                                } else {
                                  final favorites = snapshot.data ?? [];
                                  final isFavorite = favorites.any((favorite) =>
                                      favorite == customMarker.markerId.value);

                                  return isFavorite
                                      ? Icon(Icons.star,
                                          color:
                                              Color.fromARGB(255, 247, 224, 10))
                                      : Icon(Icons.star_border);
                                }
                              },
                            ),
                            // FavoriteProvider.of(context)
                            //         .isExist(customMarker)
                            //     ? const Icon(Icons.star,
                            //         color: Color.fromARGB(255, 247, 224, 10),
                            //         size: 30)
                            //     : const Icon(Icons.star_border, size: 30)
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (polylineCoordinates.isEmpty) {
                                getPolyPoints(customMarker, currentLocation,
                                    updatePolylineCallback);
                              } else {
                                updatePolylineCallback([]);
                              }
                              Navigator.pop(context);
                            },
                            child: Icon(
                              (polylineCoordinates.isNotEmpty)
                                  ? Icons.directions_off
                                  : Icons.directions_outlined,
                              size: 30,
                            ),
                          ),
                          Row(children: [
                            FutureBuilder<bool>(
                                future: _pinCon.parkedSet(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else if (snapshot.data == false) {
                                    return Center(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          print(customMarker.markerId.value);
                                          _pinCon.showPinpointForm(context,
                                              customMarker.markerId.value);
                                        },
                                        child: Icon(Icons.car_rental),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ])
                        ]),
                  ],
                ),
              ]),
            ),
          );
        },
      );
    },
  );
}
