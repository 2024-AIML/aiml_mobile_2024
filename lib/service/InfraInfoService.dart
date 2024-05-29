import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;


class Hospital {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;

  Hospital({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  factory Hospital.fromXml(xml.XmlElement element) {
    String getText(xml.XmlElement element, String tagName) {
      return element.findElements(tagName).isNotEmpty
          ? element.findElements(tagName).first.text
          : '';
    }

    double getDouble(xml.XmlElement element, String tagName) {
      return element.findElements(tagName).isNotEmpty
          ? double.parse(element.findElements(tagName).first.text)
          : 0.0;
    }

    return Hospital(
      name: getText(element, 'dutyName'),
      address: getText(element, 'dutyAddr'),
      latitude: getDouble(element, 'latitude'),
      longitude: getDouble(element, 'longitude'),
      distance: getDouble(element, 'distance')
    );
  }
}

class Pharmacy {
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distance;

  Pharmacy({
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  factory Pharmacy.fromXml(xml.XmlElement element) {
    String getText(xml.XmlElement element, String tagName) {
      return element.findElements(tagName).isNotEmpty
          ? element.findElements(tagName).first.text
          : '';
    }

    double getDouble(xml.XmlElement element, String tagName) {
      return element.findElements(tagName).isNotEmpty
          ? double.parse(element.findElements(tagName).first.text)
          : 0.0;
    }

    return Pharmacy(
      name: getText(element, 'dutyName'),
      address: getText(element, 'dutyAddr'),
      latitude: getDouble(element, 'latitude'),
      longitude: getDouble(element, 'longitude'),
      distance: getDouble(element, 'distance'),
    );
  }
}


class InfraInfoService {
  static const String hospitalbaseUrl = 'http://apis.data.go.kr/B552657/HsptlAsembySearchService/getHsptlMdcncLcinfoInqire';
  static const String pharmacybaseUrl = 'http://apis.data.go.kr/B552657/ErmctInsttInfoInqireService/getParmacyLcinfoInqire';

  static const String apiKey = '0rP2ebMU2B4za9nAjJri0kHShH6Fq1oKm19HsfZZhKNLSeZoj4sV0w7YDtOKS4AfMW7o26MPi25/nrILCVN7Qg==';

 static Future<List<dynamic>> fetchHospitals(double latitude, double longitude) async {
   final url = Uri.parse('$hospitalbaseUrl?WGS84_LAT=$latitude&WGS84_LON=$longitude&serviceKey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(utf8.decode(response.bodyBytes));
      var document = xml.XmlDocument.parse(utf8.decode(response.bodyBytes));
      var hospitals = document.findAllElements('item').map((element) {
        return Hospital.fromXml(element);
      }).toList();
      return hospitals;
    } else {
      throw Exception('Failed to load hospitals');
    }
  }

  static Future<List<dynamic>> fetchPharmacies(double latitude, double longitude) async {
   final url = Uri.parse('$pharmacybaseUrl?WGS84_LAT=$latitude&WGS84_LON=$longitude&serviceKey=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      print(utf8.decode(response.bodyBytes));
      var document = xml.XmlDocument.parse(utf8.decode(response.bodyBytes));
      var pharmacies = document.findAllElements('item').map((element) {
        return Pharmacy.fromXml(element);
      }).toList();
      return pharmacies;
    } else {
      throw Exception('Failed to load hospitals');
    }
  }
}

