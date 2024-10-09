// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_naver_map/flutter_naver_map.dart';
// import 'package:geolocator/geolocator.dart';
// import '../screens/SearchFriend.dart';
// import '../widget/CommonScaffold.dart';
//
// class FriendLocation extends StatefulWidget {
//   @override
//   _FriendLocationState createState() => _FriendLocationState();
// }
//
// class _FriendLocationState extends State<FriendLocation> {
//   List<Map<String, dynamic>> friends = []; // Stores friend info with location
//   List<Map<String, dynamic>> filteredFriends = [];
//   TextEditingController searchController = TextEditingController();
//   bool isLoading = false;
//   Position? _currentPosition;
//   NaverMapController? _mapController;
//
//   @override
//   void initState() {
//     super.initState();
//     _fetchFriends();
//     _getCurrentLocation();
//   }
//
//   Future<void> _fetchFriends() async {
//     setState(() {
//       isLoading = true; // Loading data
//     });
//     try {
//       // Replace with the actual API URL
//       final response = await http.get(Uri.parse('api 주소 여기 입력'));
//
//       if (response.statusCode == 200) {
//         List<dynamic> data = json.decode(response.body);
//         setState(() {
//           // Assuming the API returns a list of friends with 'name', 'latitude', and 'longitude'
//           friends = data.cast<Map<String, dynamic>>();
//           filteredFriends = friends; // Show full list initially
//         });
//       } else {
//         // Error handling
//         print('Failed to load friends');
//       }
//     } catch (e) {
//       print('Error: $e');
//     } finally {
//       setState(() {
//         isLoading = false; // Loading complete
//       });
//     }
//   }
//
//   // Search filter
//   void _filterFriends(String query) {
//     List<Map<String, dynamic>> results = [];
//     if (query.isEmpty) {
//       results = friends;
//     } else {
//       results = friends
//           .where((friend) =>
//           friend['name'].toLowerCase().contains(query.toLowerCase())) // Search by name
//           .toList();
//     }
//     setState(() {
//       filteredFriends = results;
//     });
//   }
//
//   // Confirm button action
//   void _search() {
//     _filterFriends(searchController.text);
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       setState(() {
//         _currentPosition = position;
//       });
//     } catch (e) {
//       print("Error: $e");
//     }
//   }
//
//   // Move the map to the selected friend's location
//   void _moveToFriendLocation(double latitude, double longitude) {
//     if (_mapController != null){
//       _mapController!.updateCamera(
//         NCameraUpdate.scrollAndZoomTo( target : NLatLng(_currentPosition!.latitude, _currentPosition!.longitude),
//         ),
//
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return CommonScaffold(
//       title: Text('내 친구 찾기'),
//
//       body: Column(
//         children: [
//           if (isLoading) // Show loading indicator
//             Center(child: CircularProgressIndicator())
//           else
//             ...[
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       child: TextField(
//                         controller: searchController,
//                         decoration: InputDecoration(
//                           labelText: '이름 또는 전화번호를 입력하세요',
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                     ),
//                     SizedBox(width: 10.0), // Space between search field and button
//                     ElevatedButton(
//                       onPressed: _search,
//                       child: Text('확인'),
//                     ),
//                   ],
//                 ),
//               ),
//               SizedBox(height: 50.0),
//
//               Container(
//                 height: 100.0,
//                 color: Colors.grey[300],
//                 child: Center(
//                   child: Text('여기에 친구 개인정보'),
//                 ),
//               ),
//               SizedBox(height: 50.0),
//
//               if (_currentPosition != null) // Display map if the location is available
//                 Flexible(
//                   flex: 15, // Map size control
//                   child: NaverMap(
//                     options: NaverMapViewOptions(
//                       initialCameraPosition: NCameraPosition(
//                         target: NLatLng(
//                           _currentPosition!.latitude,
//                           _currentPosition!.longitude,
//                         ),
//                         zoom: 14,
//                       ),
//                     ),
//                     onMapReady: (controller) {
//                       setState(() {
//                         _mapController = controller;
//                       });
//                     },
//                   ),
//                 ),
//               Expanded(
//                 flex: 4, // List size control
//                 child: ListView.builder(
//                   itemCount: filteredFriends.length,
//                   itemBuilder: (context, index) {
//                     return ListTile(
//                       title: Text(filteredFriends[index]['name']), // Display friend's name
//                       onTap: () {
//                         double latitude = filteredFriends[index]['latitude'];
//                         double longitude = filteredFriends[index]['longitude'];
//                         _moveToFriendLocation(latitude, longitude); // Move map to friend's location
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//         ],
//       ),
//     );
//   }
// }
