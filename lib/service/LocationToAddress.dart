import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationToAddressService {
  final String naverClientId = 'vbuyb9r3k9';
  final String naverClientSecret = 'BfVUIMtidWxbl2oknXpImwn8hbjcphnWHSr6LPty';
  final String serverUrl = 'http://127.0.0.1:8080/location/address';

  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    final String apiUrl =
        'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$longitude,$latitude&output=json';
    final headers = {
      'X-NCP-APIGW-API-KEY-ID': naverClientId,
      'X-NCP-APIGW-API-KEY': naverClientSecret,
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);

        if (jsonResponse['results'] != null && jsonResponse['results'].isNotEmpty) {
          final result = jsonResponse['results'][0];
          final region = result['region'];
          final land = result['land'];

          // Extract region components
          final area1 = region?['area1']?['name'] ?? '';
          final area2 = region?['area2']?['name'] ?? '';
          final area3 = region?['area3']?['name'] ?? '';

          // Extract land components
          final landName = land?['name'] ?? '';
          final number1 = land?['number1'] ?? ''; // This should be replaced with the correct path if available in the response

          // Construct the full address
          final address = [
            area1,
            area2,
            area3,
            landName,
            number1
          ].where((e) => e.isNotEmpty).join(' ');

          return address;
        } else {
          throw Exception('No results found in the response');
        }
      }

      else {
        throw Exception('Failed to fetch address');
      }
    } catch (e) {
      throw Exception('Error fetching address: $e');
    }
  }

  Future<void> sendAddressToServer(String address) async {
    try {
      final response = await http.post(
        Uri.parse(serverUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'address': address}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to send address.');
      }
    } catch (e) {
      throw Exception('Error sending address to server: $e');
    }
  }
}

