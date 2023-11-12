import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:parking/controller/FilterControllers/categoryController.dart';

class FilterCategory extends Equatable{
  late final int id;
  late final Category category;
  late final bool value;
  
  FilterCategory({
    required this.id,
    required this.category,
    required this.value,
  });
  
  FilterCategory copyReplace({
    int? id,
    Category? category,
    bool? value,
  }){
    return FilterCategory(
      id:  id ?? this.id, 
      category: category ?? this.category,
      value: value ?? this.value,
     );
  }

  @override
  List<Object?> get props => [id, category, value];

  static List<FilterCategory> filters = Category.categories.map((category) => FilterCategory(
    id: category.id,
     category: category,
      value: false,
      )).toList();
}