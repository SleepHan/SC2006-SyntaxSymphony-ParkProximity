import 'package:equatable/equatable.dart';

class RadiusDistance extends Equatable{
  late final int id;
  late final String radius;


  RadiusDistance({
    required this.id,
    required this.radius,
  });
  
  @override

  List<Object?> get props => [id, radius];

  static List<RadiusDistance> radiusDist = [
    RadiusDistance(id: 0, radius: '1km'),
    RadiusDistance(id: 1, radius: '2km'),
    RadiusDistance(id: 2, radius: '5km'),
  ];

}