import 'package:flutter/material.dart';
import 'package:parking/constants/constant.dart';
import 'package:parking/controller/markers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FavoriteProvider with ChangeNotifier {
  List<CustomMarker> _words = [];
  List<CustomMarker> get words => _words;

  Future<void> fetchFavouriteCarparks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userID = pref.getString('User ID') as String;
    final response = await http.get(Uri.parse('$favConnect/$userID'));

    if (response.statusCode == 200) {
      final List<dynamic> dynamicData = json.decode(response.body);
      final List<String> data = dynamicData.cast<String>();

      List<CustomMarker> favourites = [];

      //final List<CustomMarker> allMarkersList = await fetchCarparkData();
      for (String carparkId in data) {
        final CustomMarker customMarker = await fetchOneCarparkData(carparkId);
        favourites.add(customMarker);
      }

      // for (CustomMarker customMarker in allMarkersList) {
      //   if (data.contains(customMarker.markerId.value)) {
      //     favourites.add(customMarker);
      //   }
      // }
      _words.clear();
      _words.addAll(favourites);
      notifyListeners();
    } else {
      throw Exception('Failed to load favourite carpark data');
    }
  }

  Future<List<String>> fetchListFavouriteCarparks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userID = pref.getString('User ID') as String;
    final response = await http.get(Uri.parse('$favConnect/$userID'));

    if (response.statusCode == 200) {
      final List<dynamic> dynamicData = json.decode(response.body);
      final List<String> data = dynamicData.cast<String>();
      return data;

      // List<CustomMarker> favourites = [];

      // final List<CustomMarker> allMarkersList = await fetchCarparkData();
      // for (String carparkId in data) {
      //   final CustomMarker customMarker = await fetchOneCarparkData(carparkId);
      //   favourites.add(customMarker);
      // }

      // for (CustomMarker customMarker in allMarkersList) {
      //   if (data.contains(customMarker.markerId.value)) {
      //     favourites.add(customMarker);
      //   }
      // }

      // return favourites;
    } else {
      throw Exception('Failed to load favourite carpark data');
    }
  }

  Future<void> storeFavouriteCarparks(String carparkId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userID = pref.getString('User ID') as String;
    final response =
        await http.get(Uri.parse('$favConnect/$userID/$carparkId'));
    if (response.statusCode == 200) {
      print('Succesful API response: ${response.body}');
      final CustomMarker customMarker = await fetchOneCarparkData(carparkId);
      _words.add(customMarker);
      notifyListeners();
    }
  }

  Future<void> clearFavouriteCarparks() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userID = pref.getString('User ID') as String;
    final response = await http.delete(Uri.parse('$favConnect/$userID'));
    if (response.statusCode == 200) {
      _words.clear();
      notifyListeners();
    } else {
      throw Exception("Failed to clear favourites in database");
    }
  }

  Future<void> deleteOneFavouriteCarparks(String carparkId) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String userID = pref.getString('User ID') as String;
    final response =
        await http.delete(Uri.parse('$favConnect/$userID/$carparkId'));
    if (response.statusCode == 200) {
      _words.removeWhere(
          (customMarker) => customMarker.markerId.value == carparkId);
      notifyListeners();
    } else {
      throw Exception("Failed to clear favourites in database");
    }
  }

  void toggleFavorite(CustomMarker marker) {
    final isExist = _words.any(
        (customMarker) => customMarker.markerId.value == marker.markerId.value);
    if (isExist) {
      _words.remove(marker);
    } else {
      _words.add(marker);
    }
    notifyListeners();
  }

  bool isExist(CustomMarker marker) {
    final isExist = _words.any(((customMarker) =>
        customMarker.markerId.value == marker.markerId.value));
    return isExist;
  }

  static FavoriteProvider of(
    BuildContext context, {
    bool listen = true,
  }) {
    return Provider.of<FavoriteProvider>(
      context,
      listen: listen,
    );
  }
}
