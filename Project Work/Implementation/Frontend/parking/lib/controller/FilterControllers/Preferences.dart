//import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:parking/controller/FilterControllers/categoryController.dart';
import 'package:parking/controller/FilterControllers/categoryFilterController.dart';
import 'package:parking/controller/FilterControllers/radiusDistance.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class Preferences extends ChangeNotifier {
  late String radID;
  late double radFilter;

  late int filtercarparkIDdefault;
  late bool filterRed;
  late bool filterYellow;
  late bool filterGreen;

  // Preferences({
  //   required this.radID,
  //   required this.filtercarparkID,
  // });
  //get method to obtain radID, filtercarparkID
  String get radiusFilter => radID;
  int get carparkAvailabilityFilter => filtercarparkIDdefault;
  double get radRange => radFilter;
  bool get red => filterRed;
  bool get yellow => filterYellow;
  bool get green => filterGreen;

  //set methods to set radID and filtercarparkID
  set radiusID(String radID) => this.radID = radID;
  set carparkAvailabilityFilterID(int filtercarparkIDdefault) =>
      this.filtercarparkIDdefault = filtercarparkIDdefault;
  set radiusRange(double radFilter) => this.radFilter = radFilter;

  set filterColorRed(bool filterRed) => this.filterRed = filterRed;
  set filterColorYellow(bool filterYellow) => this.filterYellow = filterYellow;
  set filterColorGreen(bool filterGreen) => this.filterGreen = filterGreen;

  // @override
  // List<Object?> get props => [radID, filtercarparkID];
  void setRadiusFilterByIndex(int index) {
    if (index >= 0 && index < RadiusDistance.radiusDist.length) {
      if (RadiusDistance.radiusDist[index].radius == '5km') {
        radFilter = 5.0;
      } else if (RadiusDistance.radiusDist[index].radius == '2km') {
        radFilter = 2.0;
      } else if (RadiusDistance.radiusDist[index].radius == '1km') {
        radFilter = 1.0;
      }
      notifyListeners(); // Notify listeners after updating the value

      //radFilter = double.parse(RadiusDistance.radiusDist[index].radius.replaceAll('km', ''));
    }
  }

  void setCarParkAvailabilityByIndex(int index) {
    filtercarparkIDdefault = 0;
    print('index: $index');
    print('${FilterCategory.filters[index]}');
    print('${FilterCategory.filters[index].id}');
    if (index >= 0 && index < FilterCategory.filters.length) {
      if ((FilterCategory.filters[index].id) == 0) {
        filterRed = true;
        print('Red -- $filterRed');
      }
      if (FilterCategory.filters[index].id == 1) {
        filterYellow = true;
        print('Yellow -- $filterYellow');
      }
      if (FilterCategory.filters[index].id == 2) {
        filterGreen = true;
        print('Green -- $filterGreen');
      }
      notifyListeners(); // Notify listeners after updating the value

      //radFilter = double.parse(RadiusDistance.radiusDist[index].radius.replaceAll('km', ''));
    }
  }

  void setCarParkAvailabilityByIndexToggleOff(int index) {
    filtercarparkIDdefault = 0;
    print('index: $index');
    print('${FilterCategory.filters[index]}');
    print('${FilterCategory.filters[index].id}');
    if (index >= 0 && index < FilterCategory.filters.length) {
      if ((FilterCategory.filters[index].id) == 0) {
        filterRed = false;
        print('Red -- $filterRed');
      }
      if (FilterCategory.filters[index].id == 1) {
        filterYellow = false;
        print('Yellow -- $filterYellow');
      }
      if (FilterCategory.filters[index].id == 2) {
        filterGreen = false;
        print('Green -- $filterGreen');
      }
      notifyListeners(); // Notify listeners after updating the value

      //radFilter = double.parse(RadiusDistance.radiusDist[index].radius.replaceAll('km', ''));
    }
  }

  void initialiseAttributes() async {
    final prefs = await SharedPreferences.getInstance();
    filterRed = prefs.getBool('red') ?? false;
    filterYellow = prefs.getBool('yellow') ?? false;
    filterGreen = prefs.getBool('green') ?? false;
    filtercarparkIDdefault = prefs.getInt('settings') ?? 1;
    radFilter = prefs.getDouble('savedRadFilter') ?? 1.0;
  }
}
