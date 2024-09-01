import 'dart:io';
import 'package:csv/csv.dart';

class Shelter {
  final String InfraName;
  final String Address1;
  final double Capacity;
  final double latitude_EPSG4326;
  final double longitude_EPSG4326;
  double distance;

  Shelter({
    required this.InfraName,
    required this.Address1,
    required this.Capacity,
    required this.latitude_EPSG4326,
    required this.longitude_EPSG4326,
    required this.distance,
  });

  factory Shelter.fromCsv(List<dynamic> row) {
    return Shelter(
      InfraName: row[1] as String,
      Address1: row[2]?.toString() ?? '',
      Capacity: (row[6] is num ? (row[6] as num).toDouble() : double.tryParse(row[6]?.toString() ?? '0.0') ?? 0.0),
      latitude_EPSG4326: row[14] != null ? double.tryParse(row[14].toString()) ?? 0.0 : 0.0,
      longitude_EPSG4326: row[15] != null ? double.tryParse(row[15].toString()) ?? 0.0 : 0.0,
      distance: 0.0,
    );
  }
}
