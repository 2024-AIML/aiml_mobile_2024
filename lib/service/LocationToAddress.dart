// import 'dart:convert';
// import 'package:geolocator/geolocator.dart';
// import 'package:http/http.dart' as http;
//
//
// class LocationToAddressService {
//   final String naverClientId = 'vbuyb9r3k9';
//   final String naverClientSecret = 'BfVUIMtidWxbl2oknXpImwn8hbjcphnWHSr6LPty';
//   final String serverUrl = 'http://127.0.0.1:8080/api/address';
//
//   Future<Position> getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       throw Exception('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         throw Exception('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       throw Exception('Location permissions are permanently denied.');
//     }
//
//     return await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high);
//   }
//
//   Future<String> getAddressFromLatLng(double latitude, double longitude) async {
//     final String apiUrl =
//         'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?coords=$longitude,$latitude&sourcers=epsg:4326&orders=roadaddr&output=json';
//     final headers = {
//       'X-NCP-APIGW-API-KEY-ID': naverClientId,
//       'X-NCP-APIGW-API-KEY': naverClientSecret,
//     };
//
//     try {
//       final response = await http.get(Uri.parse(apiUrl), headers: headers);
//
//       if (response.statusCode == 200) {
//         final jsonResponse = json.decode(response.body);
//
//         if (jsonResponse['results'] != null &&
//             jsonResponse['results'].isNotEmpty) {
//           final result = jsonResponse['results'][0];
//           final region = result['region'];
//           final land = result['land'];
//
//           print('land: $land');
//
//           final area1 = region?['area1']?['name'] ?? '';
//           final area2 = region?['area2']?['name'] ?? '';
//           final area3 = region?['area3']?['name'] ?? '';
//
//           final Name = land?['name'] ?? '';
//           final number1 = land?['number1'] ?? ''; // Adjust if necessary
//
//           final address = [
//             area1,
//             area2,
//             area3,
//             Name,
//             number1
//           ].where((e) => e.isNotEmpty).join(' ');
//
//           return address;
//         } else {
//           throw Exception('No results found in the response');
//         }
//       } else {
//         throw Exception('Failed to fetch address');
//       }
//     } catch (e) {
//       throw Exception('Error fetching address: $e');
//     }
//   }
//
//   Future<void> sendRequest(String address) async {
//     final url = Uri.parse(serverUrl);
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {
//           'Content-Type': 'application/json', // 토큰 없이 요청할 경우, Authorization 헤더 제거
//         },
//         body: jsonEncode({"address": address}),
//       );
//
//       if (response.statusCode == 200) {
//         print('Request successful');
//       } else {
//         print('Failed to send address: ${response.statusCode} - ${response.body}');
//       }
//     } catch (e) {
//       print('Error sending request: $e');
//     }
//   }
// }