import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:parking/controller/FilterControllers/categoryController.dart';
import 'package:parking/controller/FilterControllers/radiusDistance.dart';

class FilterRadius extends Equatable{
  late final int id;
  late final RadiusDistance radius;
  late final bool value;
  
  FilterRadius({
    required this.id,
    required this.radius,
    required this.value,
  });
  
  FilterRadius copyReplace({
    int? id,
    RadiusDistance? radius,
    bool? value,
  }){
    return FilterRadius(
      id:  id ?? this.id, 
      radius: radius ?? this.radius,
      value: value ?? this.value,
     );
  }

  @override
  List<Object?> get props => [id, RadiusDistance, value];

  static List<FilterRadius> filtersDistance = RadiusDistance.radiusDist.map((radius) => FilterRadius(
    id: radius.id,
     radius: radius,
      value: false,
      )).toList();
}