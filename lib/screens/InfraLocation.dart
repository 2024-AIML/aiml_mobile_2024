// import 'dart:async';
// //import 'dart:html';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart'as http;
// import 'package:flutter_naver_map/flutter_naver_map.dart';
// import 'package:geolocator/geolocator.dart';
// import 'dart:convert';
// import '../service/InfraInfoService.dart';
// import '../widget/CommonScaffold.dart';
//
//
// class InfraScreen extends StatefulWidget {
//   @override
//   _InfraScreenState createState() => _InfraScreenState();
// }
//
// class _InfraScreenState extends State<InfraScreen> {
//   final String naverApiKey = 'BfVUIMtidWxbl2oknXpImwn8hbjcphnWHSr6LPty';
//   Image? mapImage;
//   String? selectedLocation;
//   final List<String> select = ['병원', '약국'];
//   List _hospitals = [];
//   List _pharmacies = [];
//   List<NMarker> markers = [];
//   Position? _currentPosition;
//   NaverMapController? _controller;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     _fetchHospitals();
//     _fetchPharmacies();
//   }
//
//   Future<void> _fetchHospitals() async {
//     if (_currentPosition != null) {
//       try {
//         final data = await InfraInfoService.fetchHospitals(
//           _currentPosition!.latitude,
//           _currentPosition!.longitude,
//         );
//         setState(() {
//           _hospitals = data;
//         });
//         _updateMarkers();
//       } catch (e) {
//         print('Error fetching hospitals: $e');
//       }
//     }
//   }
//
//   Future<void> _fetchPharmacies() async {
//     if (_currentPosition != null) {
//       try {
//         final data = await InfraInfoService.fetchPharmacies(
//           _currentPosition!.latitude,
//           _currentPosition!.longitude,
//         );
//         setState(() {
//           _pharmacies = data;
//         });
//         _updateMarkers();
//       } catch (e) {
//         print('Error fetching pharmacies: $e');
//       }
//     }
//   }
//
//   void _updateMarkers() {
//     setState(() {
//       markers = [];
//       if (selectedLocation == '병원') {
//         markers = _hospitals.map((hospital) {
//           return NMarker(
//             id: hospital.name,
//             position: NLatLng(hospital.latitude, hospital.longitude),
//           );
//         }).toList();
//       } else if (selectedLocation == '약국') {
//         markers = _pharmacies.map((pharmacy) {
//           return NMarker(
//             id: pharmacy.name,
//             position: NLatLng(pharmacy.latitude, pharmacy.longitude),
//           );
//         }).toList();
//       }
//
//       if (_controller != null) {
//         _controller!.clearOverlays().then((_) {
//           for (var marker in markers) {
//             _controller!.addOverlay(marker).catchError((e) {
//               print('Error adding marker: $e');
//             });
//           }
//         }).catchError((e) {
//           print('Error clearing overlays: $e');
//         });
//       }
//     });
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       LocationPermission permission = await Geolocator.requestPermission();
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       setState(() {
//         _currentPosition = position;
//       });
//       if (_controller != null) {
//         _controller!.updateCamera(
//           NCameraUpdate.scrollAndZoomTo(
//             target: NLatLng(
//               _currentPosition!.latitude,
//               _currentPosition!.longitude,
//             ),
//           ),
//         );
//       }
//       _fetchHospitals();
//       _fetchPharmacies();
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CommonScaffold(
//       title: Text("Infra Info"),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (_currentPosition != null)
//             Expanded(
//               child: NaverMap(
//                 options: NaverMapViewOptions(
//                   initialCameraPosition: NCameraPosition(
//                     target: NLatLng(
//                       _currentPosition!.latitude,
//                       _currentPosition!.longitude,
//                     ),
//                     zoom: 14,
//                   ),
//                 ),
//                 onMapReady: (controller) {
//                   setState(() {
//                     _controller = controller;
//                   });
//                 },
//               ),
//             ),
//           if (_currentPosition != null)
//             Expanded(
//               child: Column(
//                 children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ListTile(
//                           title: Text('병원'),
//                           leading: Radio<String>(
//                             value: '병원',
//                             groupValue: selectedLocation,
//                             onChanged: (String? value) {
//                               setState(() {
//                                 selectedLocation = value;
//                                 _updateMarkers(); // Update markers when '병원' radio button is selected
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                       Expanded(
//                         child: ListTile(
//                           title: Text('약국'),
//                           leading: Radio<String>(
//                             value: '약국',
//                             groupValue: selectedLocation,
//                             onChanged: (String? value) {
//                               setState(() {
//                                 selectedLocation = value;
//                                 _updateMarkers(); // Update markers when '약국' radio button is selected
//                               });
//                             },
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   if (selectedLocation == '병원')
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: _hospitals.length,
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             title: Text(_hospitals[index].name),
//                             subtitle: Text(
//                               '${_hospitals[index].distance?.toStringAsFixed(
//                                   2)} km',
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                   if (selectedLocation == '약국')
//                     Expanded(
//                       child: ListView.builder(
//                         itemCount: _pharmacies.length,
//                         itemBuilder: (context, index) {
//                           return ListTile(
//                             title: Text(_pharmacies[index].name),
//                             subtitle: Text(
//                               '${_pharmacies[index].distance?.toStringAsFixed(
//                                   2)} km',
//                             ),
//                           );
//                         },
//                       ),
//                     ),
//                 ],
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }