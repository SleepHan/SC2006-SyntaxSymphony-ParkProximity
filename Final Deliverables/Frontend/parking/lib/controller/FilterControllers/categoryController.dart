import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';


class Category extends Equatable{
  late final int id;
  late final String name;
  late final Color color;
  //late final Image image;

  Category({
    required this.id,
    required this.name,
    required this.color,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, name, color];

  static List<Category> categories =[
    Category(
      id: 0,
      name: 'Fully Occupied',
      color: Colors.redAccent,
    ),
    Category(
      id: 1,
      name: 'Semi-Occupied',
      color: Colors.yellowAccent,
      ),
    Category(
      id: 2,
      name: 'Available',
      color: Colors.greenAccent,
      ),
  ];
  
}