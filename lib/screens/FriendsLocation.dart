import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:aiml_mobile_2024/screens/AddFriend.dart';
import 'package:aiml_mobile_2024/service/token_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FriendLocation extends StatefulWidget {
  @override
  _FriendLocationState createState() => _FriendLocationState();
}

class _FriendLocationState extends State<FriendLocation> {
  Position? _currentPosition;
  NaverMapController? _mapController;
  String userId = '';
  List<Map<String, dynamic>> friendsWithLocation = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    fetchUserInfo();
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> fetchUserInfo() async {
    String? jwtToken = await getJwtToken();

    if (jwtToken != null) {
      final response = await http.get(
        Uri.parse('http://3.36.69.187:8081/api/member/info'),
        headers: {
          'Authorization': 'Bearer $jwtToken',
        },
      );

      if (response.statusCode == 200) {
        var userData = jsonDecode(response.body);
        setState(() {
          userId = userData['id'] ?? 'Unknown';
        });
        fetchFriendNamesWithLocation();
      } else {
        print("사용자 정보 로딩 실패: ${response.statusCode}, ${response.body}");
      }
    } else {
      print("JWT 토큰이 없습니다.");
    }
  }

  Future<void> fetchFriendNamesWithLocation() async {
    try {
      QuerySnapshot friendsSnapshot = await FirebaseFirestore.instance
          .collection('USER_INFO')
          .doc(userId)
          .collection('friends')
          .get();

      List<Map<String, dynamic>> friendData = [];
      for (var friendDoc in friendsSnapshot.docs) {
        String friendId = friendDoc.id;
        String friendName = await fetchSenderName(friendId);

        // Fetch location data from USER_LOCATION
        DocumentSnapshot locationDoc = await FirebaseFirestore.instance
            .collection('USER_LOCATION')
            .doc(friendId)
            .get();

        double latitude = (locationDoc['latitude'] is String)
            ? double.tryParse(locationDoc['latitude']) ?? 0.0
            : locationDoc['latitude'] as double? ?? 0.0;

        double longitude = (locationDoc['longitude'] is String)
            ? double.tryParse(locationDoc['longitude']) ?? 0.0
            : locationDoc['longitude'] as double? ?? 0.0;

        friendData.add({
          'name': friendName,
          'latitude': latitude,
          'longitude': longitude,
        });
      }

      setState(() {
        friendsWithLocation = friendData;
      });

      _addFriendMarkers();
    } catch (e) {
      print('Error fetching friend names and locations: $e');
    }
  }

  Future<String> fetchSenderName(String senderId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('USER_INFO')
          .doc(senderId)
          .get();

      if (documentSnapshot.exists) {
        final data = documentSnapshot.data() as Map<String, dynamic>?;
        return data?['name'] ?? '알 수 없는 사용자';
      } else {
        return '알 수 없는 사용자';
      }
    } catch (e) {
      print('Error fetching sender Name: $e');
      return '알 수 없는 사용자';
    }
  }

  void _addFriendMarkers() {
    if (_mapController != null && friendsWithLocation.isNotEmpty) {
      for (var friend in friendsWithLocation) {
        double latitude = friend['latitude'];
        double longitude = friend['longitude'];
        String name = friend['name'];

        final friendMarker = NMarker(
          id: 'friend_marker_${latitude}_${longitude}',
          position: NLatLng(latitude, longitude),
          caption: NOverlayCaption(
            text: name,
            textSize: 20,
            color: Colors.green[700]!,
          ),
        );

        friendMarker.setOnTapListener((overlay) async {
          if (_currentPosition != null) {
            double currentLat = _currentPosition!.latitude;
            double currentLng = _currentPosition!.longitude;

            final Uri routeUrl = Uri.parse(
              'nmap://route/walk?slat=$currentLat&slng=$currentLng&sname=%EC%97%AC%EA%B8%B0%20%EC%9E%90%EB%A6%AC&dlat=$latitude&dlng=$longitude&dname=$name&appname=com.example.my_app',
            );

            if (await canLaunchUrl(routeUrl)) {
              await launchUrl(routeUrl);
            } else {
              print('Could not launch $routeUrl');
            }
          } else {
            print('Current position is null');
          }
        });

        _mapController!.addOverlay(friendMarker);
      }
    }
  }

  void _moveToFriendLocation(double latitude, double longitude, String name) {
    if (_mapController != null) {
      _mapController!.updateCamera(
        NCameraUpdate.scrollAndZoomTo(
          target: NLatLng(latitude, longitude),
        ),
      );
    }
  }

  void _showAddFriendDialog(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddFriend()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "친구 위치",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    _showAddFriendDialog(context);
                  },
                  icon: Icon(Icons.person_add, color: Colors.black),
                ),
              ],
            ),
          ),
          if (_currentPosition != null)
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: NaverMap(
                options: NaverMapViewOptions(
                  initialCameraPosition: NCameraPosition(
                    target: NLatLng(
                      _currentPosition!.latitude,
                      _currentPosition!.longitude,
                    ),
                    zoom: 14,
                  ),
                ),
                onMapReady: (controller) {
                  setState(() {
                    _mapController = controller;
                  });
                },
              ),
            )
          else
            Container(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(child: CircularProgressIndicator()),
            ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              itemCount: friendsWithLocation.length,
              itemBuilder: (context, index) {
                var friend = friendsWithLocation[index];
                String friendName = friend['name'];
                double latitude = friend['latitude'];
                double longitude = friend['longitude'];

                return Container(
                  margin: EdgeInsets.only(bottom: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                    border: Border.all(color: Colors.green, width: 2.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 12.0, vertical: 4.0),
                    leading: Icon(Icons.person, color: Colors.green, size: 24.0),
                    title: Text(
                      friendName,
                      style: TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),

                    trailing: Icon(Icons.arrow_forward_ios,
                        color: Colors.grey, size: 16.0),
                    onTap: () {
                      _moveToFriendLocation(latitude, longitude, friendName);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
