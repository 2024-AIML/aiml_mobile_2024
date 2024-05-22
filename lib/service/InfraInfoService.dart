import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Hospital {
  final String name;
  final String address;
  final double lat;
  final double lng;

  Hospital({
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });
}

class InfraInfoService {
  final String apiKey = '0rP2ebMU2B4za9nAjJri0kHShH6Fq1oKm19HsfZZhKNLSeZoj4sV0w7YDtOKS4AfMW7o26MPi25/nrILCVN7Qg==';
  final String baseUrl = 'http://apis.data.go.kr/B552657/HsptlAsembySearchService/getHsptlMdcncLcinfoInqire';

  Future<List<dynamic>> fetchHospitals(double latitude, double longitude) async {
    final String encodedApiKey = Uri.encodeComponent(apiKey);
    final String query = Uri.encodeComponent('병원');
    final response = await http.get(Uri.parse(
        '$baseUrl?WGS84_LAT=$latitude&WGS84_LON=$longitude&apikey=$encodedApiKey&query=$query'));
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['hospitals'];
    } else {
      throw Exception('Failed to load hospitals');
    }
  }
}

