import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:parking/controller/polylineProvider.dart';
import 'package:parking/controller/favoriteProvider.dart';
import 'package:parking/controller/pinpointController.dart';
import 'package:provider/provider.dart';
import 'package:parking/controller/markers.dart';
import 'package:parking/controller/harvesine.dart';

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
